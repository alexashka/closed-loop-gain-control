proc power {base p} {
set result 1
while {$p > 0} {
set result [expr $result*$base]
set p [expr $p-1]
}
return $result
}