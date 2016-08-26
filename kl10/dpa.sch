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
S 2050 2550 1150 2850
U 57B6B963
F0 "dpa01" 60
F1 "dpa01.sch" 60
F2 "dp04-clk" I L 2050 2650 60 
F3 "[n/6+1,ctl-ar-00-08-load l,ctl-ar-00-08-load-l,ctl-ar-09-17-load-l,ctl-arr-load-l,ctl-arr-load-l,ctl-arr-load-l]" I L 2050 4700 60 
F4 "[n/6+1,ctl-ar-00-08-load-l,ctl-ar-09-17-load-l,ctl-ar-09-17-load-l,ctl-arr-load-l,ctl-arr-load-l,ctl-arr-load-l]" I L 2050 4800 60 
F5 "[n/18+1,ctl-arl-sel-4,cram-arm-sel-4]" I L 2050 4900 60 
F6 "[n/18+1,ctl-arl-sel-2,ctl-arr-sel-2]" I L 2050 5000 60 
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
F9 "ctl-mqm-en" I L 5350 4000 60 
F10 "ctl-mqm-sel-2" I L 5350 3900 60 
F11 "ctl-mqm-sel-1" I L 5350 3800 60 
F12 "ctl-mq-sel-1" I L 5350 5250 60 
F13 "ctl-mq-sel-2" I L 5350 5350 60 
F14 "arxm" O R 6350 2750 60 
F15 "arx" O R 6350 2650 60 
F16 "mq" O R 6350 3050 60 
F17 "[(n+199)/100,ad.34,adx.[n-2]]" I L 5350 4100 60 
F18 "[n/18+1,ctl-arxl-sel-1,ctl-arxr-sel-1]" I L 5350 4950 60 
F19 "[n/18+1,ctl-arxl-sel-2,ctl-arxr-sel-2]" I L 5350 5050 60 
F20 "cram-arxm-sel-4.[n/18+1,0,6]" I L 5350 5150 60 
F21 "[(n+199)/100,ad.35,adx.[n-1]]" I L 5350 4200 60 
F22 "[n/30+1,adx.[n+6] h,mq.0]" I L 5350 4600 60 
F23 "[(n+199)/100,adx.35,mq.[n-1]]" I L 5350 3600 60 
F24 "[(n+199)/100,adx.34,mq.[n-2]]" I L 5350 3300 60 
F25 "[n/30+1,mq.[n+6],ad-cry-02]" I L 5350 2800 60 
$EndSheet
$Sheet
S 9900 2550 1100 2850
U 57B6BA15
F0 "dpa03" 60
F1 "dpa03.sch" 60
F2 "ad-ex" O R 11000 2750 60 
F3 "ad" O R 11000 2650 60 
F4 "fm" I L 9900 3150 60 
F5 "br" I L 9900 2850 60 
F6 "arx" I L 9900 2750 60 
F7 "mq" I L 9900 3050 60 
F8 "brx" I L 9900 2950 60 
F9 "ar" I L 9900 2650 60 
F10 "vma-held-or-pc" I L 9900 3350 60 
F11 "cram-ad-sel-1" I L 9900 3900 60 
F12 "cram-ad-sel-2" I L 9900 3800 60 
F13 "cram-ad-sel-8" I L 9900 3600 60 
F14 "cram-ad-sel-4" I L 9900 3700 60 
F15 "cram-ad-boole" I L 9900 3500 60 
F16 "ad-2-5-cin" I L 9900 4300 60 
F17 "adx-3-5-cin" I L 9900 4400 60 
F18 "ad-overflow.0-l" O R 11000 3050 60 
F19 "ad.0-5=0" O R 11000 2950 60 
F20 "adb.-2-sel4" I L 9900 4500 60 
F21 "cram-adb-sel1" I L 9900 4900 60 
F22 "cram-adb-sel2" I L 9900 4800 60 
F23 "cram-ada-sel1" I L 9900 5100 60 
F24 "cram-ada-sel2" I L 9900 5000 60 
F25 "cram-ada-dis.0" I L 9900 5200 60 
F26 "adb.4-d03" I L 9900 4000 60 
F27 "adb.5-d11" I L 9900 4100 60 
F28 "adb.5-d13" I L 9900 4200 60 
$EndSheet
$Sheet
S 13700 2550 1100 2850
U 57B6BA75
F0 "dpa04" 60
F1 "dpa04.sch" 60
F2 "ebus-driver-mask.0" I L 13700 3900 60 
F3 "diag-read-func-12x" I L 13700 4000 60 
F4 "fm-write.0-35-l" I L 13700 4100 60 
F5 "edp-fm-parity.0-5" O R 14800 3650 60 
F6 "cram-br-load" I L 13700 3800 60 
F7 "ad" I L 13700 3100 60 
F8 "ar" I L 13700 2700 60 
F9 "br" I L 13700 2800 60 
F10 "arx" I L 13700 2900 60 
F11 "mq" I L 13700 3450 60 
F12 "brx" I L 13700 3000 60 
F13 "fm" I L 13700 3550 60 
F14 "adx" I L 13700 3200 60 
F15 "dp04-clk" I L 13700 2600 60 
$EndSheet
Text GLabel 1700 2250 0    60   Input ~ 0
clk-edp-delayed
Wire Wire Line
	1900 2250 1900 2650
