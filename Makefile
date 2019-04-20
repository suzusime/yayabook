filename=sample

.PHONY: all clean

all: $(filename).pdf

$(filename).pdf: intermediate/$(filename).pdf
	cp intermediate/$(filename).pdf .

intermediate/$(filename).pdf: intermediate/$(filename).tex
	latexmk -lualatex -output-directory=intermediate intermediate/$(filename).tex

intermediate/$(filename).tex:
	 pandoc -f markdown -t latex --standalone -o intermediate/$(filename).tex --latex-engine=lualatex -V papersize=a5 -V documentclass=bxjsbook -V classoption=pandoc -V classoption=jafont=ipaex $(filename).md
 
clean:
	cd intermediate; git clean -dfX
