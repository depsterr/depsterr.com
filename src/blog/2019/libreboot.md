# Librebooting the macbook 2,1

![libreboot boot screen](/res/clibreboot.jpg)

My macbook showing its libreboot boot screen

## What and why?

Recently I've taken interest in [libreboot](https://www.libreboot.org), an open source bios alternative. The main reasons for my interest in libreboot are privacy and it being open source. Now, how could switching your bios effect your privacy? Well, on all modern systems there will be a backdoor of sorts put there by the CPU manufacturer. Intel, which most laptops use, has the Intel management engine, or the ime. The ime is a separate chip constantly running on your computer (even when it's turned off). It has access to your entire system, including the internet, a clear invasion of privacy.

## The installation process

Unlike most of the computers that libreboot supports you don't need to physically open the computer to flash libreboot on the macbook 2,1, instead you simply run an installation script from the computer and then reboot. However, installing linux itself on the macbook was a pain.

At first I tried installation media I had lying around, but neither debian nor arch would boot on the mac. Since mac OS comes on a disc I thought that the reason for my installation media not booting was because of being booted from a USB and not the CD/DVD disk reader. Luckily this wasn't the case and after doing some digging I found [this](https://wiki.debian.org/InstallingDebianOn/Apple/MacBook/2-1) debian wiki page which explained that the computer only boots i386-EFI/32-bit UEFI partitions. Since I knew that after installing libreboot I'd be able to boot other devices I simply searched for a 32-bit UEFI live distro and found a live image for fedora which I could boot on the macbook.

After this it ran pretty smoothly, the progress that is, not fedora which ran slow as syrup even though I was only working in the tty. Slow speeds are to be expected with live usbs though so I couldn't really complain. Next up I downloaded the libreboot utils and roms using wget from the tty and ran the installation script, which immediately returned an error message. I asked around on [the libreboot irc](https://webchat.freenode.net/#libreboot) and they refered me to [this](https://libreboot.org/faq.html#flashrom-complains-about-devmem-access) part of the libreboot FAQ, and after following the instructions the installer ran flawlessly. After a while of running it showed me the magical message I'd been waiting for: `Verifying flash... VERIFIED.`

After rebooting my computer I quickly noticed an issue. It didn't boot. At first I thought that I had bricked the mac, which made me feel pretty bummed out, however I once again asked for help in [the libreboot irc](https://webchat.freenode.net/#libreboot) and was advised to try moving the ram sticks around, luckily apple hadn't decided to hide the ram sticks from the user yet back in 2007 so I quickly got to testing. Trying the different combinations and seeing it repeatedly fail made me think that I really had bricked it, however the very last combination worked and the computer booted. Seeing the familiar picture of tux and gnu felt amazing. After this I installed [parabola](https://en.wikipedia.org/wiki/Parabola_GNU/Linux-libre) on the mac, a 100% free (open source) linux distro.

## Making the macbook a bit more useable

As I mentioned before, the macbook is far from a dream laptop, however I've tried to make it slightly more useable. The computer is quite slow, this doesn't really affect me since I use i3 in a minimal distro, though something that does bother me is the battery life. I tried installing [tlp](https://wiki.archlinux.org/index.php/TLP) which is a power manager for linux (and one of the best programs ever), however even with tlp the battery only lasts for around two and a half hours. Another problem with the macbook is how hot it gets. To help with this I drilled holes through the bottom in an attempt to improve the airflow.

![macbook 2,1-with-holes](/res/clibreboot-holes.jpg)

Bottom side of my macbook showing the holes

To drill the holes I opened the computer (apple still let you do that in 2007), and removed the CD/DVD reader since I'd never use it and it makes an annoying noise on startup. Then I drilled holes where the CD/DVD reader used to be. This helped a bit with the heating issue, however the CD/DVD reader was of course not what generated the heat, to get a better affect I would have to drill holes under the CPU, though removing the motherboard is a bit to tedious for me to consider it at the moment.

## Afterthoughts

In hindsight I made a lot of stupid mistakes that ultimately cost me a lot of time, however I think that the process as a whole has been a valuable experience. The macbook has a horrible battery life and heats up really fast so I don't think I'll use it all that much, but I already knew all that when I bought it. It's been fun learning about the libreboot project, and I plan to buy a thinkpad x200 in the future and libreboot that, since I'd actually be able to use that as my day-to-day laptop.

<hr>

* Originally written: 2019-11-30
* Last edited: 2019-12-02 12:14
