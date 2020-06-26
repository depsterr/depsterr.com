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

cd "$(dirname "$0")" || exit 1

echo "$0" | grep -q '.*\.git' && {
	echo "cannot use a repo that ends in git"
	exit 1
}

#shellcheck disable=2016
[ -z "$1" ] && {
	echo '$1 is empty'
	exit 1
}

#shellcheck disable=2016
[ -z "$1" ] && {
	echo '$2 is empty'
	exit 1
}

# $1 = full path to repo
# $2 = file which lists repo paths

DESTDIR="doc/git"
REPODIR="$DESTDIR/$(basename "$1")"

rm -rf "$REPODIR"
mkdir -p "$REPODIR"
(cd "$REPODIR" && stagit "$1")

cat > "$REPODIR/style.css" <<-EOF
body{background:#2e2e2e;}
*{font-family: monospace;}
h1{color:#e88be0;!important}
hr{border-color:#1DDBC9;}
p,tr,td,pre,code{color:#f5f5f5;}
a,a:link,a:visited,a:active{color:#1ddbc9;}
a:hover{color:#f7bf65;}
img{display:none;}
EOF
[ -f "$DESTDIR/style.css" ] || cat > "$DESTDIR/style.css" <<-EOF
body{background:#2e2e2e;}
*{font-family: monospace;}
.desc{color:#e88be0;!important}
hr{border-color:#1DDBC9;}
p,tr,td,pre,code{color:#f5f5f5;}
a,a:link,a:visited,a:active{color: #1ddbc9;}
a:hover{color:#f7bf65;}
img{display:none;}
EOF

[ -f "$2" ] || touch "$2"
in=false
while read -r line; do
	[ "$line" = "$1" ] && {
		in=true
		break
	}
done < "$2"
[ "$in" = true ] || echo "$1" >> "$2"

reponame="$(basename "$1")"
repodir="$(dirname "$1")"
printf 'git://depsterr.com/git/%s\n' "$reponame" > "$repodir/$reponame/url"

# shellcheck disable=2046
stagit-index $(cat "$2") > "$DESTDIR/index.html"
