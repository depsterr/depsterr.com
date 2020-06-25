#! /bin/sh
cd "$(dirname "$0")" || exit

DESTDIR=doc
SRCDIR=src

HEADER="header.html"
NAVBAR="navbar.html"
FOOTER="footer.html"

# md to html program
MD=smu

# clean old docs
mkdir -p "$DESTDIR"
rm -rf "${DESTDIR:?}"/*

# generate pages
for file in "$SRCDIR"/*.md; do
	[ -z "$file" ] && exit
	destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
	"$MD" "$file" | cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination"
done

# create dirs
find "$SRCDIR" -type d -not -name "$SRCDIR" | while read -r dir; do
	mkdir -p "$(echo "$dir" | sed "s/$SRCDIR/$DESTDIR/g")"
done

# generate blog pages
find "$SRCDIR" -type d -not -name "$SRCDIR" -and -not -name "git" | while read -r dir; do
	sidebar="<aside id=\"sidebar\"><ul>"
	for file in $(ls "$SRCDIR"/*.md | sed 's/\.md/\.html/g'); do
		file="$(basename "$file")"
		sidebar="${sidebar}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	for cdir in "$dir"/*/; do
		cdir="$(basename "$cdir")/"
		sidebar="${sidebar}<li><a href=\"$cdir\">$cdir</a></li>"
	done
	sidebar="${sidebar}</ul></aside>"
	find "$dir" -type f -name '*.md' | while read -r file; do
		destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
		cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination" <<-EOF
$sidebar
$("$MD" "$file")
EOF
	done
done

# generate index pages
find "$DESTDIR" -type d -not -name "$SRCDIR" | while read -r dir; do
	[ -f "$dir/index.html" ] && continue
	sidebar="<aside id=\"sidebar\"><ul>"
	for file in "$dir"/*.html; do
		file="$(basename "$file")"
		sidebar="${sidebar}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	for cdir in "$dir"/*/; do
		cdir="$(basename "$cdir")/"
		sidebar="${sidebar}<li><a href=\"$cdir\">$cdir</a></li>"
	done
	sidebar="${sidebar}</ul></aside>"
	cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$dir/index.html" <<-EOF
$sidebar
EOF
done
