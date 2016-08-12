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
Sheet 4 4
Title "DATA PATH AD & ADX Adders"
Date "10/21/1976"
Rev "A"
Comp "Digitized Equipment Corporation"
Comment1 "M8512-0-DP03"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MC10181 U?
U 1 1 57ACC3A9
P 4250 2600
F 0 "e1" H 4250 3550 60  0000 C CNN
F 1 "MC10181" H 4250 1650 60  0000 C CNN
F 2 "" H 4250 2600 60  0001 C CNN
F 3 "" H 4250 2600 60  0001 C CNN
	1    4250 2600
	1    0    0    -1  
$EndComp
Text HLabel 1300 3150 0    60   Output ~ 0
ad-ex
Text Label 1300 2850 2    60   ~ 0
ad-ex.1
Text Label 1300 2950 2    60   ~ 0
ad-ex.2
Entry Wire Line
	1300 2850 1400 2950
Entry Wire Line
	1300 2950 1400 3050
Wire Bus Line
	1400 2950 1400 3150
Wire Bus Line
	1400 3150 1300 3150
Text Label 800  2450 2    60   ~ 0
ad.0
Text Label 800  2550 2    60   ~ 0
ad.1
Text Label 800  2650 2    60   ~ 0
ad.2
Text Label 800  2750 2    60   ~ 0
ad.3
Text Label 800  2850 2    60   ~ 0
ad.4
Text Label 800  2950 2    60   ~ 0
ad.5
Entry Wire Line
	800  2450 900  2550
Entry Wire Line
	800  2550 900  2650
Entry Wire Line
	800  2650 900  2750
Entry Wire Line
	800  2750 900  2850
Entry Wire Line
	800  2850 900  2950
Entry Wire Line
	800  2950 900  3050
Text HLabel 800  3150 0    60   Output ~ 0
ad
Wire Bus Line
	900  2550 900  3150
Wire Bus Line
	900  3150 800  3150
Text Label 1650 600  2    60   ~ 0
ar.0
Text Label 1650 700  2    60   ~ 0
ar.1
Text Label 1650 800  2    60   ~ 0
ar.2
Text Label 1650 900  2    60   ~ 0
ar.3
Text Label 1650 1000 2    60   ~ 0
ar.4
Text Label 1650 1100 2    60   ~ 0
ar.5
Entry Wire Line
	1650 600  1750 700 
Entry Wire Line
	1650 700  1750 800 
Entry Wire Line
	1650 800  1750 900 
Entry Wire Line
	1650 900  1750 1000
Entry Wire Line
	1650 1000 1750 1100
Entry Wire Line
	1650 1100 1750 1200
Wire Bus Line
	1750 700  1750 1300
Wire Bus Line
	1750 1300 1650 1300
Text HLabel 1650 1300 0    60   Input ~ 0
ar
Text Label 900  3650 2    60   ~ 0
br.0
Text Label 900  3750 2    60   ~ 0
br.1
Text Label 900  3850 2    60   ~ 0
br.2
Text Label 900  3950 2    60   ~ 0
br.3
Text Label 900  4050 2    60   ~ 0
br.4
Text Label 900  4150 2    60   ~ 0
br.5
Entry Wire Line
	900  3650 1000 3750
Entry Wire Line
	900  3750 1000 3850
Entry Wire Line
	900  3850 1000 3950
Entry Wire Line
	900  3950 1000 4050
Entry Wire Line
	900  4050 1000 4150
Entry Wire Line
	900  4150 1000 4250
Wire Bus Line
	1000 3750 1000 4350
Wire Bus Line
	1000 4350 900  4350
Text HLabel 900  4350 0    60   Input ~ 0
br
Text Label 750  1500 2    60   ~ 0
arx.0
Text Label 750  1600 2    60   ~ 0
arx.1
Text Label 750  1700 2    60   ~ 0
arx.2
Text Label 750  1800 2    60   ~ 0
arx.3
Text Label 750  1900 2    60   ~ 0
arx.4
Text Label 750  2000 2    60   ~ 0
arx.5
Entry Wire Line
	750  1500 850  1600
Entry Wire Line
	750  1600 850  1700
Entry Wire Line
	750  1700 850  1800
Entry Wire Line
	750  1800 850  1900
Entry Wire Line
	750  1900 850  2000
Entry Wire Line
	750  2000 850  2100
Wire Bus Line
	850  1600 850  2200
Wire Bus Line
	850  2200 750  2200
Text HLabel 750  2200 0    60   Input ~ 0
arx
Text Label 1350 3650 2    60   ~ 0
mq.0
Text Label 1350 3750 2    60   ~ 0
mq.1
Text Label 1350 3850 2    60   ~ 0
mq.2
Text Label 1350 3950 2    60   ~ 0
mq.3
Text Label 1350 4050 2    60   ~ 0
mq.4
Text Label 1350 4150 2    60   ~ 0
mq.5
Entry Wire Line
	1350 3650 1450 3750
Entry Wire Line
	1350 3750 1450 3850
Entry Wire Line
	1350 3850 1450 3950
Entry Wire Line
	1350 3950 1450 4050
Entry Wire Line
	1350 4050 1450 4150
Entry Wire Line
	1350 4150 1450 4250
