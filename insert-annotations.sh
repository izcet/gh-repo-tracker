#!/bin/bash

if [ "$GH_API" ] ; then
  echo "Github token set!"
else
  echo "Github API token unset!"
  echo "Follow these instructions:"
  echo "  https://docs.github.com/en/rest/authentication/authenticating-to-the-rest-api?apiVersion=2022-11-28"
  echo "And export your token as GH_API"
fi

OUTFILE="_KANBAN.md"
OUTDIR="items"
USERS="users"

for DIR in "$OUTDIR"/* ; do
  for FILE in "$DIR"/* ; do
    PROJECT="$(echo "$FILE" | sed "s:^$OUTDIR/\(.*\).md$:\1:")"
    echo $PROJECT
    echo $FILE

    # I think this needs at least one more sed command
    LANGUAGE_TAGS="$(curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GH_API" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$PROJECT/languages" |\
      jq 'keys' |\
      sed ':a;/,/{N;s/,\n//;ba}' |\
      head -n 2 | tail -n 1 |\
      sed 's/"//g' | sed 's/\s\+/ #/g')"

    echo -e "$LANGUAGE_TAGS\n" >> "$FILE"
    sed -i "s?.*$PROJECT.*?&\n$LANGUAGE_TAGS?" "$OUTFILE"

    echo "### contributors:" >> "$FILE"
    curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GH_API" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$PROJECT/contributors" |\
      jq ".[] | .login" |\
      sed 's/"//g' |\
      sed 's:.*:[[users/&|&]]:' >> "$FILE"

    echo "### webhooks:" >> "$FILE"
    echo '```' >> "$FILE"
    curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GH_API" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$PROJECT/hooks" >> "$FILE"
    echo '```' >> "$FILE"
    sleep 1
    done
done 
