#!/bin/bash
DEBUG=true

ELM_BUILD_COMMAND="elm make src/Main.elm --output=./dist/scripts/bundle.js"
SCSS_BUILD_COMMAND="dart-sass ./src/Styles/styles.scss ./dist/css/styles.css"
MINIFIED_SCSS_BUILD_COMMAND="dart-sass --style=compressed --no-source-map ./src/Styles/styles.scss ./dist/css/styles.min.css"
UGLIFY_JS_COMMAND="uglifyjs --compress --mangle --output ./dist/scripts/bundle.min.js -- ./dist/scripts/bundle.js"

if $DEBUG; then
	inotifywait -r -m -e modify src |
		while read path _ file; do
			if [[ $file == *"swp"* ]]; then
				continue
			fi

			if [[ $file == *"elm"* ]]; then
				${ELM_BUILD_COMMAND}
			fi

			if [[ $file == *"scss"* ]]; then
				${SCSS_BUILD_COMMAND}
			fi
		done
fi

if ! $DEBUG; then
	${ELM_BUILD_COMMAND} --optimize
	${MINIFIED_SCSS_BUILD_COMMAND}
	${UGLIFY_JS_COMMAND}
fi
