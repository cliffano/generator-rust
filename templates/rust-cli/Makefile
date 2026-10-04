################################################################
# Crust: Makefile for building Rust packages
# https://github.com/cliffano/crust
################################################################

# Crust info
CRUST_VERSION = 0.1.0-pre.0

UPDATE_GH_ID = cliffano
UPDATE_MAKEFILE = crust
UPDATE_GENERATOR = rust
UPDATE_DOTFILES = .github/. rustfmt.toml clippy.toml .rtk.json .yamllint .gitignore AGENTS.md
UPDATE_PARTIALS = AVATAR BADGES BUILD_REPORTS DEVELOPERS_GUIDE

################################################################
# User configuration variables
# https://github.com/cliffano/crust#configuration
# These variables should be stored in crust.yml config file,
# and they will be parsed using yq https://github.com/mikefarah/yq

# PACKAGE_NAME is the name of the Rust package
PACKAGE_NAME=$(shell yq .package_name crust.yml)

# AUTHOR is the author of the Rust package
AUTHOR ?= $(shell yq .author crust.yml)

$(info ################################################################)
$(info Building Rust package using Crust with user configurations...)
$(info - Package name = ${PACKAGE_NAME})
$(info - Author = ${AUTHOR})

################################################################
# Base targets

# CI target to be executed by CI/CD tool
all: ci
ci: clean deps style lint test coverage complexity doc package test-integration

# Ensure stage directory exists
stage:
	mkdir -p stage/gh-pages/

# Remove all temporary (staged, generated, cached) files
clean:
	cargo clean
	rm -rf stage/

################################################################
# Dependencies targets

# Retrieve the Rust toolchain components and supporting CLI tools
deps:
	rustup component add clippy rustfmt
	cargo install cargo-llvm-cov cargo-audit rust-code-analysis-cli --locked
	$(call deps_extra)

deps-extra-apt:
	apt-get update
	apt-get install -y markdownlint
	$(call run_hook,x-post-deps-extra-apt)

# Upgrade dependencies by recomputing Cargo.lock against latest compatible versions
deps-upgrade:
	cargo update

# Unlike node_modules/.venv, Cargo does not vendor dependencies locally,
# so there's nothing project-local to remove beyond the build cache
rmdeps:
	cargo clean

################################################################
# Formatting targets

style:
	cargo fmt
	$(call run_hook,x-post-style)

################################################################
# Testing targets

lint: stage
	cargo fmt --check
	cargo clippy --all-targets --all-features -- -D warnings
	cargo audit
	mdl -r ~MD013,~MD029 $(shell find . -path ./stage -prune -o -path ./target -prune -o -name "CHANGELOG.md" -prune -o -name "*.md" -print)
	$(call run_hook,x-post-lint)

complexity: stage
	rm -rf stage/gh-pages/complexity/ && mkdir -p stage/gh-pages/complexity/
	rust-code-analysis-cli --metrics -O json -o stage/gh-pages/complexity/ -p src/

# Unit tests live inline as #[cfg(test)] modules within src/*.rs,
# scoped here to --lib --bins so they stay distinct from tests/ integration tests
test:
	cargo test --lib --bins

# Integration tests live under tests/, run via Cargo's own convention
test-integration:
	cargo test --test '*'

test-examples:
	mkdir -p stage/test-examples/
	for f in examples/*.rs; do \
	  cargo run --example "$$(basename "$$f" .rs)"; \
	done

coverage: stage
	rm -rf stage/gh-pages/coverage/ && mkdir -p stage/gh-pages/coverage/
	cargo llvm-cov --lib --bins --html --output-dir stage/gh-pages/coverage/
	cargo llvm-cov --lib --bins --lcov --output-path stage/gh-pages/coverage/lcov.info

################################################################
# Packaging and publishing targets

package:
	cargo build --release --locked
	cargo package --locked

publish:
	cargo publish --locked

################################################################
# Documentation targets

doc: stage
	rm -rf stage/gh-pages/doc/ && mkdir -p stage/gh-pages/doc/
	cargo doc --no-deps --target-dir stage/gh-pages/doc/

################################################################
# MAKE IT SO - Utility Makefile functions and targets
################################################################

define run_hook
	@if [ -f Makefile-extras ] && grep -q "^$(1):" Makefile-extras; then \
		$(MAKE) -f Makefile-extras $(1); \
	fi
endef

define deps_extra
	@if command -v apt-get > /dev/null 2>&1; then \
		if [ "$$(id -u)" = "0" ]; then \
			$(MAKE) deps-extra-apt; \
		else \
			sudo $(MAKE) deps-extra-apt; \
		fi; \
	fi
endef

define update_dotfiles_from_generator
	cd stage/ && \
	  rm -rf generator-$(1)/ && \
	  git clone https://github.com/$(UPDATE_GH_ID)/generator-$(1) && \
	  cd generator-$(1) && \
	  make deps && \
	  node_modules/.bin/plop $(UPDATE_GENERATOR_COMPONENT) -- \
	    --project_id "$(UPDATE_GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(UPDATE_GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(UPDATE_GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(UPDATE_GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(UPDATE_GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(UPDATE_GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(UPDATE_GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"
	cd stage/generator-$(1)/stage/$(UPDATE_GENERATOR_COMPONENT) && \
	  for dotfile in $(2); do \
		cp -R "$$dotfile" ../../../../"$$dotfile"; \
	  done
endef

define update_partials_from_generator
	cd stage/ && \
	  rm -rf generator-$(1)/ && \
	  git clone https://github.com/$(UPDATE_GH_ID)/generator-$(1) && \
	  cd generator-$(1) && \
	  make deps && \
	  node_modules/.bin/plop $(UPDATE_GENERATOR_COMPONENT)-partials -- \
	    --project_id "$(UPDATE_GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(UPDATE_GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(UPDATE_GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(UPDATE_GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(UPDATE_GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(UPDATE_GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(UPDATE_GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"
	for block in $(2); do \
	  partial_file=$$(printf "%s" "$$block" | tr "A-Z" "a-z"); \
	  ex -s \
	    -c "/<!-- BEGIN:$$block -->/+1,/<!-- END:$$block -->/-1d" \
	    -c "/<!-- BEGIN:$$block -->/r stage/generator-$(1)/stage/$(UPDATE_GENERATOR_COMPONENT)-partials/$$partial_file.txt" \
	    -c 'wq' \
	    README.md; \
	done
endef

define set_generator_vars
$(1): UPDATE_GENERATOR_COMPONENT = $$(shell yq .generator.component $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_ID = $$(shell yq .generator.inputs.project_id $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_NAME = $$(shell yq .generator.inputs.project_name $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_DESC = $$(shell yq .generator.inputs.project_desc $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_NAME = $$(shell yq .generator.inputs.author_name $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL = $$(shell yq .generator.inputs.author_email $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_URL = $$(shell yq .generator.inputs.author_url $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_ID = $$(shell yq .generator.inputs.github_id $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_REPO = $$(shell yq .generator.inputs.github_repo $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX = $$(shell yq .generator.inputs.github_token_prefix $(2).yml)
endef

# Update Makefile to the latest version tag
update-to-latest: UPDATE_TARGET_VERSION = $(shell curl -s https://api.github.com/repos/$(UPDATE_GH_ID)/$(UPDATE_MAKEFILE)/tags | jq -r '.[0].name')
update-to-latest: update-to-version

# Update Makefile to the main branch
update-to-main:
	curl https://raw.githubusercontent.com/$(UPDATE_GH_ID)/$(UPDATE_MAKEFILE)/main/src/Makefile-$(UPDATE_MAKEFILE) -o Makefile

# Update Makefile to the version defined in UPDATE_TARGET_VERSION parameter
update-to-version:
	curl https://raw.githubusercontent.com/$(UPDATE_GH_ID)/$(UPDATE_MAKEFILE)/$(UPDATE_TARGET_VERSION)/src/Makefile-$(UPDATE_MAKEFILE) -o Makefile

# Update dotfiles using the generator
$(eval $(call set_generator_vars,update-dotfiles,$(UPDATE_MAKEFILE)))
update-dotfiles: stage
	$(call update_dotfiles_from_generator,$(UPDATE_GENERATOR),$(UPDATE_DOTFILES))
	$(call run_hook,x-post-update-dotfiles)

# Update partial snippets using the generator
$(eval $(call set_generator_vars,update-partials,$(UPDATE_MAKEFILE)))
update-partials: stage
	$(call update_partials_from_generator,$(UPDATE_GENERATOR),$(UPDATE_PARTIALS))

release-major:
	rtk release --release-increment-type major

release-minor:
	rtk release --release-increment-type minor

release-patch:
	rtk release --release-increment-type patch

################################################################

.PHONY: all ci stage clean deps deps-extra-apt deps-upgrade rmdeps style lint complexity test test-integration test-examples coverage package publish doc update-to-latest update-to-main update-to-version update-dotfiles update-partials release-major release-minor release-patch
