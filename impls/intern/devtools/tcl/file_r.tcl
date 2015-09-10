#!/usr/local/bin/tclsh
#if {$argc != 2} {
#error "Usage: tgrep pattern fileName"
#}
set arg "my.txt"
set f [open $arg r]
while {[gets $f line] >= 0} {
		puts stdout $line
}
close $f
