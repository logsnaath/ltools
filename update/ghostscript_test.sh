#!/bin/bash

# Let the script know its current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PDFs=$(find /usr/share/ghostscript/`gs --version`/examples -name "*.pdf")

for eachpdf in $PDFs; do

  # Convert the files
  if pdf2ps $eachpdf $DIR/${eachpdf##*/}.ps; then
    echo " + PASS: $eachpdf has been converted succefully into ps"
  else
    echo " - FAIL: Could not convert $eachpdf into ps"
    echo "         Try manually: pdf2ps $eachpdf $DIR/${eachpdf##*/}.ps"
    RC=1
  fi
done

# Clean up (remove *.ps) files
find $DIR -name "*.ps" -type f -delete

# If any test failed, return 1
exit $RC

# requires X11
#gs /usr/share/ghostscript/`gs --version`/examples/golfer.eps 
