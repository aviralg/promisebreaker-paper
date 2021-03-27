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

.PHONY: all open clean pdf

# Include auto-generated dependencies
-include *.d
