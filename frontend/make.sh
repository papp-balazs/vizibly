#!/bin/bash
DEBUG=true

BUILD_COMMAND="elm make src/Main.elm --output=./dist/scripts/bundle.js"

${BUILD_COMMAND}

if $DEBUG; then
	inotifywait -r -m -e modify src |
		while read path _ file; do
			if [[ $file != *"swp"* ]]; then
				${BUILD_COMMAND}
			fi
		done
fi

if ! $DEBUG; then
	uglifyjs --compress --mangle --output ./dist/scripts/bundle.min.js -- ./dist/scripts/bundle.js
fi