Wire Wire Line
	1900 2650 2050 2650
Wire Wire Line
	1700 2250 13500 2250
Wire Wire Line
	5250 2250 5250 2650
Wire Wire Line
	5250 2650 5350 2650
Connection ~ 1900 2250
Wire Wire Line
	13500 2250 13500 2600
Wire Wire Line
	13500 2600 13700 2600
Connection ~ 5250 2250
Wire Bus Line
	3200 2650 3500 2650
Wire Bus Line
	1550 4400 2050 4400
Wire Bus Line
	1550 4500 2050 4500
Wire Bus Line
	1550 4600 2050 4600
Text Label 1550 4200 2    60   ~ 0
ebus-d
Wire Bus Line
	1550 4200 2050 4200
Text Label 1550 4100 2    60   ~ 0
cache-data
Wire Bus Line
	1550 4100 2050 4100
Wire Bus Line
	4850 4300 5350 4300
Wire Bus Line
	4850 4400 5350 4400
Wire Bus Line
	4850 4500 5350 4500
Wire Bus Line
	6350 2650 6650 2650
Wire Bus Line
	6350 2750 6650 2750
Wire Bus Line
	6350 3050 6650 3050
Wire Bus Line
	6350 3150 6650 3150
Wire Bus Line
	9400 2650 9900 2650
Wire Bus Line
	9400 2750 9900 2750
Wire Bus Line
	9400 2850 9900 2850
Wire Bus Line
	9400 2950 9900 2950
Wire Bus Line
	9400 3050 9900 3050
Wire Bus Line
	9400 3150 9900 3150
Wire Bus Line
	11000 2650 11300 2650
Wire Bus Line
	11000 2750 11300 2750
Text Label 4850 3700 2    60   ~ 0
cache-data
Wire Bus Line
	4850 3700 5350 3700
Text Label 4850 3000 2    60   ~ 0
arxm-sel-4
Wire Bus Line
	4850 3000 5350 3000
Text Label 4850 3100 2    60   ~ 0
arxm-sel-2
Wire Bus Line
	4850 3100 5350 3100
Text Label 4850 3200 2    60   ~ 0
arxm-sel-1
Wire Bus Line
	4850 3200 5350 3200
Text Label 1550 3300 2    60   ~ 0
arm-sel-4
Wire Bus Line
	1550 3300 2050 3300
Text Label 1550 3400 2    60   ~ 0
arm-sel-2
Wire Bus Line
	1550 3400 2050 3400
Text Label 1550 3500 2    60   ~ 0
arm-sel-1
Wire Bus Line
	1550 3500 2050 3500
Wire Bus Line
	13200 2700 13700 2700
