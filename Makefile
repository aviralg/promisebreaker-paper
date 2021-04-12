MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECTDIR := $(dir $(MAKEFILE_PATH))

DATADIR := $(PROJECTDIR)data
GRAPHDIR := $(PROJECTDIR)graphs
MACRODIR := $(PROJECTDIR)macros

# Tools
LATEXMK = latexmk
RM = rm -f
R = R

# Targets
all:
	pdflatex main && bibtex main

open: main.pdf
	open main.pdf

main.pdf: all

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

report:
	$(R) --slave -e "rmarkdown::render('report.Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"

unevaluated:
	$(R) --slave -e "rmarkdown::render('unevaluated.Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"

side-effects:
	$(R) --slave -e "rmarkdown::render('side-effects.Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"

reflection:
	$(R) --slave -e "rmarkdown::render('reflection.Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"


watch: pdf
	evince main.pdf&
	while true; do inotifywait main.tex $(GRAPHDIR); make; done

.PHONY: all open clean pdf watch

# Include auto-generated dependencies
-include *.d
