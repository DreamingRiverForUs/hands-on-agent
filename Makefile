.PHONY: build render check clean

build:
	bash scripts/build.sh

render: build
	bash scripts/render.sh

check: build
	bash scripts/check.sh

clean:
	rm -rf build tmp/pdfs

