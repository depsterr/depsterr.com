# Fuck bash

Bash, the Bourne Again Shell, is probably the most popular shell available for modern Unix based operating systems. In fact, bash has become so popular that if you search for "how to do x in shell" or even "how to do x in posix shell" you'll often find nothing but bashisms.

## The issue(s)

The point of this article is to highlight some of the issues that arise from this BASH centrism, and cover why I personally dislike bash.

### Bloat

The first issue is perhaps the most obvious one, bash is slower than it's more lightweight alternatives. Lighter shells, such as `mksh`, `ash`, or `dash`, are all smaller, simpler, and faster than bash. It's so bad, in fact, that even though Debian uses bash as the user shell it still uses dash for `/bin/sh`. They chose to have 2 shells installed at once than use bash as sh. Unfortunately though, using a posix shell as sh can cause weird issues.

### "Bash is the standard shell"

Bash has become so commonplace that people have started to assume that shell == bash. Because of this you'll require have bash to run a lot of scripts. This is not only annoying, but also makes the scripts less portable. But maybe even worse than this is that a lot of bash scripts will be marked with a `#!/bin/sh`, which means that if you're using a posix compatible shell as your sh (as you should), the script will not function, even with bash installed.

### "Bashisms are good, actually"

"Internet blogger person", I hear you say "Bash has more features than posix shell, and you can even avoid using programs using the built in features!". This is true, and Emacs also has more ""features"" than Vim. Bash reinvents the wheel by implementing it's own versions of test and seq. Most, though admittedly not all, bashisms I see used in scripts could easily be replaced by posix shell utilities. The one upside of these built in utilities would be performance, however as I've already mentioned, bash falls flat in comparison to other shells when it comes to performance as a shell. While it's certainly true that bash is more capable as a language using it's builtins than posix shell is, perhaps you should consider if you're writing a program or a shell script at some point.

## Conclusion

Stop using bash.

---

* Originally written: 2020-06-19 03:28
* Last edited: 2020-09-16 10:02
