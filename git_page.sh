#!/bin/sh

# https://github.com/dylanaraps/pure-sh-bible
basename() {
    dir=${1%${1##*[!/]}}
    dir=${dir##*/}
    dir=${dir%"$2"}
    printf '%s\n' "${dir:-/}"
}

# https://github.com/dylanaraps/pure-sh-bible
dirname() {
    dir=${1:-.}
    dir=${dir%%"${dir##*[!/]}"}
    [ "${dir##*/*}" ] && dir=.
    dir=${dir%/*}
    dir=${dir%%"${dir##*[!/]}"}
    printf '%s\n' "${dir:-/}"
}

cd "$(dirname "$0")" || exit

echo $0 | grep -q '*.git' && {
	echo "cannot use a repo that ends in git"
	exit 1
}

# $1 = full path to repo

DESTDIR="doc/git/$(basename "$0")"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR"
(cd "$DESTDIR" && stagit "$0")

cat > "$DESTDIR/style.css" <<-EOF
body{background:#2e2e2e;}
*{font-family: monospace;}
#title{font-size:2.5em;}
h1,h2,h3,h4,h6{color:#e88be0;}
hr{border-color:#1DDBC9;}
p,tr,td{color:#f5f5f5;}
a,a:link,a:visited,a:active{color: #1ddbc9;}
a:hover{color:#f7bf65;}
.desc{display:none;}
EOF

stagit-index "$DESTDIR"/*/
