#! /bin/sh
cd "$(dirname "$0")"

DESTDIR=doc
SRCDIR=src
HASHFILE=checksums

HEADER="$SRCDIR/header.html"
NAVBAR="$SRCDIR/navbar.html"
FOOTER="$SRCDIR/footer.html"

# md to html program
MD=smu

# generate pages
for file in $(find "$SRCDIR" -maxdepth 1 -type f -name '*.md'); do
	destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
	"$MD" "$file" | cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination"
done

# create dirs
for dir in $(find "$SRCDIR" -type d -not -name "$SRCDIR"); do
	mkdir -p "${dir/$SRCDIR/$DESTDIR}"
done

# generate blog pages
for dir in $(find "$SRCDIR" -type d -not -name "$SRCDIR"); do
	sidebar="<aside id=\"sidebar\"><ul>"
	for file in $(find "$dir" -type f -name '*.md' | sed 's/\.md/\.html/g'); do
		file="$(basename "$file")"
		sidebar="${sidebar}<li><a href=\"$file\">${file%.html}</a></li>"
	done
	sidebar="${sidebar}</ul></aside>"
	for file in $(find "$dir" -type f -name '*.md'); do
		destination="$(echo "$file" | sed -e "s/$SRCDIR/$DESTDIR/g" -e 's/\.md/\.html/g')"
		cat "$HEADER" "$NAVBAR" - "$FOOTER" > "$destination" <<-EOF
$sidebar
$("$MD" "$file")
EOF
	done
done

