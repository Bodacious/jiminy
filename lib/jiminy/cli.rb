module Jiminy
  require "thor"
  require "byebug"
  class CLI < Thor
    require "jiminy/reporting/ci_providers/circle_ci"
    include Jiminy::Reporting::CIProviders
    desc "Report results", "Reports the results of tests"
    method_option :commit, type: :string, aliases: "c", required: true
    method_option :pr_number, type: :numeric, aliases: %w[pr p], required: true
    method_option :dry_run, type: :boolean, default: false, lazy_default: true
    def report
      pipeline = CircleCI::Pipeline.find_by_revision(options[:commit])
      workflow = CircleCI::Workflow.find(pipeline_id: pipeline.id, workflow_name: Jiminy.config.ci_workflow_name)
      if workflow.not_run? || workflow.running?
        $stdout.puts "Workflow still running... check again"
        exit(2)
      end

      abort("Workflow #{workflow.status}—aborting...") unless workflow.success?

      jobs = CircleCI::Job.all(workflow_id: workflow.id)
      # debugger
      puts jobs.first.inspect
      artifacts = CircleCI::Artifact.all(job_number: jobs.first.job_number)
      puts artifacts.first.inspect
      Jiminy::Reporting.report!(*artifacts.map(&:url),
                                pr_number: options[:pr_number],
                                dry_run: options[:dry_run])

      $stdout.puts "Reported N+1s successfully"
      exit(0)
    end
  end
end
