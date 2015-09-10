# lib
 vlog pow_pol_lib.v
 vlog pow_pol_tb.v

 vsim -L  G:/work_hard/ip_reed_solomon/active/rtl_lib/uni_vlib -t ns work.pow_pol_tb
 # G:/work_hard/ip_reed_solomon/active/rtl_lib/uni_vlib
 # C:/home/igorya/ip_reed_solomon/active/rtl_lib/uni_vlib
 
add wave -noupdate -divider inputs
add wave -noupdate -format Logic -radix unsigned /pow_pol_tb/din

add wave -noupdate -divider outputs
# out tester
add wave -noupdate -format Logic -radix unsigned /pow_pol_tb/dout

# 
run 250