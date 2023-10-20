# shared-workflows

GitHub Action workflows that can be shared by multiple repositories

## Provided Workflows

### Default parameters

All workflows in this repository provide at least the following default parameters that can be passed with `with:` from calling repositories:

* `jobs_run_on`: The runner group on which jobs will run. Default: `ubuntu-latest`
* `timeout_minutes`: The maximum time (in minutes) for a job to run. Default: `5`
* `working_directory`: The working directory where all jobs should be executed. Default: `.`

### conventional-commits.yml

This workflow will run the [lab42/conventional-commit](https://github.com/lab42/conventional-commit) action with a `description_regexp` of `(.*)`. This check makes sure commits and PR titles follow [Conventional Commits][1].

### local-checks.yml

These are local Actions that run for this repository. This workflow is not visible or usable outside of this repository.

### markdown-lint.yml

This workflow will run the [DavidAnson/markdownlint-cli2-action](https://github.com/DavidAnson/markdownlint-cli2-action) action to lint markdown files.

#### markdown-lint Inputs

* `config_file`: The configuration file to use. Default: `.markdownlint-cli2.yaml`
* `fix`: If set to true, fix any issues found. Default: `false`
* `globs`: The glob to use to find all markdown files. Default: `**/*.md`
* `separator`: The character used to separate globs. Default: `,`

### poetry-deploy.yml

This workflow will setup [Python][5] (`3.1.1`) and do a build and deploy of the [Python][5] package to [PyPi][2] using [Poetry][3].

#### poetry-deploy Inputs

* `additional_packages`: String of additional packages that should be installed. Default: ``

#### poetry-deploy Secrets

* `pypi_token`: The PyPi token to use to deploy. This secret is required for this workflow to push to [PyPi][2]

### poetry-linting.yml

This workflow will setup [Python][5] (`3.1.1`) and lint the repository. [Poetry][3] is used to install any [Python][5] dependencies. By default the linters run are [yamllint](https://github.com/adrienverge/yamllint), and [pylama](https://github.com/AtomLinter/linter-pylama). As of August 2023, [pylama](https://github.com/AtomLinter/linter-pylama) has been deprecated, so you can run [Ruff](https://github.com/astral-sh/ruff) as the [Python][5] linter by setting the `use_ruff` input to `true`.

#### poetry-linting Inputs

* `additional_packages`: String of additional packages that should be installed. Default: ``
* `ruff_version`: The version of [Ruff](https://github.com/astral-sh/ruff) to run. Default: `0.1.0`
* `use_pylama`: If true, use [pylama](https://github.com/AtomLinter/linter-pylama) to lint the repository. Default: `true`
* `use_ruff`: If true, use [Ruff](https://github.com/astral-sh/ruff) to lint the repository. Default: `false`

### poetry-test-deploy.yml

This workflow will setup [Python][5] (`3.1.1`) and do a build and deploy of the [Python][5] package to [Test PyPi][6] using [Poetry][3].

#### poetry-test-deploy Inputs

* `additional_packages`: String of additional packages that should be installed. Default: ``

#### poetry-test-deploy Secrets

* `pypi_test_token`: The PyPi token to use to deploy. This secret is required for this workflow to push to [Test PyPi][6]

### poetry-unit-tests.yml

This workflow will setup a matrix of [Python][5] versions (currently `['3.7', '3.8', '3.9', '3.10', '3.11']`) and run the unit tests for the repository using [green](https://github.com/CleanCut/green). [Poetry][3] is used to install any [Python][5] dependencies.

#### poetry-unit-tests Inputs

* `additional_packages`: String of additional packages that should be installed. Default: ``
* `python_package_name`: The name of the [PyPi][2] package the repo will create. Default: ``

### puppet-linting.yml

This workflow will setup [Puppet][7] using [ruby/setup-ruby](https://github.com/ruby/setup-ruby) ([Ruby][8] version `3.2`). The linting and dependency installations will all happen using [PDK][9].

#### puppet-linting Inputs

* `puppet_version`: The version of [Puppet][7] to use in [PDK][9]. Default: `7`

### puppet-test-deploy.yml

This workflow will setup [Puppet][7] using [ruby/setup-ruby](https://github.com/ruby/setup-ruby) ([Ruby][8] version `3.2`). The linting and dependency installations will all happen using [PDK][9]. The [Puppet][7] module will be built with [PDK][9] and then installed using `puppet module install` to test that the build and install process works as expected.

#### puppet-test-deploy Inputs

* `puppet_version`: The version of [Puppet][7] to use in [PDK][9]. Default: `7`
* `puppet_package_name`: The name of the [Puppet][7] module the repo will create. Default: ``

### puppet-unit-tests.yml

This workflow will setup [Puppet][7] using [ruby/setup-ruby](https://github.com/ruby/setup-ruby). The testing will happen on a matrix of [Ruby][8] versions `3.1` and `3.2` and [Puppet][7] versions `7` and `8`. The dependency installation and unit tests will all happen using [PDK][9].

### terraform-linting.yml

This workflow will setup and run [tflint](https://github.com/terraform-linters/tflint) as well as the [pre-commit/action](https://github.com/pre-commit/action) Action to run [pre-commit](https://pre-commit.com/).

#### terraform-linting Inputs

* `tflint_config_path`: The relative path to the TFlint configuration file. Default: `.tflint.hcl`

### terraform-static-analysis.yml

This workflow will setup and run some static analysis tools for [Terraform][10]. The only test that runs by default is [tfsec](https://github.com/aquasecurity/tfsec) using the [aquasecurity/tfsec-pr-commenter-action](https://github.com/aquasecurity/tfsec-pr-commenter-action) Action. You can optionally run [Checkov](https://www.checkov.io/) (using the [bridgecrewio/checkov-action](https://github.com/bridgecrewio/checkov-action) Action) and [Trivy](https://trivy.dev/) (using the [aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action) Action).

#### terraform-static-analysis Inputs

* `run_checkov`: If set to true, run checkov tests. Default: `false`
* `run_tfsec`: If set to true, run tfsec tests. Default: `true`
* `run_trivy`: If set to true, run Trivy tests. Default: `false`

#### terraform-static-analysis Secrets

* `wf_github_token`: Description: The GitHub token to use when running [tfsec](https://github.com/aquasecurity/tfsec) so that it can post comments to the PR. If you decide to set `run_tfsec` to `false`, this secret does not need to be provided.

### terraform-validation.yml

This workflow will setup and run basic validations for [Terraform][10] and optionally [Terragrunt][11] if you use it in your repository. If you do not use [Terragrunt][11], all of the inputs with `terragrunt` in the name are not needed.

If `use_terragrunt` is set to `false`, the workflow just do a `terraform init` and a `terraform validate`. If `use_terragrunt` is set to `true`, a `terragrunt init` and `terragrunt validate` will be run, but the [Terragrunt][11]-specific check `terragrunt hclfmt` will also be run.

#### terraform-validation Inputs

* `terraform_version`: The version of Terraform to use when validating. Default: `1.5.5`
* `terragrunt_directory`: The environment directory from which Terragrunt should run. Default: `prod`
* `terragrunt_version`: The version of Terragrunt to use when validating. Default: `0.48.7`
* `use_terragrunt`: If set to true, use Terragrunt instead of Terraform. Default: `false`

## Changelog

To generate the `CHANGELOG.md`, you will need [Docker][4] and a GitHub personal access token.  We currently use [github-changelog-generator](https://github.com/github-changelog-generator/github-changelog-generator) for this purpose.  The following should generate the file using information from GitHub:

```sh
docker run -it --rm \
    -e CHANGELOG_GITHUB_TOKEN='yourtokenhere' \
    -v "$(pwd)":/working \
    -w /working \
    githubchangeloggenerator/github-changelog-generator:latest --verbose
```

To generate the log for an upcoming release that has not yet been tagged, you can run a command to include the upcoming release version.  For example, `2.0.0`:

```sh
docker run -it --rm \
    -e CHANGELOG_GITHUB_TOKEN='yourtokenhere' \
    -v "$(pwd)":/working \
    -w /working \
    githubchangeloggenerator/github-changelog-generator:latest --verbose --future-release 2.0.0 --unreleased
```

As a note, this repository uses the default labels for formatting the `CHANGELOG.md`.  Label information can be found here: [Advanced-change-log-generation-examples](https://github.com/github-changelog-generator/github-changelog-generator/wiki/Advanced-change-log-generation-examples#section-options)

[1]: https://www.conventionalcommits.org/ "Conventional Commits"
[2]: https://pypi.org/ "PyPi"
[3]: https://python-poetry.org/ "Poetry"
[4]: https://www.docker.com/ "Docker"
[5]: https://www.python.org/ "Python"
[6]: https://test.pypi.org/ "Test PyPi"
[7]: https://www.puppet.com/ "Puppet"
[8]: https://www.ruby-lang.org/en/ "Ruby"
[9]: https://www.puppet.com/docs/pdk/3.x/pdk.html "PDK"
[10]: https://www.terraform.io/ "Terraform"
[11]: https://terragrunt.gruntwork.io/ "Terragrunt"
