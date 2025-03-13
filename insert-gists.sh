#!/bin/bash

if [ "$#" -ne "1" ] ; then
  echo "Usage: $0 <infile.txt>"
  echo "file contents must be url, 4 spaces, desired name"
  echo "eg: "
  echo "https://gist.github.com/izcet/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa    gist where I scream"
  exit 1
fi

INFILE="$1"
OUTFILE="_KANBAN.md"
OUTFILE_SECTION="## undone"
OUTDIR="items/izcet"

while read LINE ; do
  URL="$(echo "$LINE" | sed 's/ .*//')"
  TITLE="gist--$(echo "$LINE" | sed 's/.*    //')"
  HTTPCODE="$(curl -sI "$URL" | head -n1 | cut -f2 -d' ')"
  TAGS="#gist"
  mkdir -p "$OUTDIR"

  if [ -f "$OUTDIR/$TITLE.md" ] ; then
    echo "$OUTDIR/$TITLE already exists, not updating"
  else
    echo "working on $LINE"
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
    SED_REPLACE="s?$OUTFILE_SECTION?&\n- [ ] [[$OUTDIR/$TITLE|$TITLE]]\n  $TAGS?"
    sed -i "$SED_REPLACE" "$OUTFILE" 

  fi
done < "$INFILE"
