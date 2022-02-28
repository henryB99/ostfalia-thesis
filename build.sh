ROOT_DIR="$PWD"
SOURCE_DIR="$ROOT_DIR/src"
BUILD_DIR="$ROOT_DIR/build"

LATEX_RUN="pdflatex -interaction=nonstopmode -synctex=1 -output-directory=$BUILD_DIR main.tex"
BIBTEX_RUN="bibtex main.aux"

if [ -d "$BUILD_DIR" ] && [ ! -z "$( cd "$BUILD_DIR" && find -type f )" ]; then
    
    # If there are cached files from previous compilations, reuse those.
    echo
    echo "*** Recompiling ***"
    cd "$SOURCE_DIR"
    LOG=$($LATEX_RUN | grep "LaTeX [(Warning)(Error)]")
    if [ -z "$LOG" ]; then
        echo "Finished without warnings or errors."
    else
        echo "$LOG"
    fi

else

    mkdir -p "$BUILD_DIR"
    # Compile for the first time and generate AUX files for BibTeX.
    echo
    echo "*** Compiling for the first time ***"
    cd "$SOURCE_DIR"
    LOG=$($LATEX_RUN | grep "LaTeX [(Warning)(Error)]")
    if [ -z "$LOG" ]; then
        echo "Finished without warnings or errors."
    else
        echo "$LOG"
    fi

    # Generate bibliography from the generated AUX file.
    echo
    echo "*** Generating bibliography ***"
    cd "$BUILD_DIR"
    cp "$SOURCE_DIR/sources.bib" .
    $BIBTEX_RUN

    # Compile three times. First to include the generated BBL file, second to take the included bibliography into account
    # (page numbers, ...) and a third time to get possibly changed labels and cross-references right.
    echo
    echo "*** Compiling for the second time ***"
    cd "$SOURCE_DIR"
    $LATEX_RUN &> /dev/null
    $LATEX_RUN &> /dev/null
    LOG=$($LATEX_RUN | grep "LaTeX [(Warning)(Error)]")
    if [ -z "$LOG" ]; then
        echo "Finished without warnings or errors."
    else
        echo "$LOG"
    fi

fi

# If the compilation was successful and created a PDF file, just copy it over to the project root.
# if [ -f "$BUILD_DIR/main.pdf" ]; then
#     mv "$BUILD_DIR/main.pdf" "$BUILD_DIR/../main.pdf"
# fi

echo
exit