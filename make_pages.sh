#! /bin/sh

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

DESTDIR=doc
SRCDIR=src
RESDIR=res

HEADER="header.html"
NAVBAR="navbar.html"
FOOTER="footer.html"

# md to html program
MD=smu

# clean old docs
mkdir -p "$DESTDIR"
# shellcheck disable=2046
rm -rf $(find "$DESTDIR" -not -name "$DESTDIR" -not -path "*/git*")

# copy resources
cp -r "$RESDIR" "$DESTDIR/res"

# generate pages
for file in "$SRCDIR"/*.md; do
	[ -f "$file" ] || continue
	destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
	"$MD" "$file" | cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination"
done

# create dirs
find "$SRCDIR" -type d -not -name "$SRCDIR" | while read -r dir; do
	mkdir -p "$(echo "$dir" | sed "s/$SRCDIR/$DESTDIR/g")"
done

# generate sub pages
find "$SRCDIR" -type d -not -name "$SRCDIR" -and -not -path "*/git/*" | while read -r dir; do
	inner=""
	for cdir in "$dir"/*/; do
		[ -d "$cdir" ] || continue
		cdir="$(basename "$cdir")/"
		inner="${inner}<li><a href=\"$cdir\">$cdir</a></li>"
	done
	for file in "$dir"/*.md; do
		[ -f "$file" ] || continue
		echo $file | grep -q "index.md" && continue
		file="$(basename "${file%.md}.html")"
		inner="${inner}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	[ -z "$inner" ] && sidebar="" || sidebar="<aside id=\"sidebar\"><ul>${inner}</ul></aside>"
	find "$dir" -type f -name '*.md' | while read -r file; do
		destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
		cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination" <<-EOF
$sidebar
$("$MD" "$file")
EOF
	done
done

# generate index pages
find "$DESTDIR" -type d -not -name "$SRCDIR" -and -not -path "*/git*" | while read -r dir; do
	[ -f "$dir/index.html" ] && continue
	inner=""
	for cdir in "$dir"/*/; do
		[ -d "$cdir" ] || continue
		cdir="$(basename "$cdir")/"
		inner="${inner}<li><a href=\"$cdir\">$cdir</a></li>"
	done
	for file in "$dir"/*.html; do
		[ -f "$file" ] || continue
		file="$(basename "$file")"
		inner="${inner}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	[ -z "$inner" ] && sidebar="" || sidebar="<aside id=\"sidebar\"><ul>${inner}</ul></aside>" 
	cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$dir/index.html" <<-EOF
$sidebar
EOF
done
