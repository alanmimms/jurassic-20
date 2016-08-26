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
Sheet 3 6
Title "DATA PATH AR Register"
Date "10/21/1976"
Rev "A"
Comp "Digitized Equipment Corporation"
Comment1 "M8512-0-DP01"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MC10164 e53
U 1 1 57A676FA
P 3900 3600
AR Path="/57B68864/57B6B963/57A676FA" Ref="e53"  Part="1" 
AR Path="/57B6D511/57B6B963/57A676FA" Ref="e53"  Part="1" 
F 0 "e53" H 3920 4350 60  0000 C CNN
F 1 "MC10164" H 3940 2850 60  0000 C CNN
F 2 "" H 3900 3600 60  0000 C CNN
F 3 "" H 3900 3600 60  0000 C CNN
	1    3900 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 4200 3300 9550
Wire Wire Line
	2650 6850 3300 6850
Wire Wire Line
	2650 6200 3150 6200
Wire Wire Line
	3150 3900 3150 9250
Wire Wire Line
	3150 3900 3300 3900
Wire Wire Line
	2700 5550 3000 5550
Wire Wire Line
	3000 4000 3000 9350
Wire Wire Line
	3000 4000 3300 4000
Wire Wire Line
	2700 4800 2850 4800
Wire Wire Line
	2850 4100 2850 9450
Wire Wire Line
	2850 4100 3300 4100
$Comp
L MC10164 e46
U 1 1 57A7828A
P 7050 3600
AR Path="/57B68864/57B6B963/57A7828A" Ref="e46"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7828A" Ref="e46"  Part="1" 
F 0 "e46" H 7070 4350 60  0000 C CNN
F 1 "MC10164" H 7090 2850 60  0000 C CNN
F 2 "" H 7050 3600 60  0000 C CNN
F 3 "" H 7050 3600 60  0000 C CNN
	1    7050 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 3900 9550 3900
Wire Wire Line
	3350 4000 9550 4000
Wire Wire Line
	3350 4100 9550 4100
Wire Wire Line
	3350 4200 9550 4200
Wire Wire Line
	4500 3000 4600 3000
Wire Wire Line
	7650 3000 7800 3000
$Comp
L MC10164 e47
U 1 1 57A791AF
P 10150 3600
AR Path="/57B68864/57B6B963/57A791AF" Ref="e47"  Part="1" 
AR Path="/57B6D511/57B6B963/57A791AF" Ref="e47"  Part="1" 
F 0 "e47" H 10170 4350 60  0000 C CNN
F 1 "MC10164" H 10190 2850 60  0000 C CNN
F 2 "" H 10150 3600 60  0000 C CNN
F 3 "" H 10150 3600 60  0000 C CNN
	1    10150 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	10750 3000 10900 3000
Connection ~ 6450 3900
Connection ~ 6450 4000
Connection ~ 6450 4100
Connection ~ 6450 4200
$Comp
L MC10141 e39
U 1 1 57A7ADE0
P 12050 1900
AR Path="/57B68864/57B6B963/57A7ADE0" Ref="e39"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7ADE0" Ref="e39"  Part="1" 
F 0 "e39" H 12070 2500 60  0000 C CNN
F 1 "MC10141" H 12090 1300 60  0000 C CNN
F 2 "" H 12050 1900 60  0000 C CNN
F 3 "" H 12050 1900 60  0000 C CNN
	1    12050 1900
	1    0    0    -1  
$EndComp
NoConn ~ 9350 -100
NoConn ~ 11450 1450
NoConn ~ 11450 1950
Wire Wire Line
	10750 3000 10750 1850
Wire Wire Line
	10750 1850 11450 1850
Wire Wire Line
	7650 3000 7650 1750
Wire Wire Line
	7650 1750 11450 1750
Wire Wire Line
	4500 1650 11450 1650
Wire Wire Line
	11450 1650 11450 1550
Wire Wire Line
	11450 2250 11450 2450
Wire Wire Line
	11450 2450 10250 2450
Wire Wire Line
	10200 2150 11450 2150
$Comp
L MC10164 e41
U 1 1 57A7DDB6
P 4150 8950
AR Path="/57B68864/57B6B963/57A7DDB6" Ref="e41"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7DDB6" Ref="e41"  Part="1" 
F 0 "e41" H 4170 9700 60  0000 C CNN
F 1 "MC10164" H 4190 8200 60  0000 C CNN
F 2 "" H 4150 8950 60  0000 C CNN
F 3 "" H 4150 8950 60  0000 C CNN
	1    4150 8950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 8350 3550 8350
