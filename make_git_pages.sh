cd "$(dirname "$0")" || exit

DESTDIR=doc
SRCDIR=src

# generate git pages
find "$SRCDIR" -type d -name "git" | while read -r dir; do
	destdir="$(echo "$dir" | sed -e "s/$SRCDIR/$DESTDIR/g")"
	is_empty=true
	for repo in "$dir"/*/; do
		[ -d "$repo" ] || continue
		is_empty=false
		mkdir -p "$destdir/$repo"
		fullrepo="$PWD/$repo"
		(cd "$destdir/$(basename "$repo")" && stagit "$fullrepo")
	done
	[ "$is_empty" = false ] && stagit-index "$dir"/*/ > "$destdir/index.html"
done


