# shared-workflows

GitHub Action workflows that can be shared by multiple repositories

## Provided Workflows

### Default parameters

All workflows in this repository provide at least the following default
parameters that can be passed with `with:` from calling repositories:

- `jobs_run_on`: The runner group on which jobs will run. Default:
  `ubuntu-latest`
- `timeout_minutes`: The maximum time (in minutes) for a job to run. Default:
  `5`
- `working_directory`: The working directory where all jobs should be executed.
  Default: `.`

### adr-check-toc.yaml

This workflow runs `adrs generate toc --ordered` command using
[adrs](https://github.com/joshrotenberg/adrs) to generate the Table of Contents
for the ADRs in the repository. The workflow assumes the output goes to the
`README.md` in the same directory as the ADRs. This check makes sure PRs haven't
forgotten to run this command as part of their commits.

### ansible-lint.yaml

This workflow will setup [Python][5] (`3.12`) and lint the repository using both
[yamllint][13] and [ansible-lint](https://github.com/ansible/ansible-lint).
[Poetry][3] is used to install the [Python][5] dependencies. Both [yamllint][13]
and [ansible-lint](https://github.com/ansible/ansible-lint) are expected to be
installed by the [Poetry][3] configuration in the repository using this
workflow.

#### ansible-lint Inputs

- `additional_packages`: String of additional packages that should be installed.
  Default: ``
- `python_version`: The version of [Python][5] to use. Default: `3.12`

### close-stale.yaml

This workflow will close any issues or PRs that have been inactive for a certain
amount of time. By default, this is set to 30 days. This workflow is based on
the `actions/stale`.

```YAML
---
name: 'Close stale issues and PRs'

'on':
  schedule:
    - cron: '30 1 * * *'

jobs:
  stale:
    uses: broadinstitute/shared-workflows/.github/workflows/close-stale.yaml
```

#### close-stale Inputs

- `days_before_issue_stale`: Number of days before an issue is considered stale.
  Default to 60
- `days_before_pr_stale`: Description: Number of days before a PR is considered
  stale. Default to 60
- `days_before_issue_close`: The idle number of days before closing the stale
  issues or the stale pull requests (due to the stale label). Defaults to 5
- `days_before_pr_close`: The idle number of days before closing the stale
  issues or the stale pull requests (due to the stale label). Defaults to 10

### conventional-commit.yaml

This workflow will run the[commitlint](https://commitlint.js.org/) By default it
only checks that PR titles follow [Conventional Commits][1]. In addition the
'subject-case' and 'body-max-line-length' checks are disabled.

- `validate_pr_title`: Validate PR title. Default: true
- `validate_current_commit`: Validate current commit (last commit). Default:
  false
- validate_pr_commits: Validate PR commits. Default: false

#### Conventional Release-Labels

The conventional commit workflow will also add labels to the PR based on based
on Conventional Commits. By default, only labels are added.

These labels can be used in conjunction GitHub's
[automatically generated release notes](https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes)

In order to use this automatic release notes feature, you must have a
`.github/release.yaml` file similar to the following:

```YAML
changelog:
  exclude:
    labels:
      - ignore-for-release
    authors:
      - octocat
  categories:
    - title: Breaking Changes 🛠
      labels:
        - breaking
    - title: Exciting New Features 🎉
      labels:
        - feature
    - title: Fixes 🔧
      labels:
        - fix
    - title: Other Changes
      labels:
        - "*"
```

More info on this can be found in the
[release labels action](https://github.com/bcoe/conventional-release-labels?tab=readme-ov-file#conventional-release-labels)
and the
[release-please-action](https://github.com/googleapis/release-please-action)

### local-checks.yaml

These are local Actions that run for this repository. This workflow is not
visible or usable outside of this repository.

### pre-commit.yaml

This workflow runs the
[pre-commmit action](https://github.com/pre-commit/action) with minimal options
for configuration.

### prettier.yaml

This workflow will run [prettier](https://prettier.io/) to check formatting of
markdown files. The only option passed is `--prose-wrap always`.

### puppet-build.yaml

This workflow will setup [Puppet][7] using
[ruby/setup-ruby](https://github.com/ruby/setup-ruby) ([Ruby][8] version `3.2`).
The linting and dependency installations will all happen using [PDK][9]. The
[Puppet][7] module will be built with [PDK][9] and then installed using
`puppet module install` to test that the build and install process works as
expected.

#### puppet-build Inputs

- `puppet_package_name`: The name of the [Puppet][7] module the repo will
  create. Default: ``
- `puppet_version`: The version of [Puppet][7] to use in [PDK][9]. Default: `7`
- `ruby_version`: The version of [Ruby][8] to use. Default: `3.2`

### puppet-forge-deploy.yaml

This workflow will setup [Puppet][7] using
[ruby/setup-ruby](https://github.com/ruby/setup-ruby). The linting and
dependency installations will all happen using [PDK][9]. The [Puppet][7] module
will be built with [PDK][9] and then pushed to the [Puppet Forge][12].

#### puppet-forge-deploy Inputs

- `puppet_version`: The version of [Puppet][7] to use in [PDK][9]. Default: `7`
- `ruby_version`: The version of [Ruby][8] to use. Default: `3.2`

#### puppet-forge-deploy Secrets

- `forge_token`: The [Puppet Forge][12] token to use when deploying the module.

### puppet-lint.yaml

This workflow will setup [Puppet][7] using
[ruby/setup-ruby](https://github.com/ruby/setup-ruby) ([Ruby][8] version `3.2`).
The linting and dependency installations will all happen using [PDK][9].

#### puppet-lint Inputs

- `puppet_version`: The version of [Puppet][7] to use in [PDK][9]. Default: `7`
- `ruby_version`: The version of [Ruby][8] to use. Default: `3.2`

### puppet-unit-test.yaml

This workflow will setup [Puppet][7] using
[ruby/setup-ruby](https://github.com/ruby/setup-ruby). The testing will happen
on a matrix of [Ruby][8] and [Puppet][7] versions. The dependency installation
and unit tests will all happen using [PDK][9].

#### puppet-unit-test Inputs

- `puppet_versions`: The versions of [Puppet][7] to use in the unit tests,
  passed as a string in JSON format with `versions` as the key. Default:
  `'{ "versions": [ "7", "8" ] }'`
    - **Note: Make sure to enclose the JSON string in single quotes!!**
- `ruby_versions`: The versions of [Ruby][8] to use in the unit tests, passed as
  a string in JSON format with `versions` as the key. Default:
  `'{ "versions": [ "3.1", "3.2" ] }'`
    - **Note: Make sure to enclose the JSON string in single quotes!!**

### python-deploy-to-pypi.yaml

This workflow will setup [Python][5] (`3.12`) and do a build and deploy of the
[Python][5] package to [PyPi][2] using [Poetry][3].

#### python-deploy-to-pypi Inputs

- `additional_packages`: String of additional packages that should be installed.
  Default: ``
- `poetry_install_options`: Extra options to pass to Poetry when doing an
  install. Default: `--no-root`
- `python_version`: The version of [Python][5] to use. Default: `3.12`

#### python-deploy-to-pypi Secrets

- `pypi_token`: The PyPi token to use to deploy. This secret is required for
  this workflow to push to [PyPi][2]

### python-lint.yaml

This workflow will setup [Python][5] (`3.12`) and lint the repository.
[Poetry][3] is used to install any [Python][5] dependencies. By default the
linters run are [yamllint][13], and
[pylama](https://github.com/AtomLinter/linter-pylama). As of August 2023,
[pylama](https://github.com/AtomLinter/linter-pylama) has been deprecated, so
you can run [Ruff](https://github.com/astral-sh/ruff) as the [Python][5] linter
by setting the `use_ruff` input to `true`.

#### python-lint Inputs

- `additional_packages`: String of additional packages that should be installed.
  Default: ``
- `poetry_install_options`: Extra options to pass to Poetry when doing an
  install. Default: `--no-root`
- `python_version`: The version of [Python][5] to use. Default: `3.12`
- `ruff_version`: The version of [Ruff](https://github.com/astral-sh/ruff) to
  run. Default: `0.8.1`
- `use_pylama`: If true, use
  [pylama](https://github.com/AtomLinter/linter-pylama) to lint the repository.
  Default: `true`
- `use_ruff`: If true, use [Ruff](https://github.com/astral-sh/ruff) to lint the
  repository. Default: `false`

### python-make-ci.yaml

This workflow will setup [Python][5] (`3.12`) and run `make ci` on the
repository. [Poetry][3] is used to install any [Python][5] dependencies. It is
the responsibility of the repository owner to correctly setup a `Makefile` to
correctly do all the CI tasks for their repository. The `prettier` application
as well as Node 22.x are also available to this workflow.

#### python-make-ci Inputs

There are no additional inputs for this workflow. Additionally, the
`jobs_run_on` input is not available for this workflow as the job is forced to
use `ubuntu-latest` for the base image.

### python-test-deploy-to-pypi.yaml

This workflow will setup [Python][5] (`3.12`) and do a build and deploy of the
[Python][5] package to [Test PyPi][6] using [Poetry][3].

#### python-test-deploy-to-pypi Inputs

- `additional_packages`: String of additional packages that should be installed.
  Default: ``
- `poetry_install_options`: Extra options to pass to Poetry when doing an
  install. Default: `--no-root`
- `python_version`: The version of [Python][5] to use. Default: `3.12`

#### python-test-deploy-to-pypi Secrets

- `pypi_test_token`: The PyPi token to use to deploy. This secret is required
  for this workflow to push to [Test PyPi][6]

### python-unit-test.yaml

This workflow will setup a matrix of [Python][5] versions and run the unit tests
for the repository using [green](https://github.com/CleanCut/green). [Poetry][3]
is used to install any [Python][5] dependencies.

#### python-unit-test Inputs

- `additional_packages`: String of additional packages that should be installed.
  Default: ``
- `poetry_install_options`: Extra options to pass to Poetry when doing an
  install. Default: `--no-root`
- `python_package_name`: The name of the [PyPi][2] package the repo will create.
  Default: ``
- `python_versions`: The versions of [Python][5] to use in the unit tests,
  passed as a string in JSON format with `versions` as the key. Default:
  `'{ "versions": [ "3.9", "3.10", "3.11", "3.12" ] }'`
    - **Note: Make sure to enclose the JSON string in single quotes!!**
- `run_coverage`: Boolean to determine whether coverage should be run or not.
  Default: `true`
- `test_runner`: The runner used to run all the unit tests. Default: `green`
- `test_targets`: A list of directories to target for testing. Runners should
  autodetect if left blank. Default: ``

### terraform-docs.yaml

This workflow will setup and run [terraform-docs](https://terraform-docs.io/) to
generate the [Terraform][10] documentation and store it in the README.md.

#### terraform-docs Inputs

- `config_file`: The path to the configuration file. Default:
  `.terraform-docs.yml`
- `git_push`: If set to true, push the changes to the repository. Default:
  `false`
- `output_file`: The path to the output file. Default: `README.md`
- `output_method`: The method to use for output. Default: `inject`
- `terragrunt_directory`: The environment directory from which Terragrunt should
  run. Default: `prod`
- `use_terragrunt`: If set to true, use Terragrunt instead of Terraform.
  Default: `false`

### terraform-lint.yaml

This workflow will setup and run
[tflint](https://github.com/terraform-linters/tflint) as well as the
[pre-commit/action](https://github.com/pre-commit/action) Action to run
[pre-commit](https://pre-commit.com/).

#### terraform-lint Inputs

- `tflint_config_path`: The relative path to the TFlint configuration file.
  Default: `.tflint.hcl`

### terraform-static-analyze.yaml

This workflow will setup and run some static analysis tools for [Terraform][10].
The only test that runs by default is
[tfsec](https://github.com/aquasecurity/tfsec) using the
[aquasecurity/tfsec-pr-commenter-action](https://github.com/aquasecurity/tfsec-pr-commenter-action)
Action. You can optionally run [Checkov](https://www.checkov.io/) (using the
[bridgecrewio/checkov-action](https://github.com/bridgecrewio/checkov-action)
Action) and [Trivy](https://trivy.dev/) (using the
[aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)
Action).

#### terraform-static-analyze Inputs

- `run_checkov`: If set to true, run checkov tests. Default: `false`
- `run_tfsec`: If set to true, run tfsec tests. Default: `true`
- `run_trivy`: If set to true, run Trivy tests. Default: `false`
- `trivy_skip_files`: A comma-separated list of files Trivy should ignore.
  Default: ``

#### terraform-static-analyze Secrets

- `wf_github_token`: Description: The GitHub token to use when running
  [tfsec](https://github.com/aquasecurity/tfsec) so that it can post comments to
  the PR. If you decide to set `run_tfsec` to `false`, this secret does not need
  to be provided.

### terraform-validate.yaml

This workflow will setup and run basic validations for [Terraform][10] and
optionally [Terragrunt][11] if you use it in your repository. If you do not use
[Terragrunt][11], all of the inputs with `terragrunt` in the name are not
needed.

If `use_terragrunt` is set to `false`, the workflow just do a `terraform init`
and a `terraform validate`. If `use_terragrunt` is set to `true`, a
`terragrunt init` and `terragrunt validate` will be run, but the
[Terragrunt][11]-specific check `terragrunt hclfmt` will also be run.

#### terraform-validate Inputs

- `terraform_version`: The version of Terraform to use when validating. Default:
  `1.10.0`
- `terragrunt_directory`: The environment directory from which Terragrunt should
  run. Default: `prod`
- `terragrunt_version`: The version of Terragrunt to use when validating.
  Default: `0.69.3`
- `use_terragrunt`: If set to true, use Terragrunt instead of Terraform.
  Default: `false`

## Releases

Releases are now done through the GitHub
[Release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
system. The easiest way to create a new release draft is using the GitHub CLI
(`gh`). For example, to create a new draft release for version `v2.7.0` with
autogenerated notes:

```Shell
gh release create v2.7.0 --draft --generate-notes --title v2.7.0
```

[1]: https://www.conventionalcommits.org/ "Conventional Commits"
[2]: https://pypi.org/ "PyPi"
[3]: https://python-poetry.org/ "Poetry"
[5]: https://www.python.org/ "Python"
[6]: https://test.pypi.org/ "Test PyPi"
[7]: https://www.puppet.com/ "Puppet"
[8]: https://www.ruby-lang.org/en/ "Ruby"
[9]: https://www.puppet.com/docs/pdk/3.x/pdk.html "PDK"
[10]: https://www.terraform.io/ "Terraform"
[11]: https://terragrunt.gruntwork.io/ "Terragrunt"
[12]: https://forge.puppet.com/ "Puppet Forge"
[13]: https://github.com/adrienverge/yamllint "yamllint"
