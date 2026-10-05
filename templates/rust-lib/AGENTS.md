# AGENTS.md

This repository contains a Rust library crate project following a unified standard for tooling, build automation, and coding conventions. All projects share the same tooling stack and conventions to ensure consistency and maintainability.

The key components of the standard include:

- Build automation (Crust)
- Project definition and dependency management (Cargo)
- Code formatting (rustfmt)
- Static analysis (Clippy)
- Dependency vulnerability scanning (cargo-audit)
- Code complexity reporting (rust-code-analysis)
- Testing (Cargo's built-in test runner)
- Coverage (cargo-llvm-cov)

This document outlines the common conventions that apply across the Rust projects.

## Rust Version & Dependencies

- **Rust Edition**: 2021
- **Dependency Manager**: Cargo
- **Lock File**: `Cargo.lock` (not checked in — this is a library crate; consumers resolve their own dependency versions)
- **Dependency Specification**: `Cargo.toml`

### Adding Dependencies

```bash
cargo add package_name              # Add to runtime deps
cargo add --dev package_name        # Add to dev deps
make deps                           # Install toolchain components and supporting CLI tools
```

## Project Structure

```text
project/
├── src/                      # Source files
│   ├── lib.rs                    # Library root, re-exports modules
│   ├── display.rs                # Core logic module
│   └── message.rs                # Core logic module
├── examples/                 # Cargo examples (cargo run --example <name>) and sample configs
│   ├── display.rs
│   └── <project>.yaml
├── tests/                    # Integration tests (Cargo's own convention)
│   └── integration_test.rs
├── stage/                    # Temporary stage files
├── .github/                  # GitHub workflows
├── .gitignore                # Git ignore rules
├── .rtk.json                 # RTK configuration
├── .yamllint                 # yamllint configuration
├── avatar.jpg                # Project avatar (80x80 pixels)
├── AGENTS.md                 # Agent instructions (this file)
├── CHANGELOG.md              # Changelog file following Keep a Changelog format
├── clippy.toml                # Clippy configuration
├── rustfmt.toml               # rustfmt configuration
├── Cargo.toml                 # Crate manifest
├── crust.yml                  # Crust configuration
├── LICENSE                    # License file
├── Makefile                   # Build automation (Crust)
├── Makefile-extras            # Additional Makefile targets specific to the project
└── README.md                  # Project README
```

## Build Automation (Crust)

This Rust project uses **Crust** as a standard build automation tool that unifies the build pipeline across all Rust projects. The Makefile is sourced from the Crust project and managed via `make update-to-latest` / `make update-to-version`.

Unlike the Node.js/Python equivalents (Suntory/PieMaker), there is no single build-executor CLI wrapping every step — Cargo and its subcommands (`cargo fmt`, `cargo clippy`, `cargo test`, `cargo llvm-cov`, etc.) are invoked directly from the Makefile, since Cargo's own subcommand ecosystem already provides a consistent interface.

### Common Commands

```bash
make ci                # Run full CI pipeline
make all               # Alias for ci
make clean             # cargo clean + remove stage/
make stage             # Create stage/gh-pages/ directory
make deps              # Install clippy/rustfmt components and supporting cargo subcommands
make deps-upgrade      # Upgrade dependencies using cargo update
make rmdeps            # cargo clean (Cargo does not vendor deps locally like node_modules/.venv)
make style             # Format code using cargo fmt
make lint              # Check formatting, run Clippy, cargo-audit, and markdownlint
make test              # Run unit tests (inline #[cfg(test)] modules), scoped to --lib --bins
make test-integration  # Run integration tests under tests/
make test-examples     # Run every example in examples/*.rs via cargo run --example
make coverage          # Generate HTML + lcov coverage reports using cargo-llvm-cov
make complexity        # Generate a complexity report using rust-code-analysis-cli
make doc               # Generate API documentation using cargo doc
make package           # cargo build --release + cargo package
```

### Release Targets

```bash
make release-major     # Create major release using RTK
make release-minor     # Create minor release using RTK
make release-patch     # Create patch release using RTK
```

### Update Targets

```bash
make update-to-latest  # Update Makefile to latest Crust tag using curl + GitHub API + jq
make update-to-main    # Update Makefile to Crust main branch using curl
make update-to-version # Update Makefile to specific Crust version using curl
make update-dotfiles   # Refresh project dotfiles using generator-rust (git clone + plop + cp)
```

## Development Environment

This project can be developed inside the `cliffano/studio` Docker image, which already has the Rust toolchain installed under `/root/.cargo/bin`.

Run `cargo` commands directly, or inside the container:
`docker run --rm --workdir /opt/workspace -v $PWD:/opt/workspace -i -t cliffano/studio make ci`.

In CI, this project does not run inside `cliffano/studio` — it runs natively on the GitHub-hosted runner via `dtolnay/rust-toolchain`, matching how Suntory/PieMaker projects use `actions/setup-node`/`actions/setup-python` rather than a container (the container-based approach is reserved for tools like Backpacker/Tfmake that need binaries, such as Packer or Terraform, that a bare runner doesn't ship with).

## Code Style and Linting

Applies to: `**/*.rs`

- Formatting uses rustfmt via `make style`
- Static analysis uses Clippy via `make lint`

### Style & Formatting

All code must pass `cargo fmt --check`:

```bash
make style  # Applies formatting via cargo fmt
make lint   # Verifies formatting via cargo fmt --check, without rewriting
```

**Guidelines**:

- Don't manually format — `rustfmt` is authoritative
- Settings live in `rustfmt.toml`

### Clippy Static Analysis

All code must have zero Clippy warnings (`-D warnings`):

```bash
make lint
```

**Guidelines**:

- Disable lints only when justified: `#[allow(clippy::lint_name)]` with a comment explaining why
- Use specific lint names, not blanket allows
- `clippy.toml` sets `cognitive-complexity-threshold`; refactor functions that trip it rather than raising the threshold

### Rust Conventions

#### Module Structure

```rust
//! Module-level doc comment explaining the module's purpose.

use std::fs;

use serde::Deserialize;

use crate::message::Message;

pub struct Thing {
    // ...
}

impl Thing {
    pub fn new() -> Self {
        // ...
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn does_the_thing() {
        // ...
    }
}
```

- Group imports: `std`, then third-party crates, then `crate::` local modules
- Keep `lib.rs` minimal — it should only declare and re-export modules; real logic lives in the individual modules so both unit tests and consumers (via `tests/`) can exercise it through the public API
- Prefer `Result<T, E>` and the `?` operator over panicking; reserve `.unwrap()`/`.expect()` for tests and truly unreachable states

#### Naming Conventions

- **Types/Traits**: `PascalCase` (e.g., `Display`, `Message`)
- **Functions/Methods/Variables**: `snake_case` (e.g., `format_text`, `conf_file`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `DEFAULT_TIMEOUT`)
- **Modules/Files**: `snake_case.rs` (e.g., `display.rs`, `message.rs`)

#### Error Handling

```rust
pub fn new(conf_file: impl AsRef<Path>) -> std::io::Result<Self> {
    let content = fs::read_to_string(conf_file)?;
    // ...
}
```

- Propagate errors with `?` rather than matching and re-wrapping by hand
- Map external error types into `std::io::Error` (or a crate-local error enum, for larger projects) at the boundary where they're first encountered

#### Code Documentation

Add doc comments (`///` for items, `//!` for modules) to all public items:

```rust
/// Format text from configuration file with transformations.
///
/// # Arguments
/// * `reverse` - whether to reverse the text
/// * `transform` - transformation to apply ("lower" or "upper")
pub fn format(&self, reverse: bool, transform: &str) -> String {
    // ...
}
```

## Testing

Applies to: `src/**/*.rs` (inline `#[cfg(test)]` modules), `tests/**/*.rs`

Unlike the Node.js/Python templates, which keep unit tests in a separate top-level `test/` directory, Rust's idiomatic unit-test location is an inline `#[cfg(test)] mod tests` block within the same file as the code under test. This is not a stylistic choice — Cargo reserves the top-level `tests/` directory exclusively for integration tests, each file in it compiled as its own separate crate against this crate's public API.

### Test Structure

#### Unit Tests

**Location**: inline `#[cfg(test)] mod tests` block at the bottom of the `src/*.rs` file being tested

**Purpose**: Test individual functions/methods in isolation

**Scope**:

- No filesystem and network calls, other than reading small checked-in fixtures under `examples/`
- Fast execution, run via `make test` (`cargo test --lib --bins`)

#### Integration Tests

**Location**: `tests/integration_test.rs`

**Purpose**: Test the crate's public API the way an external consumer would, by depending on it through `use {{project_id}}::...`

**Scope**:

- Run via `make test-integration` (`cargo test --test '*'`)

#### Test Cases

```rust
#[test]
fn construct_display_and_format_with_upper_transformation_and_reverse() {
    let display = Display::new("examples/{{project_id}}.yaml").unwrap();
    let text = display.format(true, "upper");
    assert_eq!(text, "DLROW OLLEH");
}
```

**Pattern**: `<behaviour>_<condition>`, e.g. `format_reverses_and_uppercases`, `construct_display_and_format_with_lower_transformation_and_no_reverse`

### Coverage

```bash
make coverage
```

- Coverage engine: `cargo-llvm-cov`
- HTML report: `stage/gh-pages/coverage/index.html`
- lcov report (for Coveralls): `stage/gh-pages/coverage/lcov.info`
- Aim for >= 90% coverage on `src/`; focus on success and error paths, not trivial getters

### CI Integration

Tests are run as part of `make ci`:

```bash
make test              # Unit tests
make test-integration  # Integration tests
```

All tests must pass before merging.

## Documentation

- Documentation is generated with `cargo doc` via `make doc`
- Generated output lives under `stage/gh-pages/doc/`

## Continuous Integration Pipeline

The Makefile (Crust) orchestrates standard build targets, with `make ci` running the following steps in sequence:

- clean         # 1. Clean temp files and build cache
- deps          # 2. Install toolchain components and cargo subcommands
- style         # 3. Format code (rustfmt)
- lint          # 4. Check formatting, Clippy, cargo-audit, markdownlint
- test          # 5. Unit tests
- coverage      # 6. Coverage reports (cargo-llvm-cov)
- complexity    # 7. Complexity analysis (rust-code-analysis)
- doc           # 8. Generate documentation (cargo doc)
- package       # 9. cargo build --release + cargo package
- test-integration  # 10. Integration tests (against the public API)

All steps must pass before code is merged. Developers should run `make ci` locally before pushing to ensure the CI pipeline will pass.

After the code is merged, the CI pipeline will run as GitHub CI workflow.

## GitHub Workflows

This repository defines the following workflows under `.github/workflows/`:

- **CI** (`ci-workflow.yaml`): Trigger: `push`, `pull_request`, and manual `workflow_dispatch`. Purpose: Runs the full quality pipeline (`make ci`) on a native GitHub-hosted runner with the Rust toolchain via `dtolnay/rust-toolchain`, publishes coverage to Coveralls, and publishes generated reports to GitHub Pages.

- **CodeQL** (`codeql-analysis.yml`): Trigger: `push` to `main`, `pull_request` targeting `main`, and weekly scheduled run (`cron`). Purpose: Performs GitHub CodeQL static security analysis for Rust and uploads code scanning results.

- **Publish Crate** (`publish-crate-workflow.yaml`): Trigger: `push` of any Git tag. Purpose: Validates the build, then publishes to crates.io using Trusted Publishing (OIDC) — no stored `CARGO_REGISTRY_TOKEN` secret required.

- **Release Major** (`release-major-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a major release via `cliffano/release-action` (`release_type: major`).

- **Release Minor** (`release-minor-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a minor release via `cliffano/release-action` (`release_type: minor`).

- **Release Patch** (`release-patch-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a patch release via `cliffano/release-action` (`release_type: patch`).

- **Upgrade Deps** (`upgrade-deps-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Upgrades dependencies using `cargo update`, commits the updated `Cargo.lock`, and pushes changes back to the current branch.
