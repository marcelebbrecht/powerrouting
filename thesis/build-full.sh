#!/bin/bash

pdflatex main
bibtex main
bibtex main
makeglossaries main
makeglossaries main
pdflatex main
pdflatex main
evince main.pdf
