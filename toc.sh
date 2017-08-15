links="$(find . -name "*.html" | sort -r | sed 's/^\.//g' | while read x; do echo "$x" | grep "[^-]*-" | sed -e 's/\//\t/g' -e 's/-/ /g' -e 's/[[:graph:]]*/\u&/g' -e 's/.html//g' | while read i; do printf "<li><a href=\"%s\">%s</a></li>\n" "$x" "$(echo "$i" | cut -f 3 | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b")"; done; done)"

printf "$(cat _template.html)" "<h1>Table of Contents</h1><ul>$links</ul>"
