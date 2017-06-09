# Simple Makefile for raven-lua that runs tests and generates docs
#
# Copyright (c) 2014-2017 CloudFlare, Inc.

RESTY := $(shell which resty)

.PHONY: lint
lint:
	luacheck .

.PHONY: test
test: lint
	tsc tests/*.lua
ifeq ($(RESTY),)
	echo "resty-cli not found, skip ngx tests"
else
	sed -e "s|%PWD%|$$PWD|" tests/sentry.conf > tests/sentry.conf.out
	$(RESTY) --http-include $$PWD/tests/sentry.conf.out -e 'require("telescope.runner")(arg)' /dev/null tests/resty/*.lua
endif

.PHONY: doc
doc:
	ldoc .

