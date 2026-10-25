.DEFAULT_GOAL := help
SHELL := /bin/bash
ROOT := $(shell dirname "$(realpath $(lastword $(MAKEFILE_LIST)))")

.PHONY: help install uninstall packages test
help:
	@printf '%s\n' 'make install    Link configs' 'make uninstall  Remove links' 'make packages   Install Homebrew/Arch packages and shell dependencies'

install uninstall:
	@/bin/bash "$(ROOT)/scripts/dotfiles" "$@"

packages:
	@/bin/bash "$(ROOT)/scripts/packages"
