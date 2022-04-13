Jiminy.configure do |config|
  config.ci_workflow_name = "build_and_test"

  config.project_username = "<your github username>"

  config.project_reponame = Rails.application.name

  config.circle_ci_api_token = ENV["CIRCLE_CI_API_TOKEN"]

  config.github_token = ENV["GITHUB_TOKEN"]

  config.ignore_file_path = File.join("./.jiminy_ignores.yml")

  config.temp_file_location = File.join("./tmp/jiminy/results.yml")
end
