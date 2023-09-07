wget -cv https://www.africau.edu/images/default/sample.pdf
pdfinfo sample.pdf
pdftotext sample.pdf
gst-typefind-1.0 sample.*

pdftoppm -f 1 -l 1 sample.pdf sample

du -sh *
opj_compress -i sample-1.ppm -o sample-1.jp2
du -sh * 
file *
