.DEFAULT_GOAL := run

.PHONY: run install build pdf ppt clean

run: install
	bun run dev

install:
	bun install

build: install
	bun run build

pdf: install
	bun run export:pdf

ppt: install
	bun run export:pptx

clean:
	rm -rf dist slides.pdf slides.pptx
