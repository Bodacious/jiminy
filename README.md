# Jiminy

## Your external conscience when creating pull requests

Jiminy wraps around your test suite and detects n+1 queries in your code. Once your test suite has run, these can be reported in GitHub PR comments.

## How it works

Under the hood, Jiminy uses [Prosopite](https://github.com/charkost/prosopite) to detect N+1 queries.

When running RSpec tests, Jiminy extends Prosopite to log the n+1 instances it detects to a temp file (by default, `tmp/jiminy/results`).

Via a command-line interface, Jiminy will then report these n+1 queries by commenting in the related PR on GitHub.

## How it looks

## Assumptions

Jiminy is still pre-release. The current version assumes the following:

- Your application is built in Ruby on Rails
- You are using RSpec as your test suite
- You are running your tests on CircleCI
- Your code repository is on GitHub

## Installation

### Installing the gem

Add the following to your test and development groups:

``` ruby
group :development, :test do
  gem "jiminy"
end
```

### Extending your test suite

Add the following in `spec/support.rb`:

``` ruby
require "jiminy/rspec"

RSpec.configure do |config|
  config.before(:suite) { Jiminy.reset_results_file! }
  config.around do |example|
    Jiminy.wrap_rspec_example(example)
  end
end
```

### Running the CLI

``` bash
bundle exec jiminy report --commit b4742289dDDD364fd983fd57787dda74134acbaf --dry-run --pr-number=2 --poll-interval=5 --timeout=20
```


## Configuration

Add an initializer to your Rails initializers directory:

``` ruby
Jiminy.configure do |config|
  config.ci_workflow_name = "build_and_test"

  config.project_username = "bodacious"

  # NOTE: This is case sensitive on CircleCI
  config.project_reponame = "jiminy"

  config.circle_ci_api_token = ENV["CIRCLE_CI_API_TOKEN"]

  config.github_token = ENV["GITHUB_TOKEN"]

  # config.ignore_file_path =  File.join("./jiminy_ignores.yml")

  # config.temp_file_location = File.join("./tmp/jiminy/results.yml")
end
```

_NOTE: This file must be named `config/initializers/jiminy.rb` or **the gem will not detect the configuration**._


## How to run the test suite

Jiminy testing is still fairly sparse. To run the existing tests use:


``` bash
$ rspec spec
```

or

``` bash
$ rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bodacious/jiminy.