Wire Bus Line
	1450 3750 1450 4350
Wire Bus Line
	1450 4350 1350 4350
Text HLabel 1350 4350 0    60   Input ~ 0
mq
Text Label 2350 2450 2    60   ~ 0
vma-held-or-pc.0
Text Label 2350 2550 2    60   ~ 0
vma-held-or-pc.1
Text Label 2350 2650 2    60   ~ 0
vma-held-or-pc.2
Text Label 2350 2750 2    60   ~ 0
vma-held-or-pc.3
Text Label 2350 2850 2    60   ~ 0
vma-held-or-pc.4
Text Label 2350 2950 2    60   ~ 0
vma-held-or-pc.5
Entry Wire Line
	2350 2450 2450 2550
Entry Wire Line
	2350 2550 2450 2650
Entry Wire Line
	2350 2650 2450 2750
Entry Wire Line
	2350 2750 2450 2850
Entry Wire Line
	2350 2850 2450 2950
Entry Wire Line
	2350 2950 2450 3050
Wire Bus Line
	2450 2550 2450 3150
Wire Bus Line
	2450 3150 2350 3150
Text HLabel 2350 3150 0    60   Input ~ 0
vma-held-or-pc
Text Label 1250 1500 2    60   ~ 0
brx.0
Text Label 1250 1600 2    60   ~ 0
brx.1
Text Label 1250 1700 2    60   ~ 0
brx.2
Text Label 1250 1800 2    60   ~ 0
brx.3
Text Label 1250 1900 2    60   ~ 0
brx.4
Text Label 1250 2000 2    60   ~ 0
brx.5
Entry Wire Line
	1250 1500 1350 1600
Entry Wire Line
	1250 1600 1350 1700
Entry Wire Line
	1250 1700 1350 1800
Entry Wire Line
	1250 1800 1350 1900
Entry Wire Line
	1250 1900 1350 2000
Entry Wire Line
	1250 2000 1350 2100
Wire Bus Line
	1350 1600 1350 2200
Wire Bus Line
	1350 2200 1250 2200
Text HLabel 1250 2200 0    60   Input ~ 0
brx
Text Label 1800 3650 2    60   ~ 0
fm.0
Text Label 1800 3750 2    60   ~ 0
fm.1
Text Label 1800 3850 2    60   ~ 0
fm.2
Text Label 1800 3950 2    60   ~ 0
fm.3
Text Label 1800 4050 2    60   ~ 0
fm.4
Text Label 1800 4150 2    60   ~ 0
fm.5
Entry Wire Line
	1800 3650 1900 3750
Entry Wire Line
	1800 3750 1900 3850
Entry Wire Line
	1800 3850 1900 3950
Entry Wire Line
	1800 3950 1900 4050
Entry Wire Line
	1800 4050 1900 4150
Entry Wire Line
	1800 4150 1900 4250
Wire Bus Line
	1900 3750 1900 4350
Wire Bus Line
	1900 4350 1800 4350
Text HLabel 1800 4350 0    60   Input ~ 0
fm
Wire Wire Line
	3550 2100 3550 1900
Text Label 3400 1900 2    60   ~ 0
ada.0
Wire Wire Line
	3550 1900 3400 1900
Text Label 3400 2400 2    60   ~ 0
adb.0
Wire Wire Line
	3400 2400 3550 2400
Text Label 3400 2300 2    60   ~ 0
adb.1
Wire Wire Line
	3400 2300 3550 2300
Text Label 3400 1800 2    60   ~ 0
ada.1
Wire Wire Line
	3550 1800 3400 1800
Text Label 3400 2500 2    60   ~ 0
adb.-1
Wire Wire Line
	3400 2500 3550 2500
Text Label 3400 2600 2    60   ~ 0
adb.-2
Wire Wire Line
	3400 2600 3550 2600
Text HLabel 3450 3000 0    60   Input ~ 0
cram-ad-sel-1
Wire Wire Line
	3450 3000 3550 3000
Text HLabel 3450 3100 0    60   Input ~ 0
cram-ad-sel-2
Wire Wire Line
	3450 3100 3550 3100
Wire Wire Line
	3450 3200 3550 3200
Wire Wire Line
	3450 3300 3550 3300
Text HLabel 3450 3300 0    60   Input ~ 0
cram-ad-sel-8
Text HLabel 3450 3200 0    60   Input ~ 0
cram-ad-sel-4
Wire Wire Line
	3450 3400 3550 3400
Text HLabel 3450 3400 0    60   Input ~ 0
cram-ad-boole
Text Label 3400 2800 2    60   ~ 0
ad-cry.2
Wire Wire Line
	3400 2800 3550 2800
Text Label 5050 2800 0    60   ~ 0
ad-cry.-2
Wire Wire Line
	4950 2800 5050 2800
Text Label 5050 2900 0    60   ~ 0
ad-cg.0
Wire Wire Line
	4950 2900 5050 2900
Text Label 5050 3000 0    60   ~ 0
ad-cp.0
Wire Wire Line
	4950 3000 5050 3000
Text Label 5050 1800 0    60   ~ 0
ad-ex.-2
Wire Wire Line
	4950 1800 5050 1800
$EndSCHEMATC
