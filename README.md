# latexcompilescript

## License

Public Domain

## About

When compiling LaTeX documents, one sometimes needs to compile repeatedly. References, page numbers, the table of content etc might not get updated if the document only is compiled once. Another "issue" with compiling LaTeX documents (with pdflatex at least) is that auxilary files are created. Often, a *.aux and a *.log file is created, so instead of having just the input *.tex and output *.pdf, you end up with twice as many files.

This simple bash script takes care of both of these "issues". A document is compiled repeatedly, and after each compilation, the MD5 hashsum of the output *.pdf is calculated. When the hashsums don't differ between two compilations, the document has been consistently compiled. A maximum of 10 compilations will be performed. The script also "cleans up" the directory, by removing auxilary files.

Written by Johan Sjöblom in 2012-2013.
