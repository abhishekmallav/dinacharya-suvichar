#!/bin/bash

README="README.md"
TMP="tmp.txt"
HEADER="<!-- HEADER -->"

RESPONSE=$(curl -s -H "X-Api-Key: $API_NINJAS_KEY" \
"https://api.api-ninjas.com/v2/quoteoftheday")

if [ -z "$RESPONSE" ]; then
    echo "Error: No response from API"
    exit 1
fi

QUOTE=$(jq -r '.[0].quote // "No quote available"' <<< "$RESPONSE")
AUTHOR=$(jq -r '.[0].author // "Unknown author"' <<< "$RESPONSE")

NUM=$(shuf -i 5-20 -n 1)

DOT=""

for i in $(seq 1 $((NUM-1))); do
    DOT="${DOT} ●"
    echo "${DOT}" > "$TMP"
    git add "$TMP"
    git commit -m "committed (${DOT})"
done

LINE="[$NUM] $DOT ●"

echo "Author: $AUTHOR"
echo "Quote: $QUOTE"
echo $LINE

TEXT="
> ### $QUOTE
> *- $AUTHOR*
>
> \`$LINE\`

"

awk -v header="$HEADER" -v text="$TEXT" '
{
    print
    if ($0 == header) {
        print text
    }
}
' "$README" > temp.txt

mv temp.txt "$README"

git add "$README"
git commit -m "today's commits: $NUM & quote of the day by: $AUTHOR "