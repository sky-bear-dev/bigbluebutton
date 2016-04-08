.PHONY: all
all: js css

.PHONY: clean
clean: clean-js clean-css

# npm handling

.PHONY: npm-install
npm-install: node_modules

node_modules:
	npm install

export PATH := $(shell npm bin):$(PATH)

# JS

PUB_JS_FILES = pub/js/playback.min.js pub/js/playback.min.js.gz
BUILT_JS_FILES = src/js/playback.js
DIST_JS_FILES = src/js/vtt.js

.PHONY: js
js: $(PUB_JS_FILES)

.PHONY: clean-js
clean-js:
	rm -f $(PUB_JS_FILES) $(BUILT_JS_FILES)

pub/js:
	mkdir -p pub/js

pub/js/playback.min.js: $(BUILT_JS_FILES) $(DIST_JS_FILES) | pub/js npm-install
	uglifyjs $^ -c -m -o $@

%.js: %.es6 | npm-install
	babel --presets es2015 $< -o $@

# CSS

PUB_CSS_FILES = pub/css/playback.min.css pub/css/playback.min.css.gz
BUILT_CSS_FILES = src/css/playback.css
DIST_CSS_FILES = 

.PHONY: css
css: $(PUB_CSS_FILES)

.PHONY: clean-css
clean-css:
	rm -f $(PUB_CSS_FILES) $(BUILT_CSS_FILES)

pub/css:
	mkdir -p pub/css

pub/css/playback.min.css: $(BUILT_CSS_FILES) $(DIST_CSS_FILES) | pub/css npm-install
	cat $^ | cleancss --output $@

%.css: %.scss
	sass $< $@

# Generic

%.gz: %
	gzip -9 < $< > $@
