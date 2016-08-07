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
$Descr D 34000 22000
encoding utf-8
Sheet 1 1
Title "Data Path"
Date "10/21/1976"
Rev "A"
Comp "Digitized Equipment Corporation"
Comment1 "AR Register"
Comment2 "m8512-0-dp01"
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MC10164 U1
U 1 1 57A676FA
P 3900 1850
F 0 "U1" H 3920 2600 60  0000 C CNN
F 1 "MC10164" H 3940 1100 60  0000 C CNN
F 2 "" H 3900 1850 60  0000 C CNN
F 3 "" H 3900 1850 60  0000 C CNN
	1    3900 1850
	1    0    0    -1  
$EndComp
Text GLabel 3250 1250 0    60   Input ~ 0
armm.[n+0].h
Text GLabel 3250 1350 0    60   Input ~ 0
cache.data.[n+0].b.h
Text GLabel 3250 1450 0    60   Input ~ 0
ad.[n+0].h
Text GLabel 3250 1550 0    60   Input ~ 0
ebus.d[n+0].e.h
Text GLabel 3250 1650 0    60   Input ~ 0
sh.[n+0].h
Text GLabel 3250 1750 0    60   Input ~ 0
ad.[n+1].h
Text GLabel 3250 1850 0    60   Input ~ 0
adx.[n+0].h
Text GLabel 3250 1950 0    60   Input ~ 0
[n/6+1,ad.ex.-02.h,ad.04.h,ad.10.h,ad.16.h,ad.22.h,ad.28.h]
$Comp
L MC10101 U?
U 1 1 57A759E5
P 1750 2950
F 0 "U?" H 1770 3200 60  0000 C CNN
F 1 "MC10101" H 1790 2700 60  0000 C CNN
F 2 "" H 1750 2950 60  0000 C CNN
F 3 "" H 1750 2950 60  0000 C CNN
	1    1750 2950
	1    0    0    -1  
$EndComp
$Comp
L MC10101 U?
U 2 1 57A759FE
P 1700 3700
F 0 "U?" H 1720 3950 60  0000 C CNN
F 1 "MC10101" H 1740 3450 60  0000 C CNN
F 2 "" H 1700 3700 60  0000 C CNN
F 3 "" H 1700 3700 60  0000 C CNN
	2    1700 3700
	1    0    0    -1  
$EndComp
$Comp
L MC10101 U?
U 4 1 57A75A28
P 1700 4350
F 0 "U?" H 1720 4600 60  0000 C CNN
F 1 "MC10101" H 1740 4100 60  0000 C CNN
F 2 "" H 1700 4350 60  0000 C CNN
F 3 "" H 1700 4350 60  0000 C CNN
	4    1700 4350
	1    0    0    -1  
$EndComp
$Comp
L MC10101 U?
U 3 1 57A77FE1
P 1700 4950
F 0 "U?" H 1720 5200 60  0000 C CNN
F 1 "MC10101" H 1740 4700 60  0000 C CNN
F 2 "" H 1700 4950 60  0000 C CNN
F 3 "" H 1700 4950 60  0000 C CNN
	3    1700 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 1250 3250 1250
Wire Wire Line
	3250 1350 3300 1350
Wire Wire Line
	3250 1450 3300 1450
Wire Wire Line
	3250 1550 3300 1550
Wire Wire Line
	3250 1650 3300 1650
Wire Wire Line
	3250 1750 3300 1750
Wire Wire Line
	3250 1850 3300 1850
Wire Wire Line
	3250 1950 3300 1950
Wire Wire Line
	3300 5050 3300 2450
Wire Wire Line
	3300 5050 2300 5050
Wire Wire Line
	2300 4450 3150 4450
Wire Wire Line
	3150 4450 3150 2150
Wire Wire Line
	3150 2150 3300 2150
Wire Wire Line
	2300 3800 3000 3800
Wire Wire Line
	3000 3800 3000 2250
Wire Wire Line
	3000 2250 3300 2250
Wire Wire Line
	2350 3050 2850 3050
Wire Wire Line
	2850 3050 2850 2350
Wire Wire Line
	2850 2350 3300 2350
$EndSCHEMATC
