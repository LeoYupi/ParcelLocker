transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/Memory.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/ParcelLocker.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/Screen.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/ClockDivide.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/DISP.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/Keyboard.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/debounce.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/LD.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl {D:/intelFPGA_lite/18.1/class/ParcelLocker/rtl/BP.v}

vlog -vlog01compat -work work +incdir+D:/intelFPGA_lite/18.1/class/ParcelLocker/tb {D:/intelFPGA_lite/18.1/class/ParcelLocker/tb/ClockDivide_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  ClockDivide_tb

add wave *
view structure
view signals
run -all
