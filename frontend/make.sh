#!/bin/bash
DEBUG=true

elm make src/Main.elm --output=./dist/scripts/bundle.js

if ! $DEBUG; then
	uglifyjs --compress --mangle --output ./dist/scripts/bundle.min.js -- ./dist/scripts/bundle.js
fi