Wire Wire Line
	2600 8450 3550 8450
Wire Wire Line
	2600 8550 3550 8550
Wire Wire Line
	2600 8650 3550 8650
Wire Wire Line
	2600 8750 3550 8750
Wire Wire Line
	2600 8850 3550 8850
Wire Wire Line
	2600 8950 3550 8950
$Comp
L MC10164 e40
U 1 1 57A7DDD2
P 7300 8950
AR Path="/57B68864/57B6B963/57A7DDD2" Ref="e40"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7DDD2" Ref="e40"  Part="1" 
F 0 "e40" H 7320 9700 60  0000 C CNN
F 1 "MC10164" H 7340 8200 60  0000 C CNN
F 2 "" H 7300 8950 60  0000 C CNN
F 3 "" H 7300 8950 60  0000 C CNN
	1    7300 8950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 9250 9800 9250
Wire Wire Line
	3600 9350 9800 9350
Wire Wire Line
	3600 9450 9800 9450
Wire Wire Line
	3600 9550 9800 9550
Wire Wire Line
	6600 8350 6700 8350
Wire Wire Line
	6600 8450 6700 8450
Wire Wire Line
	6600 8550 6700 8550
Wire Wire Line
	6600 8650 6700 8650
Wire Wire Line
	6600 8750 6700 8750
Wire Wire Line
	6600 8850 6700 8850
Wire Wire Line
	6600 8950 6700 8950
Wire Wire Line
	4750 8350 4850 8350
Wire Wire Line
	7900 8350 8050 8350
$Comp
L MC10164 e54
U 1 1 57A7DDF0
P 10400 8950
AR Path="/57B68864/57B6B963/57A7DDF0" Ref="e54"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7DDF0" Ref="e54"  Part="1" 
F 0 "e54" H 10420 9700 60  0000 C CNN
F 1 "MC10164" H 10440 8200 60  0000 C CNN
F 2 "" H 10400 8950 60  0000 C CNN
F 3 "" H 10400 8950 60  0000 C CNN
	1    10400 8950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 8350 9800 8350
Wire Wire Line
	9700 8450 9800 8450
Wire Wire Line
	9700 8550 9800 8550
Wire Wire Line
	9700 8650 9800 8650
Wire Wire Line
	9700 8750 9800 8750
Wire Wire Line
	9700 8950 9800 8950
Wire Wire Line
	9700 9050 9800 9050
Wire Wire Line
	11000 8350 11150 8350
Connection ~ 6700 9250
Connection ~ 6700 9350
Connection ~ 6700 9450
Connection ~ 6700 9550
$Comp
L MC10141 e51
U 1 1 57A7DE0C
P 12300 7250
AR Path="/57B68864/57B6B963/57A7DE0C" Ref="e51"  Part="1" 
AR Path="/57B6D511/57B6B963/57A7DE0C" Ref="e51"  Part="1" 
F 0 "e51" H 12320 7850 60  0000 C CNN
F 1 "MC10141" H 12340 6650 60  0000 C CNN
F 2 "" H 12300 7250 60  0000 C CNN
F 3 "" H 12300 7250 60  0000 C CNN
	1    12300 7250
	1    0    0    -1  
$EndComp
NoConn ~ 11700 6800
NoConn ~ 11700 7300
Wire Wire Line
	11000 8350 11000 7200
Wire Wire Line
	11000 7200 11700 7200
Wire Wire Line
	7900 8350 7900 7100
Wire Wire Line
	7900 7100 11700 7100
Wire Wire Line
	4750 8350 4750 7000
Wire Wire Line
	4750 7000 11700 7000
Wire Wire Line
	11700 7600 11700 7850
Wire Wire Line
	10450 7500 11700 7500
Wire Wire Line
	2600 9050 3550 9050
Wire Wire Line
	3300 9550 3550 9550
Connection ~ 3300 6850
Wire Wire Line
	3150 9250 3550 9250
Connection ~ 3150 6200
Wire Wire Line
	3000 9350 3550 9350
Connection ~ 3000 5550
Wire Wire Line
	2850 9450 3550 9450
