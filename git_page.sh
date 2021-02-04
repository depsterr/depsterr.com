#!/bin/sh

die() {
	printf '%s\n' "$*"
	exit 1
}

PROGDIR="${0%/*}"
[ "$PROGDIR" != "$0" ] && {
	cd "$PROGDIR" || exit
}

case "$0" in
	*.git)
		echo "cannot use a repo that ends in git"
		exit 1
		;;
esac

[ "$1" ] || die '$1 is empty'
[ "$2" ] || die '$2 is empty'

# $1 = full path to repo
# $2 = file which lists repo paths

DESTDIR="doc/git"

NOSLASH="${1%/}"
GITNAME="${NOSLASH##*/}"
GITDIR="${NOSLASH%/*}"
REPODIR="$DESTDIR/$GITNAME"

MINI=minify
MINIFLAGS="--type css"

rm -rf "$REPODIR"
mkdir -p "$REPODIR"
if cd "$REPODIR"; then
	printf 'git://depsterr.com/git/%s\n' "$GITNAME" > "$GITDIR/$GITNAME/url"
	echo 'deppy' > "$GITDIR/$GITNAME/owner"
	:> "$GITDIR/$GITNAME/git-daemon-export-ok"
	stagit "$1"
else
	die "Unable to cd to $REPODIR"
fi
cd - || die "Unable to return to last directory"

"$MINI" $MINIFLAGS > "$REPODIR/style.css" <<-EOF
body {
	background: #fffff0;
}
* {
    font-family: "Bitstream Vera Serif", "Times New Roman", "serif";
}
pre {
    font-family: monospace;
}
h1,h2,h3,h4,h5,h6 {
    font-weight: normal;
    border-bottom: 1px dashed black;
}
hr {
	border-top: 1px dashed black;
}
img {
	display: none;
}
EOF
"$MINI" $MINIFLAGS > "$DESTDIR/style.css" <<-EOF
body {
	background: #fffff0;
}
* {
    font-family: "Bitstream Vera Serif", "Times New Roman", "serif";
}
pre {
    font-family: monospace;
}
h1,h2,h3,h4,h5,h6 {
    font-weight: normal;
    border-bottom: 1px dashed black;
}
hr {
	border-top: 1px dashed black;
}
img {
	display: none;
}
EOF

[ -f "$2" ] || :> "$2"
unset in
while read -r line; do
	[ "$line" = "$1" ] && {
		in=y
		break
	}
done < "$2"
[ "$in" ] || echo "$1" >> "$2"

# shellcheck disable=2046
stagit-index $(cat "$2") > "$DESTDIR/index.html"
