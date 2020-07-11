# GNU KISS Linux

[GitHub organization page](https://github.com/gkiss-linux)

[Main repos](https://github.com/gkiss-linux/grepo)

[Community repos](https://github.com/gkiss-linux/gcommunity)

## What is GNU KISS Linux?

GNU KISS Linux, abbreviated as GKISS, is an alternative rootfs and set of repositories for [KISS Linux](https://k1ss.org). The only difference between GKISS and KISS is that GKISS uses glibc (the gnu libc) instead of musl. 

GKISS does not use the GNU coreutils.

## How does it work?

GKISS has a separate GKISS repo and GKISS community repo which contain programs that only function under glibc or contain glibc specific patches. All packages not in the GKISS repos will be installed from the KISS repos instead.

## Why should I use GKISS instead of KISS?

If you're happy with KISS Linux, then you really shouldn't. Musl is a much more lightweight option than glibc and if you are able to avoid using glibc then you should.

That being said, you might run into some issues with musl, especially with binaries, since most binaries are linked against glibc.

## How do I install GNU KISS Linux?

Installing GKISS is very similar to installing KISS. Follow the instructions at [the KISS Linux installation page](https://k1ss.org/install) and make the following changes:

* Instead of a KISS Linux tarball, use a [GKISS Linux tarball](https://github.com/gkiss-linux/grepo/releases).

(optional)

* Instead of only adding the community repo also add [the gcommunity repo](https://github.com/gkiss-linux/gcommunity).

## Contributing

Though I am not accepting team members I am more than happy to accept pull requests. GKISS follows the same guidelines as KISS Linux. To find out more check out the following pages:

* [https://k1ss.org/guidestones](https://k1ss.org/guidestones)

* [https://k1ss.org/wiki/kiss/style-guide](https://k1ss.org/wiki/kiss/style-guide)

* [https://github.com/kisslinux/community](https://github.com/kisslinux/community)

* [https://github.com/gkiss-linux/gcommunity](https://github.com/gkiss-linux/gcommunity)

## Reporting issues

If you run into any issues with GKISS then please do one of the following.

### Report an issue on GitHub (referred method)

If you're experiencing an issue with a package from the main repository (provided by either KISS or GKISS) please report them [here](https://github.com/gkiss-linux/grepo/issues).

If you're experiencing an issue with a package from the community repository (either gcommunity or community) please report them [here](https://github.com/gkiss-linux/gcommunity/issues).

### Email me

Email me at [depsterr@protonmail.com](mailto:depsterr@protonmail.com). Make sure to format your subject as follows:

> GKISS: &lt;main / community&gt; &lt;package&gt;

## Future plans

* Add ungoogled chromium to the community repos.
* Expand this site with more detailed information. (Especially regarding contributing)
