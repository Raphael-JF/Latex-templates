all:
	pdflatex rapport.tex

clean:
	find . \
	-type d -name figures -prune -o \
	-type f ! -name "Makefile" ! -name "*.pdf" ! -name "*.tex" -exec rm -f {} +


.PHONY: all clean