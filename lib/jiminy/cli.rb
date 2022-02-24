module Jiminy
  require "thor"
  class CLI < Thor
    require "jiminy/reporting/ci_providers/circle_ci"

    desc "Report results", "Reports the results of tests"
    method_option :commit, aliases: "-c"
    def report
      puts Jiminy::Reporting::CIProviders::CircleCI::Pipeline.find_by_revision(options[:commit])
      exit(0)
    end
  end
end



# PIPELINE = Pipeline.find_by_revision(ARGV[0])

# def report_failure
#   puts "Workflow failed. Aborting..."
#   exit(1)
# end

# def report_n_plus_ones_to_github(workflow)
#   jobs = CircleCI::Job.all(workflow_id: workflow.id)
#   artifacts = CircleCI::Artifact.all(job_number: jobs.first.job_number)
#   Jiminy.report! *artifacts.map(&:url)
#   puts "Reported N+1s successfully"
#   exit(0)
# end

# def report_unknown_status_failure(status)
#   puts "Workflow failed. Unknown status #{status}"
#   exit(1)
# end

# def poll_circle_ci_API!
#   puts "Polling circleCI API..."

#   workflow = CircleCI::Workflow.find(pipeline_id: PIPELINE.id, workflow_name: "build_and_test")
#   case workflow.status
#   when CircleCI::Workflow::RUNNING, CircleCI::Workflow::NOT_RUN
#     sleep(WAIT_TIME)
#     poll_circle_ci_API!
#   when CircleCI::Workflow::FAILED
#     report_failure
#   when CircleCI::Workflow::SUCCESS
#     report_n_plus_ones_to_github(workflow)
#   else
#     report_unknown_status_failure(workflow.status)
#   end
# end

# poll_circle_ci_API!
