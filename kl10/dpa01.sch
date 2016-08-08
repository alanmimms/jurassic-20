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
Sheet 2 3
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
ar-0-2-sel
Text HLabel 10200 2150 0    60   Input ~ 0
dp04-clk
Text HLabel 10450 7850 0    60   Input ~ 0
ar-3-5-sel
Text HLabel 10450 7500 0    60   Input ~ 0
dp04-clk
Text HLabel 2700 4800 0    60   Input ~ 0
arm-sel-4
Text HLabel 2700 5550 0    60   Input ~ 0
arm-sel-2
Text HLabel 2650 6200 0    60   Input ~ 0
arm-sel-1
Text HLabel 2650 6850 0    60   Input ~ 0
arm-en
Wire Wire Line
	4500 3000 4500 1650
Wire Wire Line
	11700 7850 10450 7850
Wire Wire Line
	9700 8850 9800 8850
Wire Wire Line
	6600 9050 6700 9050
Text Label 12700 1550 0    60   ~ 0
ar.0
Text Label 12700 1650 0    60   ~ 0
ar.0
Text Label 12700 1750 0    60   ~ 0
ar.1
Text Label 12700 1850 0    60   ~ 0
ar.2
Entry Wire Line
	13050 1550 13150 1650
Entry Wire Line
	13050 1650 13150 1750
Entry Wire Line
	13050 1750 13150 1850
Entry Wire Line
	13050 1850 13150 1950
Wire Bus Line
	13150 1650 13150 2200
Text HLabel 13200 2200 2    60   Output ~ 0
ar
Wire Bus Line
	13150 2200 13200 2200
Wire Wire Line
	12900 7000 13200 7000
Wire Wire Line
	12900 7100 13200 7100
Wire Wire Line
	12900 7200 13200 7200
Text Label 13000 7000 0    60   ~ 0
ar.3
Text Label 13000 7100 0    60   ~ 0
ar.4
Text Label 13000 7200 0    60   ~ 0
ar.5
Wire Wire Line
	12650 1550 13050 1550
Wire Wire Line
	12650 1650 13050 1650
Wire Wire Line
	12650 1750 13050 1750
Wire Wire Line
	12650 1850 13050 1850
Entry Wire Line
	13200 7000 13300 7100
Entry Wire Line
	13200 7100 13300 7200
Entry Wire Line
	13200 7200 13300 7300
Text HLabel 13350 7550 2    60   Output ~ 0
ar
Wire Bus Line
	13300 7550 13350 7550
Wire Bus Line
	13300 7100 13300 7550
Text Label 4600 3000 0    60   ~ 0
arm.0
Text Label 7800 3000 0    60   ~ 0
arm.1
Text Label 10900 3000 0    60   ~ 0
arm.2
Text Label 11150 8350 0    60   ~ 0
arm.5
Text Label 8050 8350 0    60   ~ 0
arm.4
Text Label 4850 8350 0    60   ~ 0
arm.3
Entry Wire Line
	1050 950  1150 1050
Entry Wire Line
	1050 1050 1150 1150
Entry Wire Line
	1050 1150 1150 1250
Entry Wire Line
	1050 1250 1150 1350
Entry Wire Line
	1050 1350 1150 1450
Entry Wire Line
	1050 1450 1150 1550
Wire Bus Line
	1150 1050 1150 1800
Text Label 1000 950  2    60   ~ 0
armm.0
Text Label 1000 1050 2    60   ~ 0
armm.1
Text Label 1000 1150 2    60   ~ 0
armm.2
Text Label 1000 1250 2    60   ~ 0
armm.3
Text Label 1000 1350 2    60   ~ 0
armm.4
Text Label 1000 1450 2    60   ~ 0
armm.5
Wire Bus Line
	1150 1800 1050 1800
Wire Wire Line
	1000 950  1050 950 
Wire Wire Line
	1000 1050 1050 1050
Wire Wire Line
	1000 1150 1050 1150
Wire Wire Line
	1000 1250 1050 1250
Wire Wire Line
	1000 1350 1050 1350
Wire Wire Line
	1000 1450 1050 1450
Entry Wire Line
	1800 950  1900 1050
