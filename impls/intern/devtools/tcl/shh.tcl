#!/usr/local/bin/wish -f
# button .b -text "Hello, world!" -command exit
# pack .b
proc power {base p} {
set result 1
while {$p > 0} {
set result [expr $result*$base]
set p [expr $p-1]
}
return $result
}
# gui
entry .base -width 6  -textvariable base
entry .power -width 6  -textvariable power 
# -relief sunken -relief sunken
label .label2 -text "is"
label .label1 -text "to the power"
label .result -textvariable result
button .button1 -text "Calc"
# упаковка виджетов
pack .base .label1 .power .label2 .result .button1 \
-side left -padx 1m -pady 2m
# binding
bind .base <Button-1> {
	set result [power $base $power]
}
bind .power <Button-1> {
	set result [power $base $power]
}

