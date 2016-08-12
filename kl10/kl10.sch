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
Sheet 1 4
Title "DATA PATH ARX & MQ Registers"
Date "3/6/1980"
Rev "C"
Comp "Digitized Equipment Corporation"
Comment1 "M8512-0-DP02"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
NoConn ~ 9350 -100
$Sheet
S 7850 3250 800  2100
U 57A8973E
F0 "dpa01" 60
F1 "dpa01.sch" 60
F2 "ar-0-2-sel" I L 7850 3600 60 
F3 "dp04-clk" I L 7850 3350 60 
F4 "ar-3-5-sel" I L 7850 3700 60 
F5 "arm-sel-4" I L 7850 4200 60 
F6 "arm-sel-2" I L 7850 4100 60 
F7 "arm-sel-1" I L 7850 4000 60 
F8 "arm-en" I L 7850 3900 60 
F9 "ar" O R 8650 3350 60 
F10 "arm.5-x5" I L 7850 4650 60 
F11 "arm.1-x7" I L 7850 4400 60 
F12 "arm.0-x7" I L 7850 4300 60 
F13 "arm.4-x5" I L 7850 4550 60 
F14 "armm" I L 7850 5200 60 
F15 "ad" I L 7850 5100 60 
F16 "cache-data" I L 7850 4800 60 
F17 "ebus-d" I L 7850 4900 60 
F18 "sh" I L 7850 5300 60 
$EndSheet
$Sheet
S 8950 3250 1000 2850
U 57AC9C69
F0 "dpa02" 60
F1 "dpa02.sch" 60
F2 "ad" I L 8950 4900 60 
F3 "sh" I L 8950 5100 60 
F4 "adx" I L 8950 5200 60 
F5 "cache-data" I L 8950 4400 60 
F6 "mqm" O R 9950 3850 60 
F7 "dp04-clk" I L 8950 3350 60 
F8 "ctl-arx-load" I L 8950 3600 60 
F9 "arxm.0-d7" I L 8950 4050 60 
F10 "arxm-sel-1" I L 8950 3900 60 
F11 "arxm-sel-2" I L 8950 3800 60 
F12 "arxm-sel-4" I L 8950 3700 60 
F13 "arxm.1-d7" I L 8950 4150 60 
F14 "arxm.5-d5" I L 8950 4250 60 
F15 "ctl-mqm-en" I L 8950 4700 60 
F16 "ctl-mqm-sel-2" I L 8950 4600 60 
F17 "ctl-mqm-sel-1" I L 8950 4500 60 
F18 "mqm.0-d10" I L 8950 5450 60 
F19 "mqm.0-d00" I L 8950 5350 60 
F20 "ctl-mq-sel-1" I L 8950 5600 60 
F21 "ctl-mq-sel-2" I L 8950 5700 60 
F22 "mqm.3-5-dr" I L 8950 5850 60 
F23 "arxm" O R 9950 3450 60 
F24 "arx" O R 9950 3350 60 
F25 "mq" O R 9950 3750 60 
$EndSheet
$Sheet
S 10150 3250 1100 2850
U 57ACBE4E
F0 "dpa03" 60
F1 "dpa03.sch" 60
F2 "ad-ex" O R 11250 3450 60 
F3 "ad" O R 11250 3350 60 
F4 "fm" I L 10150 4000 60 
F5 "br" I L 10150 3550 60 
F6 "arx" I L 10150 3450 60 
F7 "mq" I L 10150 3800 60 
F8 "pc" I L 10150 3900 60 
F9 "brx" I L 10150 3650 60 
F10 "ar" I L 10150 3350 60 
F11 "vma-held-or-pc" I L 10150 4700 60 
$EndSheet
$EndSCHEMATC
