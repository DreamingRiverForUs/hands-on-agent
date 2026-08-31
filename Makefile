.PHONY: fonts build render check clean

fonts:
	bash scripts/download-fonts.sh

build: fonts
	bash scripts/build.sh

render: build
	bash scripts/render.sh

check: build
	bash scripts/check.sh

clean:
	rm -rf build tmp/pdfs
