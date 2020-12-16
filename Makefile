# vim: tabstop=8
# vim: shiftwidth=8
# vim: noexpandtab

.PHONY:	 help install update_changelog update_function udpate_shdoc 

red             		:= \033[0;31m
yellow          		:= \033[0;33m
blue            		:= \033[0;34m
green           		:= \033[0;35m
clear           		:= \033[0m

RUBY_VERSION    		:= $(cat .ruby-version)
BASHMATIC_HOME			:= $(cd && pwd -P)
OS	 		 	:= $(shell uname -s | tr '[:upper:]' '[:lower:]')

help:	   			## Prints help message auto-generated from the comments.
				@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install:			## install BashMatic Locally in ~/.bashmatic
				@printf " 👉  $(green)Running bin/bashmatic-installer script..$(clear)\n"
				@./bin/bashmatic-install

update_changelog: 		## Auto-generate the doc/CHANGELOG (requires GITHUB_TOKEN env var set)
				@printf " 👉  $(green)Regenerating doc/CHANGELOG....$(clear)\n"
				@bash -c "source ./bin/regen-index-docs; generate-changelog"

update_functions: 		## Auto-generate doc/FUNCTIONS index at doc/FUNCTIONS.adoc/pdf
				@printf " 👉  $(green)Regenerating doc/FUNCTIONS.adoc — functions INDEX...$(clear)\n"
				@bash -c "source ./bin/regen-index-docs; generate-functions-index"

update_usage: 			## Auto-generate doc/USAGE documentation from lib shell files, to doc/USAGE.adoc/pdf
				@printf " 👉  $(green)Extracting shdoc documentation from library shell files ....$(clear)\n"
				@bash -c "source ./bin/regen-index-docs; generate-shdoc"

				@printf " 👉  $(green)Converting USAGE.md into the ASCIIDOC...$(clear)\n"
				@[[ -s doc/USAGE.md ]] && kramdoc doc/USAGE.md

				@printf " 👉  $(green)Converting USAGE.adoc into the PDF...$(clear)\n"
				@[[ -s doc/USAGE.adoc ]] && ./bin/adoc2pdf doc/USAGE.adoc

				@printf " 👉  $(green)Reducing the PDF Size.... $(clear)\n"
				@./bin/pdf-reduce doc/USAGE.pdf USAGE.pdf.reduced
			    	@[[ -s USAGE.pdf.reduced ]] && mv -v USAGE.pdf.reduced doc/USAGE.pdf

update_readme:			## Re-generate the PDF version of the README
				@printf " 👉  $(green)Converting README.adoc into the PDF...$(clear)\n"
				@[[ -s README.adoc ]] && ./bin/adoc2pdf README.adoc

				@printf " 👉  $(green)Reducing the PDF Size.... $(clear)\n"
				@./bin/pdf-reduce README.pdf README.pdf.reduced
				@[[ -s README.pdf.reduced ]] && mv -v README.pdf.reduced README.pdf

update: update_changelog update_functions update_usage update_readme ## Runs all of the updates, add locally modiofied files to git.

				@printf " 👉  $(yellow)Git status after the update:$(clear)\n"
				@git add .
				@printf " 👉  $(blue)Git status after the update:$(clear)\n"
				@git status


setup: 				## Run the comprehensive development setup on this machine
				@printf " 👉  $(green)Running developer setup script, this may take a while.$(clear)\n"
				@./bin/dev-setup -r $(RUBY_VERSION) \
					-g dev \
					-g cpp \
					-g fonts  \
					-g gnu  \
					-g go  \
					-g java  \
					-g js  \
					-g load-balancing   \
					-g postgres    \
					-g ruby
			
test: 				## Run the fully auto-g mated test suite
				@./bin/specs



