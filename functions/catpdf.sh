#!/bin/bash

# Make a new function that converts pdfs to text when you cat them
function catpdf() {
    # Check if the first argument is a PDF file
    if ! [[ "$1" == *.pdf ]]; then
        echo "Error: you must pass in a PDF file."
    fi

    pdftotext "$1"
    cat "${1/.pdf/.txt}"
    rm "${1/.pdf/.txt}"
}