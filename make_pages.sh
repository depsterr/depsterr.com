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
rm -rf "$(find "$DESTDIR" -not -name "$DESTDIR" -and -not -path "*/git/*")"

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

# generate blog pages
find "$SRCDIR" -type d -not -name "$SRCDIR" -and -not -path "*/git/*" | while read -r dir; do
	inner=""
	for file in "$SRCDIR"/*.md; do
		[ -f "$file" ] || continue
		file="$(basename "${file%.md}.html")"
		inner="${inner}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	for cdir in "$dir"/*/; do
		[ -d "$cdir" ] || continue
		cdir="$(basename "$cdir")/"
		inner="${inner}<li><a href=\"$cdir\">$cdir</a></li>"
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
find "$DESTDIR" -type d -not -name "$SRCDIR" -and -not -path "*/git/*" | while read -r dir; do
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
