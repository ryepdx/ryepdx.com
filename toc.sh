# Retrieved and adapted 2017-08-16 from
# https://askubuntu.com/questions/53770/how-can-i-encode-and-decode-percent-encoded-strings-on-the-command-line
urlencodepath() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9/.~_-]) printf "$c" ;;
            *) printf '%%%02x' "'$c"
        esac
    done
}

line_format="<li><span class=\"date\">%s/%s</span><a href=\"%s\">%s</a></li>"
posts="$(find . -name "*.html" | grep "./20*" | sort)"
ignore="$(readlink -f _ignore/* | sed "s/$(pwd | sed 's/\//\\\//g')/./g" | sort)"
filtered_posts="$(comm -23 <(echo "$posts") <(echo "$ignore"))"
links="$(echo "$filtered_posts" | sort -r | sed -e 's/^\.//g' -e 's/.html//g' | while read x; do echo "$x" | grep "[^-]*-" | sed -e 's/\//\t/g' -e 's/-/ /g' -e 's/[[:graph:]]*/\u&/g' | while read i; do printf "$line_format\n" "$(echo "$i" | cut -f 1)" "$(echo "$i" | cut -f 2)" "$(urlencodepath "$x")" "$(echo "$i" | cut -f 3 | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b")"; done; done)"

printf "$(cat _template.html)" "<h1>Table of Contents</h1><ul class=\"toc\">$links</ul>"
