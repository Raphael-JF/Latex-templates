all:
	make rapport

rapport:
	cd rapport && pdflatex -interaction=nonstopmode rapport.tex && \
	bibtex rapport && \
	pdflatex -interaction=nonstopmode rapport.tex && \
	pdflatex -interaction=nonstopmode rapport.tex

clean_rapport:
	find ./rapport \
	-type d -name figures -prune -o \
	-type f ! -name "Makefile" ! -name "*.pdf" ! -name "*.tex" ! -name "references.bib" -exec rm -f {} +


.PHONY: all clean rapport clean_rapport