NoConn ~ 16700 3000
NoConn ~ 9350 -100
NoConn ~ 11450 1450
NoConn ~ 11450 1950
NoConn ~ 11700 6800
NoConn ~ 11700 7300
NoConn ~ 16700 3000
Text HLabel 10250 2450 0    60   Input ~ 0
[n/6+1,ctl-ar-00-08-load l,ctl-ar-00-08-load-l,ctl-ar-09-17-load-l,ctl-arr-load-l,ctl-arr-load-l,ctl-arr-load-l]
Text HLabel 10200 2150 0    60   Input ~ 0
dp04-clk
Text HLabel 10450 7850 0    60   Input ~ 0
[n/6+1,ctl-ar-00-08-load-l,ctl-ar-09-17-load-l,ctl-ar-09-17-load-l,ctl-arr-load-l,ctl-arr-load-l,ctl-arr-load-l]
Text HLabel 10450 7500 0    60   Input ~ 0
dp04-clk
Text HLabel 2700 4800 0    60   Input ~ 0
[n/18+1,ctl-arl-sel-4,cram-arm-sel-4]
Text HLabel 2700 5550 0    60   Input ~ 0
[n/18+1,ctl-arl-sel-2,ctl-arr-sel-2]
Text HLabel 2650 6200 0    60   Input ~ 0
[n/18+1,ctl-arl-sel-1,ctl-arr-sel-1]
Text HLabel 2650 6850 0    60   Input ~ 0
[n/6+1,ctl-ar-00-11-clr,ctl-ar-00-11-clr,ctl-ar-12-17-clr,ctl-arr-clr,ctl-arr-clr,ctl-arr-clr]
Wire Wire Line
	4500 3000 4500 1650
Wire Wire Line
	11700 7850 10450 7850
Wire Wire Line
	9700 8850 9800 8850
Wire Wire Line
	6600 9050 6700 9050
Text HLabel 12650 1550 2    60   Input ~ 0
ar.[n+0]
Text HLabel 12650 1650 2    60   Input ~ 0
ar.[n+0]
Text HLabel 12650 1750 2    60   Input ~ 0
ar.[n+1]
Text HLabel 12650 1850 2    60   Input ~ 0
ar.[n+2]
Text HLabel 12900 7000 2    60   Input ~ 0
ar.[n+3]
Text HLabel 12900 7100 2    60   Input ~ 0
ar.[n+4]
Text HLabel 12900 7200 2    60   Input ~ 0
ar.[n+5]
Text HLabel 4600 3000 2    60   Input ~ 0
arm.[n+0]
Text HLabel 7800 3000 2    60   Input ~ 0
arm.[n+1]
Text HLabel 10900 3000 2    60   Input ~ 0
arm.[n+2]
Text HLabel 11150 8350 2    60   Input ~ 0
arm.[n+5]
Text HLabel 8050 8350 2    60   Input ~ 0
arm.[n+4]
Text HLabel 4850 8350 2    60   Input ~ 0
arm.[n+3]
Text HLabel 3250 3100 0    60   Input ~ 0
cache-data.[n+0]
Text HLabel 3250 3200 0    60   Input ~ 0
ad.[n+0]
Text HLabel 3250 3300 0    60   Input ~ 0
ebus-d.[n+0]
Text HLabel 3250 3400 0    60   Input ~ 0
sh.[n+0]
Text HLabel 3250 3500 0    60   Input ~ 0
ad.[n+1]
Text HLabel 3250 3600 0    60   Input ~ 0
adx.[n+0]
Wire Wire Line
	3250 3000 3300 3000
Wire Wire Line
	3250 3100 3300 3100
Wire Wire Line
	3250 3200 3300 3200
Wire Wire Line
	3250 3300 3300 3300
Wire Wire Line
	3250 3400 3300 3400
Wire Wire Line
	3250 3500 3300 3500
Wire Wire Line
	3250 3600 3300 3600
Wire Wire Line
	3250 3700 3300 3700
Text HLabel 6350 3000 0    60   Input ~ 0
armm.[n+1]
Text HLabel 6350 3100 0    60   Input ~ 0
cache-data.[n+1]
Text HLabel 6350 3200 0    60   Input ~ 0
ad.[n+1]
Text HLabel 6350 3300 0    60   Input ~ 0
ebus-d.[n+1]
Text HLabel 6350 3400 0    60   Input ~ 0
sh.[n+1]
Text HLabel 6350 3500 0    60   Input ~ 0
ad.[n+2]
Text HLabel 6350 3600 0    60   Input ~ 0
adx.[n+1]
Wire Wire Line
	6350 3000 6450 3000
