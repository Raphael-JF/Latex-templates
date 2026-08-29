all:
	make rapport

rapport:
	cd rapport && pdflatex rapport.tex
part1:
	python3 -m src.part1.main

part2:
	python3 -m src.part2.main

part3:
	python3 -m src.part3.main

part4:
	python3 -m src.part4.main

clean:
	find ./rapport \
	-type d -name figures -prune -o \
	-type f ! -name "Makefile" ! -name "*.pdf" ! -name "*.tex" -exec rm -f {} +


.PHONY: all clean rapport part1 part2 part3 part4