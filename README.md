<!-- BEGIN:AVATAR -->
![Avatar](avatar.jpg)
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
[![Build Status](https://github.com/cliffano/generator-rust/workflows/CI/badge.svg)](https://github.com/cliffano/generator-rust/actions?query=workflow%3ACI)
[![Code Scanning Status](https://github.com/cliffano/generator-rust/workflows/CodeQL/badge.svg)](https://github.com/cliffano/generator-rust/actions?query=workflow%3ACodeQL)
[![Security Status](https://snyk.io/test/github/cliffano/generator-rust/badge.svg)](https://snyk.io/test/github/cliffano/generator-rust)
<!-- END:BADGES -->

# Generator Rust

Generator Rust is a code generator for Rust packages.

It provides the following components:

| Component | Description |
|-----------|-------------|
| rust-cli | Generate a Rust binary crate (CLI) project. |
| rust-cli-partials | Generate README partial snippets for Rust CLI projects. |
| rust-lib | Generate a Rust library crate project. |
| rust-lib-partials | Generate README partial snippets for Rust Lib projects. |

## Usage

Generate code generator project:

```shell
make generate-rust-cli
make generate-rust-lib
```

Generate Rust partial snippets:

```shell
make generate-rust-cli-partials
make generate-rust-lib-partials
```

This component will prompt you the following inputs:

| Prompt | Description |
|--------|-------------|
| Project ID | Used for the crate name and project repo name. |
| Project Name | Used in documentation or comments. |
| Project Description | Used in documentation or comments. |
| Author Name | The name of the project author. |
| Author Email | The email of the project author. |
| Author URL | The author's website URL. |
| GitHub ID | The GitHub ID of the project repo. |
| GitHub Repository | The name of the project's GitHub repository. |
| GitHub Actions token prefix | Prefix of the GitHub Actions secret used for the GitHub token. |

Move to the generated project directory:

```shell
cd stage/rust-cli/
cd stage/rust-lib/
```

## Usage With Config File

Each component also has a `-with-config` target that skips the interactive prompts by reading the inputs from a Crust YAML config file. See [examples/](examples/) for sample config files for each component.

Pass the config file path via the `GENERATOR_CONFIG` variable, it defaults to `crust.yml`:

```shell
make generate-rust-cli-with-config GENERATOR_CONFIG=path/to/crust.yml
make generate-rust-cli-partials-with-config GENERATOR_CONFIG=path/to/crust.yml
make generate-rust-lib-with-config GENERATOR_CONFIG=path/to/crust.yml
make generate-rust-lib-partials-with-config GENERATOR_CONFIG=path/to/crust.yml
```

## Configuration

| Key | Value |
|-----|-------|
| project_id | generator-rust |
| project_name | Generator Rust |
| project_desc | Code generator for Rust packages |
| author_name | Cliffano Subagio |
| author_email | blah@cliffano.com |
| github_id | cliffano |
| github_repo | generator-rust |

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
[Developer's Guide](https://cliffano.github.io/developers-guide-makefile.html)
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
Build reports:

<!-- END:BUILD_REPORTS -->

Related Projects:

* [Crust](https://github.com/cliffano/crust) - Makefile for building Rust packages
