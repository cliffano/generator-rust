ci: clean stage deps test-rust-cli test-rust-cli-partials test-rust-lib test-rust-lib-partials

clean:
	rm -rf stage/

clean-rust-cli:
	rm -rf stage/rust-cli/

clean-rust-lib:
	rm -rf stage/rust-lib/

stage:
	mkdir -p stage/

deps:
	npm install .

########################################
# Utility targets
########################################

GENERATOR_CONFIG ?= crust.yml

define set_generator_vars
$(1): GENERATOR_COMPONENT = $$(shell yq .generator.component $(2))
$(1): GENERATOR_INPUTS_PROJECT_ID = $$(shell yq .generator.inputs.project_id $(2))
$(1): GENERATOR_INPUTS_PROJECT_NAME = $$(shell yq .generator.inputs.project_name $(2))
$(1): GENERATOR_INPUTS_PROJECT_DESC = $$(shell yq .generator.inputs.project_desc $(2))
$(1): GENERATOR_INPUTS_AUTHOR_NAME = $$(shell yq .generator.inputs.author_name $(2))
$(1): GENERATOR_INPUTS_AUTHOR_EMAIL = $$(shell yq .generator.inputs.author_email $(2))
$(1): GENERATOR_INPUTS_AUTHOR_URL = $$(shell yq .generator.inputs.author_url $(2))
$(1): GENERATOR_INPUTS_GITHUB_ID = $$(shell yq .generator.inputs.github_id $(2))
$(1): GENERATOR_INPUTS_GITHUB_REPO = $$(shell yq .generator.inputs.github_repo $(2))
$(1): GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX = $$(shell yq .generator.inputs.github_token_prefix $(2))
endef

########################################
# rust-cli targets
########################################

generate-rust-cli: clean-rust-cli
	node_modules/.bin/plop rust-cli

$(eval $(call set_generator_vars,generate-rust-cli-with-config,$(GENERATOR_CONFIG)))
generate-rust-cli-with-config: clean-rust-cli
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-rust-cli: clean-rust-cli
	make generate-rust-cli-with-config GENERATOR_CONFIG=examples/crust-rust-cli.yml
	cd stage/rust-cli/ && \
	  make ci

########################################
# rust-cli-partials targets
########################################

clean-rust-cli-partials:
	rm -rf stage/rust-cli-partials/

generate-rust-cli-partials: clean-rust-cli-partials
	node_modules/.bin/plop rust-cli-partials

$(eval $(call set_generator_vars,generate-rust-cli-partials-with-config,$(GENERATOR_CONFIG)))
generate-rust-cli-partials-with-config: clean-rust-cli-partials
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-rust-cli-partials: clean-rust-cli-partials
	make generate-rust-cli-partials-with-config GENERATOR_CONFIG=examples/crust-rust-cli-partials.yml

########################################
# rust-lib targets
########################################

generate-rust-lib: clean-rust-lib
	node_modules/.bin/plop rust-lib

$(eval $(call set_generator_vars,generate-rust-lib-with-config,$(GENERATOR_CONFIG)))
generate-rust-lib-with-config: clean-rust-lib
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-rust-lib: clean-rust-lib
	make generate-rust-lib-with-config GENERATOR_CONFIG=examples/crust-rust-lib.yml
	cd stage/rust-lib/ && \
	  make ci

########################################
# rust-lib-partials targets
########################################

clean-rust-lib-partials:
	rm -rf stage/rust-lib-partials/

generate-rust-lib-partials: clean-rust-lib-partials
	node_modules/.bin/plop rust-lib-partials

$(eval $(call set_generator_vars,generate-rust-lib-partials-with-config,$(GENERATOR_CONFIG)))
generate-rust-lib-partials-with-config: clean-rust-lib-partials
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-rust-lib-partials: clean-rust-lib-partials
	make generate-rust-lib-partials-with-config GENERATOR_CONFIG=examples/crust-rust-lib-partials.yml

update-crust-to-latest:
	cd templates/rust-cli && make update-to-latest
	cd templates/rust-lib && make update-to-latest

.PHONY: ci clean clean-rust-cli stage deps generate-rust-cli generate-rust-cli-with-config test-rust-cli clean-rust-cli-partials generate-rust-cli-partials generate-rust-cli-partials-with-config test-rust-cli-partials clean-rust-lib generate-rust-lib generate-rust-lib-with-config test-rust-lib clean-rust-lib-partials generate-rust-lib-partials generate-rust-lib-partials-with-config test-rust-lib-partials update-crust-to-latest
