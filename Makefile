# Makefile for jlj blog
.PHONY: all publish publish_no_init

all: publish

publish: publish.el
	@echo "Publishing...."
	emacs --no-init --script publish.el --funcall=jlj/publish

clean:
	@echo "Cleaning up.."
	@rm -rvf *.elc
	@rm -rvf posts/*.html
	@rm -fv index.html
	@rm -fv index.xml
	@rm -fv posts/articles.xml
	@rm -fv posts/rss.xml
	@rm -fv posts/atom.xml
	@rm -fv personal/*.html
	@rm -fv personal/rss.xml
	@rm -fv personal/atom.xml
	@rm -fv source/*.html
	@rm -rvf ~/.org-timestamps/*
