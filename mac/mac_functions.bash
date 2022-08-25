# ~/.mac_functions.bash
# My function list is getting too involved for .bash_aliases

# Open pcap in new Wireshark instance
wsopen() {
  /Applications/Wireshark.app/Contents/MacOS/Wireshark "$@" >/dev/null 2>&1 &
}

# list MacOS domains (OS configuration info)
listdomains() {
  defaults domains | sed y/" "/"\n"/ | sed s/' '//
}

# vim: set syntax=bash:
