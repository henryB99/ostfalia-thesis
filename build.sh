INPUT_DIR=$PWD/src
OUTPUT_DIR=$PWD/dist
[ ! -d $OUTPUT_DIR ] && mkdir -p $OUTPUT_DIR
# Compile for the first time and generate AUX files for BibTeX.
echo
echo "*** Compiling for the first time ***"
echo
cd $INPUT_DIR
pdflatex -output-directory=$OUTPUT_DIR main.tex | grep "LaTeX [(Warning)(Error)]"
# Generate bibliography from the generated AUX file.
echo
echo "*** Generating bibliography. ***"
echo
cd $OUTPUT_DIR
cp $INPUT_DIR/sources.bib .
bibtex main.aux
# Compile twice. First to include the generated BBL file, second to take the included bibliography into account (page numbers, ...).
echo
echo "*** Compiling for the second time. ***"
echo
cd $INPUT_DIR
pdflatex -output-directory=$OUTPUT_DIR main.tex | grep "LaTeX [(Warning)(Error)]"
pdflatex -output-directory=$OUTPUT_DIR main.tex | grep "LaTeX [(Warning)(Error)]"