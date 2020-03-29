# Makefile for jlj blog
.PHONY: all publish publish_no_init

all: publish

publish: publish.el
	@echo "Publishing... with current Emacs configurations."
	emacs --quick --script publish.el --funcall=jlj/publish

clean:
	@echo "Cleaning up.."
	@rm -rvf *.elc
	@rm -rvf public
	@rm -rvf ~/.org-timestamps/*