Entry Wire Line
	1800 1050 1900 1150
Entry Wire Line
	1800 1150 1900 1250
Entry Wire Line
	1800 1250 1900 1350
Entry Wire Line
	1800 1350 1900 1450
Entry Wire Line
	1800 1450 1900 1550
Wire Bus Line
	1900 1050 1900 1800
Text Label 1750 950  2    60   ~ 0
ad.0
Text Label 1750 1050 2    60   ~ 0
ad.1
Text Label 1750 1150 2    60   ~ 0
ad.2
Text Label 1750 1250 2    60   ~ 0
ad.3
Text Label 1750 1350 2    60   ~ 0
ad.4
Text Label 1750 1450 2    60   ~ 0
ad.5
Wire Bus Line
	1900 1800 1800 1800
Wire Wire Line
	1750 950  1800 950 
Wire Wire Line
	1750 1050 1800 1050
Wire Wire Line
	1750 1150 1800 1150
Wire Wire Line
	1750 1250 1800 1250
Wire Wire Line
	1750 1350 1800 1350
Wire Wire Line
	1750 1450 1800 1450
Entry Wire Line
	2750 950  2850 1050
Entry Wire Line
	2750 1050 2850 1150
Entry Wire Line
	2750 1150 2850 1250
Entry Wire Line
	2750 1250 2850 1350
Entry Wire Line
	2750 1350 2850 1450
Entry Wire Line
	2750 1450 2850 1550
Wire Bus Line
	2850 1050 2850 1800
Text Label 2700 950  2    60   ~ 0
cache-data.0
Text Label 2700 1050 2    60   ~ 0
cache-data.1
Text Label 2700 1150 2    60   ~ 0
cache-data.2
Text Label 2700 1250 2    60   ~ 0
cache-data.3
Text Label 2700 1350 2    60   ~ 0
cache-data.4
Text Label 2700 1450 2    60   ~ 0
cache-data.5
Wire Bus Line
	2850 1800 2750 1800
Wire Wire Line
	2700 950  2750 950 
Wire Wire Line
	2700 1050 2750 1050
Wire Wire Line
	2700 1150 2750 1150
Wire Wire Line
	2700 1250 2750 1250
Wire Wire Line
	2700 1350 2750 1350
Wire Wire Line
	2700 1450 2750 1450
Entry Wire Line
	1800 2050 1900 2150
Entry Wire Line
	1800 2150 1900 2250
Entry Wire Line
	1800 2250 1900 2350
Entry Wire Line
	1800 2350 1900 2450
Entry Wire Line
	1800 2450 1900 2550
Entry Wire Line
	1800 2550 1900 2650
Wire Bus Line
	1900 2150 1900 2900
Text Label 1750 2050 2    60   ~ 0
sh.0
Text Label 1750 2150 2    60   ~ 0
sh.1
Text Label 1750 2250 2    60   ~ 0
sh.2
Text Label 1750 2350 2    60   ~ 0
sh.3
Text Label 1750 2450 2    60   ~ 0
sh.4
Text Label 1750 2550 2    60   ~ 0
sh.5
Wire Bus Line
	1900 2900 1800 2900
Wire Wire Line
	1750 2050 1800 2050
Wire Wire Line
	1750 2150 1800 2150
Wire Wire Line
	1750 2250 1800 2250
Wire Wire Line
	1750 2350 1800 2350
Wire Wire Line
	1750 2450 1800 2450
Wire Wire Line
	1750 2550 1800 2550
Entry Wire Line
	2750 2050 2850 2150
Entry Wire Line
	2750 2150 2850 2250
Entry Wire Line
	2750 2250 2850 2350
Entry Wire Line
	2750 2350 2850 2450
Entry Wire Line
	2750 2450 2850 2550
Entry Wire Line
	2750 2550 2850 2650
Wire Bus Line
	2850 2150 2850 2900
Text Label 2700 2050 2    60   ~ 0
ebus-d.0
Text Label 2700 2150 2    60   ~ 0
ebus-d.1
Text Label 2700 2250 2    60   ~ 0
ebus-d.2
Text Label 2700 2350 2    60   ~ 0
ebus-d.3
Text Label 2700 2450 2    60   ~ 0
ebus-d.4
Text Label 2700 2550 2    60   ~ 0
ebus-d.5
Wire Bus Line
	2850 2900 2750 2900
