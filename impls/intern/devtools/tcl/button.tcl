#! /usr/bin/wish

proc include_these_buttons {} {

  add_frame   "Control"
  add_button  "Create Library"  {vlib mylib; vmap work mylib}
  add_button  "Compile"         {  vcom counter.vhd
                                   vcom countertb.vhd
                                   vcom countercf.vhd }
  add_button  "Load Simulation" {vsim mylib.cfg_countertb}
  add_button  "Wave Window"     {source wave.do}
  add_button  "Quit"            {quit -force}

  add_frame   "Simulate"
  add_button  "Run 10"   {run 10}
  add_button  "Run 100"  {run 100}
  add_button  "Run 1000" {run 1000}
  add_button  "Run all"  {run -all}
  add_button  "Restart"  {restart -force}

}

proc add_frame title {
  global buttons
  set buttons(frame) .frame$buttons(widget_count)
  frame $buttons(frame) -border 2 -relief groove
  label $buttons(frame).label -text $title -font $buttons(font)
  pack  $buttons(frame)       -side left -padx 2 -pady 2 -anchor n -fill both -expand 1
  pack  $buttons(frame).label -side top  -padx 2 -pady 2
  incr buttons(widget_count)
}

proc add_button {title command} {
  global buttons
  button $buttons(frame).b$buttons(widget_count) -text $title -font $buttons(font) \
                                                    -command "puts \"$command\""
  pack   $buttons(frame).b$buttons(widget_count) -side top -pady 2 -padx 2 -fill x
  incr buttons(widget_count)
}

proc respond_to_buttons {} {
  global buttons
  if [eof $buttons(pipe_id)] {
    catch {close $buttons(pipe_id)}
  } elseif { [gets $buttons(pipe_id) line] >= 0 } {
    puts $line
    eval $line
  }
}

if [string compare $argv buttons_gui] {
  global buttons
  if [catch {set buttons(pipe_id) [open "|wish buttons.tcl buttons_gui" r+]}] {
    puts "Couldn't start wish for the buttons GUI\n"
  } else {
    fconfigure $buttons(pipe_id) -blocking 0 -buffering line
    fileevent  $buttons(pipe_id) readable respond_to_buttons
  }
} else {
  wm title . Buttons
  set buttons(font) [font create -family {Arial Helvetica "Courier New"} -size 12]
  set buttons(frame) {}
  set buttons(widget_count) 1
  include_these_buttons
}
