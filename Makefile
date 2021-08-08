MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECTDIR := $(dir $(MAKEFILE_PATH))

ANALYSIS := corpus
DATADIR := $(PROJECTDIR)data
GRAPHDIR := $(PROJECTDIR)graphs
MACRODIR := $(PROJECTDIR)macros
MACROFILE := $(PROJECTDIR)macros.tex

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

analysis:
	$(R) --slave -e "rmarkdown::render('$(ANALYSIS).Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"

merge-macros:
	R --slave -e "invisible(experimentr::merge_macros('$(MACRODIR)', '$(MACROFILE)'))"

corpus:
	make analysis ANALYSIS=corpus

unevaluated:
	make analysis ANALYSIS=unevaluated

missing:
	make analysis ANALYSIS=missing

side-effects:
	make analysis ANALYSIS=side-effects

reflection:
	make analysis ANALYSIS=reflection

validation:
	make analysis ANALYSIS=validation

statistics:
	make analysis ANALYSIS=statistics

metaprogramming:
	make analysis ANALYSIS=metaprogramming

performance:
	make analysis ANALYSIS=performance
	sed -i 's/Ř/\\v\{R\}/g' graphs/rshPromNorm.tex

watch: pdf
	evince main.pdf&
	while true; do inotifywait main.tex $(GRAPHDIR); make; done

.PHONY: all open clean pdf watch analysis corpus unevaluated side-effects reflection

# Include auto-generated dependencies
-include *.d
