#!/bin/bash
DEBUG=true

elm make src/Main.elm --output=./dist/bundle.js

if ! $DEBUG; then
	uglifyjs --compress --mangle --output ./dist/bundle.min.js -- ./dist/bundle.js
fi
