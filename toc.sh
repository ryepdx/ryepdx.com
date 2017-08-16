line_format="<li><span class=\"date\">%s/%s</span><a href=\"%s\">%s</a></li>"
posts="$(find . -name "*.html" | grep "./20*" | sort)"
ignore="$(readlink -f _ignore/* | sed "s/$(pwd | sed 's/\//\\\//g')/./g" | sort)"
filtered_posts="$(comm -23 <(echo "$posts") <(echo "$ignore"))"
links="$(echo "$filtered_posts" | sort -r | sed -e 's/^\.//g' -e 's/.html//g' | while read x; do echo "$x" | grep "[^-]*-" | sed -e 's/\//\t/g' -e 's/-/ /g' -e 's/[[:graph:]]*/\u&/g' | while read i; do printf "$line_format\n" "$(echo "$i" | cut -f 1)" "$(echo "$i" | cut -f 2)" "$x" "$(echo "$i" | cut -f 3 | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b")"; done; done)"

printf "$(cat _template.html)" "<h1>Table of Contents</h1><ul class=\"toc\">$links</ul>"
