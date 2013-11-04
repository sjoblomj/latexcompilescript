#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "Latex compiler 1.0, by Johan Sjöblom. The code is public domain."
    echo "Usage:"
    echo "$0 <filename>      Compiles the given file"
    echo "$0 <filename> -l   Compiles loudly, eg prints pdflatex output"
    exit 0
fi


# pdflatex will produce some "helper files". Remove them, if
# they are created:
EXTARRAY=('aux' 'log' 'toc' 'nav' 'out' 'snm' 'dvi')

CMD="dirname $1"
DIRECTORY=`eval $CMD`
if [ "$DIRECTORY" == "" ]; then
    while true; do
        echo "Could not find directory to work in. Please enter the directory:"
        read dir
        if [ -d $dir ]; then
            DIRECTORY="$dir"
            break
        fi
    done
fi
CMD="cd $DIRECTORY"
eval $CMD

CMD="basename $1"
FILENAME=`eval $CMD`
# Check to make sure that the filename exists:
if [ ! -e $FILENAME ]; then
    while true; do
        echo "Could not find input *.tex-file in directory '$DIRECTORY'. Please enter the filename:"
        read file
        if [ -e $file ]; then
            FILENAME="$file"
            break
        fi
    done
fi
BASEFILENAME="${FILENAME%.*}"


COUNT=0
MD5=0
SUCCESS=0
echo -n "Compiling $FILENAME "
while [ $COUNT -lt 10 ] && [ $SUCCESS -eq 0 ]; do
    #date
    echo -n "."

    CMD="pdflatex $FILENAME"

    # If argument to script is -l, then we run the script loudly,
    # eg, print out the output from pdflatex. Otherwise, we supress
    # the output
    if [ "$2" == "-l" ]; then
        eval $CMD
    else
        TMP=`eval $CMD`
    fi

    # Strip metadata in pdf and get md5sum on that 
    TMP=`pdftk $BASEFILENAME.pdf  dump_data | \
        sed -e 's/\(InfoValue:\)\s.*/\1\ /g' | \
        pdftk $BASEFILENAME.pdf update_info - output - | md5sum`

    let COUNT=COUNT+1
    if [ "$MD5" == "$TMP" ]; then
        SUCCESS=1
        echo " done after $COUNT iterations."
    else
        MD5="$TMP"
    fi
done
if [ $SUCCESS -eq 0 ]; then
    echo " - Error! Could not consistently compile $FILENAME"
fi


# Remove the "helper files", if they exist:
for (( j=0;j<${#EXTARRAY[@]};j++)); do
    RMFILE="$BASEFILENAME.${EXTARRAY[${j}]}"
    rm -f $RMFILE 2>&1 >/dev/null
done
RMFILE="texput.log"
rm -f $RMFILE 2>&1 >/dev/null
RMFILE="missfont.log"
rm -f $RMFILE 2>&1 >/dev/null
