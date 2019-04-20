filename=README

.PHONY: all clean

all: $(filename).pdf

$(filename).pdf: intermediate/$(filename).pdf
	cp intermediate/$(filename).pdf .

intermediate/$(filename).pdf: intermediate/$(filename).tex yayabook.cls
	latexmk -lualatex -output-directory=intermediate intermediate/$(filename).tex

intermediate/$(filename).tex: $(filename).md
	 pandoc -f markdown+ignore_line_breaks -t latex --standalone -o intermediate/$(filename).tex -N --chapter --latex-engine=lualatex $(filename).md

intermediate/$(filename).html: $(filename).md
	 pandoc -f markdown+ignore_line_breaks -t html5 --standalone -o intermediate/$(filename).html -N $(filename).md
 
clean:
	cd intermediate; git clean -dfX
	rm $(filename).pdf
