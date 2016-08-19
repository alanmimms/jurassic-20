EESchema Schematic File Version 2
LIBS:o_ecl
LIBS:ecl
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:kl10-cache
EELAYER 25 0
EELAYER END
$Descr B 17000 11000
encoding utf-8
Sheet 2 6
Title "DATA PATH"
Date ""
Rev ""
Comp "Digitized Equipment Corporation"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 4250 2550 800  2100
U 57B6B963
F0 "dpa01" 60
F1 "dpa01.sch" 60
F2 "ar-0-2-sel" I L 4250 2900 60 
F3 "dp04-clk" I L 4250 2650 60 
F4 "ar-3-5-sel" I L 4250 3000 60 
F5 "arm-sel-4" I L 4250 3500 60 
F6 "arm-sel-2" I L 4250 3400 60 
F7 "arm-sel-1" I L 4250 3300 60 
F8 "arm-en" I L 4250 3200 60 
F9 "ar" O R 5050 2650 60 
F10 "arm.5-x5" I L 4250 3950 60 
F11 "arm.1-x7" I L 4250 3700 60 
F12 "arm.0-x7" I L 4250 3600 60 
F13 "arm.4-x5" I L 4250 3850 60 
F14 "armm" I L 4250 4500 60 
F15 "ad" I L 4250 4400 60 
F16 "cache-data" I L 4250 4100 60 
F17 "ebus-d" I L 4250 4200 60 
F18 "sh" I L 4250 4600 60 
$EndSheet
$Sheet
S 5350 2550 1000 2850
U 57B6B9B0
F0 "dpa02" 60
F1 "dpa02.sch" 60
F2 "ad" I L 5350 4300 60 
F3 "sh" I L 5350 4400 60 
F4 "adx" I L 5350 4500 60 
F5 "cache-data" I L 5350 3700 60 
F6 "mqm" O R 6350 3150 60 
F7 "dp04-clk" I L 5350 2650 60 
F8 "ctl-arx-load" I L 5350 2900 60 
F9 "arxm.0-d7" I L 5350 3350 60 
F10 "arxm-sel-1" I L 5350 3200 60 
F11 "arxm-sel-2" I L 5350 3100 60 
F12 "arxm-sel-4" I L 5350 3000 60 
F13 "arxm.1-d7" I L 5350 3450 60 
F14 "arxm.5-d5" I L 5350 3550 60 
F15 "ctl-mqm-en" I L 5350 4000 60 
F16 "ctl-mqm-sel-2" I L 5350 3900 60 
F17 "ctl-mqm-sel-1" I L 5350 3800 60 
F18 "mqm.0-d10" I L 5350 4750 60 
F19 "mqm.0-d00" I L 5350 4650 60 
F20 "ctl-mq-sel-1" I L 5350 4900 60 
F21 "ctl-mq-sel-2" I L 5350 5000 60 
F22 "mqm.3-5-dr" I L 5350 5150 60 
F23 "arxm" O R 6350 2750 60 
F24 "arx" O R 6350 2650 60 
F25 "mq" O R 6350 3050 60 
$EndSheet
$Sheet
S 6550 2550 1100 2850
U 57B6BA15
F0 "dpa03" 60
F1 "dpa03.sch" 60
F2 "ad-ex" O R 7650 2750 60 
F3 "ad" O R 7650 2650 60 
F4 "fm" I L 6550 3150 60 
F5 "br" I L 6550 2850 60 
F6 "arx" I L 6550 2750 60 
F7 "mq" I L 6550 3050 60 
F8 "brx" I L 6550 2950 60 
F9 "ar" I L 6550 2650 60 
F10 "vma-held-or-pc" I L 6550 3350 60 
F11 "cram-ad-sel-1" I L 6550 3900 60 
F12 "cram-ad-sel-2" I L 6550 3800 60 
F13 "cram-ad-sel-8" I L 6550 3600 60 
F14 "cram-ad-sel-4" I L 6550 3700 60 
F15 "cram-ad-boole" I L 6550 3500 60 
F16 "ad-2-5-cin" I L 6550 4300 60 
F17 "adx-3-5-cin" I L 6550 4400 60 
F18 "ad-overflow.0-l" O R 7650 3050 60 
F19 "ad.0-5=0" O R 7650 2950 60 
F20 "adb.-2-sel4" I L 6550 4500 60 
F21 "cram-adb-sel1" I L 6550 4900 60 
F22 "cram-adb-sel2" I L 6550 4800 60 
F23 "cram-ada-sel1" I L 6550 5100 60 
F24 "cram-ada-sel2" I L 6550 5000 60 
F25 "cram-ada-dis.0" I L 6550 5200 60 
F26 "adb.4-d03" I L 6550 4000 60 
F27 "adb.5-d11" I L 6550 4100 60 
F28 "adb.5-d13" I L 6550 4200 60 
$EndSheet
$Sheet
S 8050 2550 1100 2850
U 57B6BA75
F0 "dpa04" 60
F1 "dpa04.sch" 60
F2 "ebus-driver-mask.0" I L 8050 3900 60 
F3 "diag-read-func-12x" I L 8050 4000 60 
F4 "fm-write.0-35-l" I L 8050 4100 60 
F5 "edp-fm-parity.0-5" O R 9150 3650 60 
F6 "cram-br-load" I L 8050 3800 60 
F7 "ad" I L 8050 3100 60 
F8 "ar" I L 8050 2700 60 
F9 "br" I L 8050 2800 60 
F10 "arx" I L 8050 2900 60 
F11 "mq" I L 8050 3450 60 
F12 "brx" I L 8050 3000 60 
F13 "fm" I L 8050 3550 60 
F14 "adx" I L 8050 3200 60 
$EndSheet
$EndSCHEMATC