Wire Wire Line
	6350 3100 6450 3100
Wire Wire Line
	6350 3200 6450 3200
Wire Wire Line
	6350 3300 6450 3300
Wire Wire Line
	6350 3400 6450 3400
Wire Wire Line
	6350 3500 6450 3500
Wire Wire Line
	6350 3600 6450 3600
Wire Wire Line
	6350 3700 6450 3700
Text HLabel 9500 3000 0    60   Input ~ 0
armm.[n+[n]+2]
Text HLabel 9500 3100 0    60   Input ~ 0
cache-data.[n+2]
Text HLabel 9500 3200 0    60   Input ~ 0
ad.[n+2]
Text HLabel 9500 3300 0    60   Input ~ 0
ebus-d.[n+2]
Text HLabel 9500 3400 0    60   Input ~ 0
sh.[n+2]
Text HLabel 9500 3500 0    60   Input ~ 0
ad.[n+3]
Text HLabel 9500 3600 0    60   Input ~ 0
adx.[n+2]
Text HLabel 9500 3700 0    60   Input ~ 0
ad.[n+0]
Wire Wire Line
	9500 3000 9550 3000
Wire Wire Line
	9500 3100 9550 3100
Wire Wire Line
	9500 3200 9550 3200
Wire Wire Line
	9500 3300 9550 3300
Wire Wire Line
	9500 3400 9550 3400
Wire Wire Line
	9500 3500 9550 3500
Wire Wire Line
	9500 3600 9550 3600
Wire Wire Line
	9500 3700 9550 3700
Text HLabel 9700 8350 0    60   Input ~ 0
armm.[n+5]
Text HLabel 9700 8450 0    60   Input ~ 0
cache-data.[n+5]
Text HLabel 9700 8550 0    60   Input ~ 0
ad.[n+5]
Text HLabel 9700 8650 0    60   Input ~ 0
ebus-d.[n+5]
Text HLabel 9700 8750 0    60   Input ~ 0
sh.[n+5]
Text HLabel 9700 8950 0    60   Input ~ 0
adx.[n+5]
Text HLabel 9700 9050 0    60   Input ~ 0
ad.[n+3]
Text HLabel 9700 8850 0    60   Input ~ 0
[n/30+1,ad.[n+6],adx.0]
Text HLabel 6350 3700 0    60   Input ~ 0
[n/6+1,ad-ex.1,ad.5,ad.11,ad.17,ad.23,ad.29]
Text HLabel 3250 3700 0    60   Input ~ 0
[n/6+1,ad-ex.2,ad.4,ad.10,ad.16,ad.22,ad.28]
Text HLabel 6600 8350 0    60   Input ~ 0
armm.[n+4]
Text HLabel 6600 8450 0    60   Input ~ 0
cache-data.[n+4]
Text HLabel 6600 8550 0    60   Input ~ 0
ad.[n+4]
Text HLabel 6600 8650 0    60   Input ~ 0
ebus-d.[n+4]
Text HLabel 6600 8750 0    60   Input ~ 0
sh.[n+4]
Text HLabel 6600 8950 0    60   Input ~ 0
adx.[n+4]
Text HLabel 6600 9050 0    60   Input ~ 0
ad.[n+2]
Text HLabel 2600 8350 0    60   Input ~ 0
armm.[n+4]
Text HLabel 2600 8450 0    60   Input ~ 0
cache-data.[n+3]
Text HLabel 2600 8550 0    60   Input ~ 0
ad.[n+3]
Text HLabel 2600 8650 0    60   Input ~ 0
ebus-d.[n+3]
Text HLabel 2600 8750 0    60   Input ~ 0
sh.[n+3]
Text HLabel 2600 8950 0    60   Input ~ 0
adx.[n+3]
Text HLabel 2600 9050 0    60   Input ~ 0
ad.[n+1]
Text HLabel 2600 8850 0    60   Input ~ 0
ad.[n+4]
Text HLabel 6600 8850 0    60   Input ~ 0
ad.[n+5]
Text HLabel 3250 3000 0    60   Input ~ 0
armm.[n+0]
$EndSCHEMATC