Wire Bus Line
	13200 2800 13700 2800
Wire Bus Line
	13200 2900 13700 2900
Wire Bus Line
	13200 3000 13700 3000
Wire Bus Line
	13200 3100 13700 3100
Wire Bus Line
	13200 3200 13700 3200
Text Label 13200 3450 2    60   ~ 0
mq
Wire Bus Line
	13200 3450 13700 3450
Text Label 13200 3550 2    60   ~ 0
fm
Wire Bus Line
	13200 3550 13700 3550
Text Label 9400 3500 2    60   ~ 0
cram-ad-boole
Wire Bus Line
	9400 3500 9900 3500
Text Label 9400 3600 2    60   ~ 0
cram-ad-sel-8
Wire Bus Line
	9400 3600 9900 3600
Text Label 9400 3700 2    60   ~ 0
cram-ad-sel-4
Wire Bus Line
	9400 3700 9900 3700
Text Label 9400 3800 2    60   ~ 0
cram-ad-sel-2
Wire Bus Line
	9400 3800 9900 3800
Text Label 9400 3900 2    60   ~ 0
cram-ad-sel-1
Wire Bus Line
	9400 3900 9900 3900
Text Label 9400 4000 2    60   ~ 0
adb.4-d03
Wire Bus Line
	9400 4000 9900 4000
Text Label 9400 4100 2    60   ~ 0
adb.5-d11
Wire Bus Line
	9400 4100 9900 4100
Text Label 9400 4200 2    60   ~ 0
adb.5-d13
Wire Bus Line
	9400 4200 9900 4200
Text Label 9400 4300 2    60   ~ 0
ad-2-5-cin
Wire Bus Line
	9400 4300 9900 4300
Text Label 9400 4400 2    60   ~ 0
adx-3-5-cin
Wire Bus Line
	9400 4400 9900 4400
Text Label 9400 4500 2    60   ~ 0
adb.-2-sel4
Wire Bus Line
	9400 4500 9900 4500
Text Label 9400 4800 2    60   ~ 0
cram-adb-sel2
Wire Bus Line
	9400 4800 9900 4800
Text Label 9400 4900 2    60   ~ 0
cram-adb-sel1
Wire Bus Line
	9400 4900 9900 4900
Text Label 9400 5000 2    60   ~ 0
cram-ada-sel2
Wire Bus Line
	9400 5000 9900 5000
Text Label 9400 5100 2    60   ~ 0
cram-ada-sel1
Wire Bus Line
	9400 5100 9900 5100
Text Label 9400 5200 2    60   ~ 0
cram-ada-dis.0
Wire Bus Line
	9400 5200 9900 5200
Text Label 13200 3800 2    60   ~ 0
cram-br-load
Wire Bus Line
	13200 3800 13700 3800
Text Label 13200 3900 2    60   ~ 0
ebus-driver-mask.0
Wire Bus Line
	13200 3900 13700 3900
Text Label 13200 4000 2    60   ~ 0
diag-read-func-12x
Wire Bus Line
	13200 4000 13700 4000
Text Label 13200 4100 2    60   ~ 0
fm-write.0-35-l
Wire Bus Line
	13200 4100 13700 4100
Text Label 11300 2950 0    60   ~ 0
ad.0-5=0
Wire Bus Line
	11000 2950 11300 2950
Text Label 11300 3050 0    60   ~ 0
ad-overflow.0-l
Wire Bus Line
	11000 3050 11300 3050
Text Label 15100 3650 0    60   ~ 0
edp-fm-parity.0-5
Wire Bus Line
	14800 3650 15100 3650
Text Label 4850 3800 2    60   ~ 0
ctl-mqm-sel-1
Wire Bus Line
	4850 3800 5350 3800
Text Label 4850 3900 2    60   ~ 0
ctl-mqm-sel-2
Wire Bus Line
	4850 3900 5350 3900
Text Label 4850 4000 2    60   ~ 0
ctl-mqm-en
Wire Bus Line
	4850 4000 5350 4000
