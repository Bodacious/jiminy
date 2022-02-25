# frozen_string_literal: true

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
      artifact_urls = artifacts(options[:commit], options[:pr_number]).map(&:url)

      Jiminy::Reporting.report!(*artifact_urls,
                                pr_number: options[:pr_number],
                                dry_run: options[:dry_run])

      $stdout.puts "Reported N+1s successfully"
      exit(0)
    end

    def self.exit_on_failure?
      false
    end

    no_tasks do
      # rubocop:disable Metrics/AbcSize
      def artifacts(git_revision, pr_number)
        pipeline = CircleCI::Pipeline.find_by_revision(git_revision: git_revision, pr_number: pr_number)
        pipeline or abort("No such Pipeline with commit #{commit}")

        workflow = CircleCI::Workflow.find(pipeline_id: pipeline.id, workflow_name: Jiminy.config.ci_workflow_name)
        if workflow.not_run? || workflow.running?
          $stdout.puts "Workflow still running... check again"
          exit(2)
        end

        workflow.success? or abort("Workflow #{workflow.status}—aborting...")

        jobs = CircleCI::Job.all(workflow_id: workflow.id)
        CircleCI::Artifact.all(job_number: jobs.first.job_number)
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
