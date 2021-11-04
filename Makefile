ASSETS_DIR := static
ENVIRONMENT ?= "production"
FA_VERSION := 5.15.4
FA_URL := "https://use.fontawesome.com/releases/v$(FA_VERSION)/fontawesome-free-$(FA_VERSION)-web.zip"
MATHJAX_URL := "https://github.com/mathjax/MathJax.git"

# Include extra environment variables, mostly for development purposes
include .env
export

publish: publish.el
	@echo "ENVIRONMENT=$(ENVIRONMENT)"
	@([[ -d ./public ]] && rm -rf ./public) || echo "Skipping directory creation..."
	@([[ -d $$HOME/.org-timestamps ]] && rm -rf $$HOME/.org-timestamps) || echo "Skipping.."
	@echo "Publishing... with current Emacs configurations."
	ENVIRONMENT=$(ENVIRONMENT) emacs --batch --load publish.el --funcall org-publish-all