Text Label 4850 4650 2    60   ~ 0
mqm.0-d00
Wire Bus Line
	4850 4650 5350 4650
Text Label 4850 4750 2    60   ~ 0
mqm.0-d10
Wire Bus Line
	4850 4750 5350 4750
Text Label 4850 4850 2    60   ~ 0
mqm.3-5-dr
Wire Bus Line
	4850 4850 5350 4850
Text Label 4850 5250 2    60   ~ 0
ctl-mq-sel-1
Wire Bus Line
	4850 5250 5350 5250
Text Label 4850 5350 2    60   ~ 0
ctl-mq-sel-2
Wire Bus Line
	4850 5350 5350 5350
Text Label 9400 3350 2    60   ~ 0
vma-held-or-pc
Wire Bus Line
	9400 3350 9900 3350
Text Label 4850 3350 2    60   ~ 0
arxm.0-d7
Wire Bus Line
	4850 3350 5350 3350
Text Label 4850 3450 2    60   ~ 0
arxm.1-d7
Wire Bus Line
	4850 3450 5350 3450
Text Label 4850 3550 2    60   ~ 0
arxm.5-d5
Wire Bus Line
	4850 3550 5350 3550
Text Label 1550 3650 2    60   ~ 0
arm.1-d7
Wire Bus Line
	1550 3650 2050 3650
Text Label 1550 3750 2    60   ~ 0
arm.0-d7
Wire Bus Line
	1550 3750 2050 3750
Text Label 1550 3850 2    60   ~ 0
arm.5-d5
Wire Bus Line
	1550 3850 2050 3850
Text Label 1550 3950 2    60   ~ 0
arm.4-d5
Wire Bus Line
	1550 3950 2050 3950
Text Label 1550 2900 2    60   ~ 0
ar-0-2-sel
Wire Bus Line
	1550 2900 2050 2900
Text Label 1550 3000 2    60   ~ 0
ar-3-5-sel
Wire Bus Line
	1550 3000 2050 3000
Text Label 1550 3200 2    60   ~ 0
arm-en
Wire Bus Line
	1550 3200 2050 3200
Text Label 4850 2900 2    60   ~ 0
ctl-arx-load
Wire Bus Line
	4850 2900 5350 2900
Text HLabel 3500 2650 2    60   Output ~ 0
ar
Text HLabel 6650 2650 2    60   Output ~ 0
arx
Text HLabel 6650 2750 2    60   Output ~ 0
arxm
Text HLabel 6650 3050 2    60   Output ~ 0
mq
Text HLabel 6650 3150 2    60   Output ~ 0
mqm
Text HLabel 9400 2650 0    60   Input ~ 0
ar
Text HLabel 9400 2750 0    60   Input ~ 0
arx
Text HLabel 9400 2850 0    60   Input ~ 0
br
Text HLabel 9400 2950 0    60   Input ~ 0
brx
Text HLabel 9400 3050 0    60   Input ~ 0
mq
Text HLabel 9400 3150 0    60   Input ~ 0
fm
Text HLabel 1550 4400 0    60   Input ~ 0
ad
Text HLabel 1550 4500 0    60   Input ~ 0
armm
Text HLabel 1550 4600 0    60   Input ~ 0
sh
Text HLabel 4850 4300 0    60   Input ~ 0
ad
Text HLabel 4850 4400 0    60   Input ~ 0
sh
Text HLabel 4850 4500 0    60   Input ~ 0
adx
Text HLabel 11300 2650 2    60   Output ~ 0
ad
Text HLabel 11300 2750 2    60   Output ~ 0
ad-ex
Text HLabel 13200 2700 0    60   Input ~ 0
ar
Text HLabel 13200 2800 0    60   Input ~ 0
br
Text HLabel 13200 2900 0    60   Input ~ 0
arx
Text HLabel 13200 3000 0    60   Input ~ 0
brx
Text HLabel 13200 3100 0    60   Input ~ 0
ad
Text HLabel 13200 3200 0    60   Input ~ 0
adx
$EndSCHEMATC
