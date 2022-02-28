INPUT_DIR="$PWD/src"
OUTPUT_DIR="$PWD/dist"

LATEX_RUN="pdflatex -interaction=nonstopmode -output-directory=$OUTPUT_DIR main.tex"
BIBTEX_RUN="bibtex main.aux"

[ ! -d "$OUTPUT_DIR" ] && mkdir -p "$OUTPUT_DIR"

# Compile for the first time and generate AUX files for BibTeX.
echo
echo "*** Compiling for the first time ***"
cd "$INPUT_DIR"
OUTPUT=$($LATEX_RUN | grep "LaTeX [(Warning)(Error)]")
if [ -z "$OUTPUT" ]; then
    echo "Finished without warnings or errors."
else
    echo "$OUTPUT"
fi

# Generate bibliography from the generated AUX file.
echo
echo "*** Generating bibliography ***"
cd "$OUTPUT_DIR"
cp "$INPUT_DIR/sources.bib" .
$BIBTEX_RUN

# Compile three times. First to include the generated BBL file, second to take the included bibliography into account (page numbers, ...)
# and a third time to get possibly changed labels and cross-references right.
echo
echo "*** Compiling for the second time ***"
cd "$INPUT_DIR"
$LATEX_RUN &> /dev/null
$LATEX_RUN &> /dev/null
OUTPUT=$($LATEX_RUN | grep "LaTeX [(Warning)(Error)]")
if [ -z "$OUTPUT" ]; then
    echo "Finished without warnings or errors."
else
    echo "$OUTPUT"
fi
echo