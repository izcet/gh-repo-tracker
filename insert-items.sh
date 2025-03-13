#!/bin/bash

if [ "$#" -ne "1" ] ; then
  echo "Usage: $0 <infile.txt>"
  echo "file contents must be url, 4 spaces, desired name"
  echo "eg: "
  echo "https://github.com/izcet/status-changer    izcet/status-changer"
  exit 1
fi

INFILE="$1"
OUTFILE="_KANBAN.md"
OUTFILE_SECTION="## undone"
OUTDIR="items"

while read LINE ; do
  URL="$(echo "$LINE" | sed 's/ .*//')"
  TITLE="$(echo "$LINE" | sed 's/.*    //')"
  HTTPCODE="$(curl -sI "$URL" | head -n1 | cut -f2 -d' ')"
  TAGS=""
  USERNAME="$(echo "$TITLE" | sed 's:/.*::')"
  mkdir -p "$OUTDIR/$USERNAME"


  if [ ! -f "$OUTDIR/$TITLE" ] ; then
    if [ "$HTTPCODE" -eq "200" ] ; then
      TAGS="#public ${TAGS}"
    elif [ "$HTTPCODE" -eq "404" ] ; then
      TAGS="#private ${TAGS}"
    else 
      TAGS="#anomalous #private ${TAGS}"
    fi

    # expands to items/username/projectname.md
    echo -e "$URL\n$TAGS" >> "$OUTDIR/$TITLE.md"
    #? is the sed delimiter because /:-[] all appear in urls and markdown
    SED_REPLACE="s?$OUTFILE_SECTION?&\n- [ ] [[items/$TITLE|$TITLE]]\n  $TAGS?"
    echo $SED_REPLACE
    sed -i "$SED_REPLACE" "$OUTFILE" 

  fi
  echo $LINE
done < "$INFILE"
