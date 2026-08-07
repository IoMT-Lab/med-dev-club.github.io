# Local preview of the Jekyll site.
#
# One-time system requirement (everything else installs into ./vendor):
#   sudo apt-get install ruby-dev
#
# Usage:
#   make              # install deps (repo-local) and serve at http://127.0.0.1:4000/
#   make HOST=0.0.0.0 # serve on all interfaces (e.g. when working on a remote box)
#   make build        # just build the site into _site/
#   make clean        # remove build output
#   make distclean    # also remove installed gems (vendor/)

GEM_HOME := $(CURDIR)/vendor/gems
export GEM_HOME
export PATH := $(GEM_HOME)/bin:$(PATH)
BUNDLE := $(GEM_HOME)/bin/bundle

HOST ?= 127.0.0.1
PORT ?= 4000

.PHONY: serve build install clean distclean

serve: install
	$(BUNDLE) exec jekyll serve --host $(HOST) --port $(PORT) --livereload

ngrok:
	ngrok http --url=regionalistic-kathi-uninformatively.ngrok-free.dev $(PORT)

build: install
	$(BUNDLE) exec jekyll build

install: $(BUNDLE)
	@$(BUNDLE) check >/dev/null 2>&1 || $(BUNDLE) install

$(BUNDLE):
	@ruby -rmkmf -e '' >/dev/null 2>&1 || { \
		echo 'Ruby development headers are missing (needed to build native gems).'; \
		echo 'Install them once with:  sudo apt-get install ruby-dev'; \
		exit 1; }
	gem install bundler --no-document

clean:
	rm -rf _site .jekyll-cache .sass-cache

distclean: clean
	rm -rf vendor .bundle Gemfile.lock
