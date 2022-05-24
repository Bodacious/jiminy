# frozen_string_literal: true

module Jiminy
  require "thor"
  class CLI < Thor
    require "jiminy/reporting/ci_providers/circle_ci"
    require "jiminy/cli/exit_codes"

    include Thor::Actions
    include Jiminy::Reporting::CIProviders

    class WorkflowStillRunningError < StandardError; end
    private_constant :WorkflowStillRunningError

    MAX_TIMEOUT_SECONDS = 1800
    POLL_INTERVAL_SECONDS = 60

    source_root File.expand_path("templates/", __dir__)

    def self.exit_on_failure?
      false
    end

    desc "Report results", "Reports the results of tests"
    method_option :commit, type: :string, aliases: "c", required: true,
      banner: "3e078f8770743549b722382ec5d412a30b9fdcc5",
      desc: "The full SHA for the current HEAD commit"
    method_option :pr_number, type: :numeric, aliases: %w(pr p), required: true,
      banner: "1",
      desc: "The GitHub PR number"
    method_option :dry_run, type: :boolean, default: false, lazy_default: true,
      desc: "Print to STDOUT instead of leaving a comment on GitHub"
    method_option :timeout, type: :numeric, aliases: %w(max-timeout), default: MAX_TIMEOUT_SECONDS,
      desc: "How long to poll CircleCI before timing out (in seconds)"
    method_option :poll_interval, type: :numeric, aliases: %w(poll-interval), default: POLL_INTERVAL_SECONDS,
      desc: "How frequently to poll CircleCI (in seconds)"
    method_option :source, type: :string, default: "circleci",
      desc: "Where are the results.yml files we should report?"
    def report
      self.start_time = Time.now
      artifact_urls = artifacts.map(&:url)
      Jiminy::Reporting.report!(*artifact_urls,
        pr_number: options[:pr_number],
        dry_run: options[:dry_run])

      finish(ExitCodes::Success)
    end

    desc "Install Jiminy", "Installs jiminy configuration files in your app"
    def init
      template("config.rb", "./config/jiminy.rb")
    end

    # rubocop:disable Metrics/BlockLength
    no_tasks do
      attr_accessor :start_time

      def finish(exit_code_klass, *args, **kwargs)
        exit_code = exit_code_klass.new(*args, **kwargs)
        if exit_code.value == 0
          puts exit_code
        else
          warn exit_code
        end
        exit(exit_code.value)
      end

      def poll_interval
        options[:poll_interval] || POLL_INTERVAL_SECONDS
      end

      def source
        options[:source] || :circleci
      end

      def max_timeout
        options[:timeout] || MAX_TIMEOUT_SECONDS
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
          finish(ExitCodes::PipelineNotFound, git_revision: git_revision)
      end

      def missing_options
        [].tap do |array|
          array.concat("--pr-number") unless pr_number
          array.concat("--commit") unless git_revision
        end
      end

      # rubocop:disable Metrics/AbcSize
      def workflow
        @_workflow ||= begin
          result = CircleCI::Workflow.find(pipeline_id: pipeline.id, workflow_name: Jiminy.config.ci_workflow_name)
          if result.nil?
            finish(ExitCodes::WorkflowNotFound,
              workflow_name: Jiminy.config.ci_workflow_name,
              pipeline_id: pipeline.id)
          end

          if result.not_run? || result.running?
            $stdout.puts "Workflow still running..."
            raise(WorkflowStillRunningError)
          end
          finish(ExitCodes::WorkflowNotSuccess,
            status: result.status) unless result.success?

          result
        rescue WorkflowStillRunningError
          sleep(poll_interval)
          $stdout.puts "Retrying..."
          retry unless timed_out?

          finish(ExitCodes::ProcessTimeout, start_time: start_time)
        end
      end
      # rubocop:enable Metrics/AbcSize

      def jobs
        @_jobs ||= CircleCI::Job.all(workflow_id: workflow.id)
      end

      def artifacts
        @_artifacts ||= begin
          unless respond_to?(:"artifacts_from_#{source}")
            raise ArgumentError, "Uknown value for source option #{source}"
          end

          public_send(:"artifacts_from_#{source}")
        end
      end

      def artifacts_from_local
        Local::Artifact.all
      end

      def test_job
        @_test_job ||= jobs.detect { |job| job.name == Jiminy.config.ci_job_name }
      end

      def artifacts_from_circle_ci
        CircleCI::Artifact.all(job_number: test_job.job_number)
      end
      alias_method :artifacts_from_circleci, :artifacts_from_circle_ci
    end
    # rubocop:enable Metrics/BlockLength
  end
end