Wire Wire Line
	2700 2050 2750 2050
Wire Wire Line
	2700 2150 2750 2150
Wire Wire Line
	2700 2250 2750 2250
Wire Wire Line
	2700 2350 2750 2350
Wire Wire Line
	2700 2450 2750 2450
Wire Wire Line
	2700 2550 2750 2550
Text Label 3250 3000 2    60   ~ 0
armm.0
Text Label 3250 3100 2    60   ~ 0
cache-data.0
Text Label 3250 3200 2    60   ~ 0
ad.0
Text Label 3250 3300 2    60   ~ 0
ebus-d.0
Text Label 3250 3400 2    60   ~ 0
sh.0
Text Label 3250 3500 2    60   ~ 0
ad.1
Text Label 3250 3600 2    60   ~ 0
adx.0
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
Text Label 6350 3000 2    60   ~ 0
armm.1
Text Label 6350 3100 2    60   ~ 0
cache-data.1
Text Label 6350 3200 2    60   ~ 0
ad.1
Text Label 6350 3300 2    60   ~ 0
ebus-d.1
Text Label 6350 3400 2    60   ~ 0
sh.1
Text Label 6350 3500 2    60   ~ 0
ad.2
Text Label 6350 3600 2    60   ~ 0
adx.1
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
Text Label 9500 3000 2    60   ~ 0
armm.2
Text Label 9500 3100 2    60   ~ 0
cache-data.2
Text Label 9500 3200 2    60   ~ 0
ad.2
Text Label 9500 3300 2    60   ~ 0
ebus-d.2
Text Label 9500 3400 2    60   ~ 0
sh.2
Text Label 9500 3500 2    60   ~ 0
ad.3
Text Label 9500 3600 2    60   ~ 0
adx.2
Text Label 9500 3700 2    60   ~ 0
ad.0
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
Text Label 9700 8350 2    60   ~ 0
armm.5
Text Label 9700 8450 2    60   ~ 0
cache-data.5
Text Label 9700 8550 2    60   ~ 0
ad.5
Text Label 9700 8650 2    60   ~ 0
ebus-d.5
Text Label 9700 8750 2    60   ~ 0
sh.5
Text Label 9700 8950 2    60   ~ 0
adx.5
Text Label 9700 9050 2    60   ~ 0
ad.3
Text HLabel 9700 8850 0    60   Input ~ 0
arm.5-x5
Text HLabel 6350 3700 0    60   Input ~ 0
arm.1-x7
Text HLabel 3250 3700 0    60   Input ~ 0
arm.0-x7
Text Label 6600 8350 2    60   ~ 0
armm.4
Text Label 6600 8450 2    60   ~ 0
cache-data.4
Text Label 6600 8550 2    60   ~ 0
ad.4
Text Label 6600 8650 2    60   ~ 0
ebus-d.4
Text Label 6600 8750 2    60   ~ 0
sh.4
Text Label 6600 8950 2    60   ~ 0
adx.4
Text Label 6600 9050 2    60   ~ 0
ad.2
Text HLabel 6600 8850 0    60   Input ~ 0
arm.4-x5
Text Label 2600 8350 2    60   ~ 0
armm.4
Text Label 2600 8450 2    60   ~ 0
cache-data.3
Text Label 2600 8550 2    60   ~ 0
ad.3
Text Label 2600 8650 2    60   ~ 0
ebus-d.3
Text Label 2600 8750 2    60   ~ 0
sh.3
Text Label 2600 8950 2    60   ~ 0
adx.3
Text Label 2600 9050 2    60   ~ 0
ad.1
Text Label 2600 8850 2    60   ~ 0
ad.4
Text HLabel 1050 1800 0    60   Input ~ 0
armm
Text HLabel 1800 1800 0    60   Input ~ 0
ad
Text HLabel 2750 1800 0    60   Input ~ 0
cache-data
Text HLabel 2750 2900 0    60   Input ~ 0
ebus-d
Text HLabel 1800 2900 0    60   Input ~ 0
sh
$EndSCHEMATC
