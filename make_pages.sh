#!/bin/sh

PROGDIR="${0%/*}"
[ "$PROGDIR" != "$0" ] && {
	cd "$PROGDIR" || exit
}

DESTDIR=doc
SRCDIR=src
RESDIR=res
GITDIR=git

HEADER="header.html"
NAVBAR="navbar.html"
FOOTER="footer.html"

MD=smu
MINI=minify
MINIFLAGS="--type html"

create_page() {
	"$MINI" $MINIFLAGS "$HEADER"
	"$MINI" $MINIFLAGS "$NAVBAR"
	[ "$2" ] && printf '%s\n' "$2"
	[ "$1" ] && "$MD" "$1" | "$MINI" $MINIFLAGS
	"$MINI" $MINIFLAGS "$FOOTER"
}

mkdir -p "$DESTDIR"

# clean old docs
for e in "$DESTDIR"/*; do
	[ "$e" = "$DESTDIR/$GITDIR" ] || rm -rf "$e"
done

# copy resources
cp -r "$RESDIR" "$DESTDIR/res"

# generate toplevel pages
for f in "$SRCDIR"/*.md; do
	[ -f "$f" ] || continue
	dest="$DESTDIR${f#$SRCDIR}"
	create_page "$f" > "${dest%.md}.html"
done

# recurse dirs and subpages
recurse_dir() {
	for d in "${1%/}"/*/; do
		[ -d "$d" ] && recurse_dir "$d"
	done

	dest="$DESTDIR${1#$SRCDIR}"
	dest="${dest%/}"
	unset TOPLEVEL
	[ -d "$SRCDIR/${dest##*/}" ] && TOPLEVEL=y

	mkdir -p "$dest"

	unset links
	[ "$TOPLEVEL" ] || links='<li><a href="..">..</a></li>'

	for e in "${1%/}"/*; do
		ename="${e##*/}"
		if [ -d "$e" ]; then
			links="$links<li><a href=\"$ename\">$ename</a></li>"
		elif [ -f "$e" ]; then
			case "$e" in
				*index.md)
					;;
				*.md) 
					links="$links<li><a href=\"${ename%.md}.html\">${ename%.md}</a></li>"
					;;
			esac
		fi
	done

	links="<ul>$links</ul>"

	[ -f "$1/index.md" ] || create_page "" "$links" > "$dest/index.html"

	for f in "${1%/}"/*.md; do
		[ -f "$f" ] && {
			fname="${f##*/}"
			create_page "$f" "$links" > "$dest/${fname%.md}.html"
		}
	done
}

for d in "$SRCDIR"/*/; do
	[ -d "$d" ] && recurse_dir "$d"
done
