# frozen_string_literal: true

module Jiminy
  require "thor"
  require "byebug"
  class CLI < Thor
    require "jiminy/reporting/ci_providers/circle_ci"
    include Jiminy::Reporting::CIProviders

    class WorkflowStillRunningError < StandardError; end
    private_constant :WorkflowStillRunningError

    MAX_TIMEOUT = 1800 # 1 hour
    POLL_INTERVAL = 60 # 1 min

    def self.exit_on_failure?
      false
    end

    desc "Report results", "Reports the results of tests"
    method_option :commit, type: :string, aliases: "c", required: true,
                           banner: "3e078f8770743549b722382ec5d412a30b9fdcc5",
                           desc: "The full SHA for the current HEAD commit"
    method_option :pr_number, type: :numeric, aliases: %w[pr p], required: true,
                              banner: "1",
                              desc: "The GitHub PR number"
    method_option :dry_run, type: :boolean, default: false, lazy_default: true,
                            desc: "Print to STDOUT instead of leaving a comment on GitHub"
    method_option :timeout, type: :numeric, aliases: %w[max-timeout], default: MAX_TIMEOUT,
                            desc: "How long to poll CircleCI before timing out (in seconds)"
    method_option :poll_interval, type: :numeric, aliases: %w[poll-interval], default: POLL_INTERVAL,
                                  desc: "How frequently to poll CircleCI (in seconds)"
    def report
      self.start_time = Time.now
      artifact_urls = artifacts.map(&:url)

      Jiminy::Reporting.report!(*artifact_urls,
                                pr_number: options[:pr_number],
                                dry_run: options[:dry_run])

      $stdout.puts "Reported N+1s successfully"
      exit(0)
    end

    # rubocop:disable Metrics/BlockLength
    no_tasks do
      attr_accessor :start_time

      def poll_interval
        options[:poll_interval] || POLL_INTERVAL
      end

      def max_timeout
        options[:timeout] || MAX_TIMEOUT
      end

      def timed_out?
        (Time.now - start_time) > max_timeout
      end

      def git_revision
        options[:commit]
      end

      def pr_number
        options[:pr_number]
      end

      def pipeline
        @_pipeline ||= CircleCI::Pipeline.find_by_revision(git_revision: git_revision, pr_number: pr_number) or
          abort("No such Pipeline with commit SHA #{git_revision}")
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
      def workflow
        @_workflow ||= begin
          result = CircleCI::Workflow.find(pipeline_id: pipeline.id, workflow_name: Jiminy.config.ci_workflow_name)
          if result.nil?
            abort("Unable to find workflow called '#{Jiminy.config.ci_workflow_name}' in Pipeline #{pipeline.id}")
          end

          if result.not_run? || result.running?
            $stdout.puts "Workflow still running..."
            raise(WorkflowStillRunningError)
          end
          abort("Workflow #{result.status}—aborting...") unless result.success?

          result
        rescue WorkflowStillRunningError
          sleep(poll_interval)
          $stdout.puts "Retrying..."
          retry unless timed_out?

          abort("Process timed out after #{Time.now - start_time} seconds")
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity

      def jobs
        @_jobs ||= CircleCI::Job.all(workflow_id: workflow.id)
      end

      def artifacts
        @_artifacts ||= CircleCI::Artifact.all(job_number: jobs.first.job_number)
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
