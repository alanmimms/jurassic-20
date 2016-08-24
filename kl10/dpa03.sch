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
Sheet 5 6
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
L MC10181 e1
U 1 1 57ACC3A9
P 4200 3400
AR Path="/57B68864/57B6BA15/57ACC3A9" Ref="e1"  Part="1" 
AR Path="/57B6D511/57B6BA15/57ACC3A9" Ref="e1"  Part="1" 
F 0 "e1" H 4200 4350 60  0000 C CNN
F 1 "MC10181" H 4200 2450 60  0000 C CNN
F 2 "" H 4200 3400 60  0001 C CNN
F 3 "" H 4200 3400 60  0001 C CNN
	1    4200 3400
	1    0    0    -1  
$EndComp
Text HLabel 2000 2200 0    60   Output ~ 0
ad-ex
Text Label 2000 1900 2    60   ~ 0
ad-ex.-1
Text Label 2000 2000 2    60   ~ 0
ad-ex.-2
Entry Wire Line
	2000 1900 2100 2000
Entry Wire Line
	2000 2000 2100 2100
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
Text HLabel 900  4350 0    60   Input ~ 0
br
Text Label 750  600  2    60   ~ 0
arx.0
Text Label 750  700  2    60   ~ 0
arx.1
Text Label 750  800  2    60   ~ 0
arx.2
Text Label 750  900  2    60   ~ 0
arx.3
Text Label 750  1000 2    60   ~ 0
arx.4
Text Label 750  1100 2    60   ~ 0
arx.5
Entry Wire Line
	750  600  850  700 
Entry Wire Line
	750  700  850  800 
Entry Wire Line
	750  800  850  900 
Entry Wire Line
	750  900  850  1000
Entry Wire Line
	750  1000 850  1100
Entry Wire Line
	750  1100 850  1200
Text HLabel 750  1300 0    60   Input ~ 0
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
Text HLabel 1350 4350 0    60   Input ~ 0
mq
Text Label 2050 2450 2    60   ~ 0
vma-held-or-pc.0
Text Label 2050 2550 2    60   ~ 0
vma-held-or-pc.1
Text Label 2050 2650 2    60   ~ 0
vma-held-or-pc.2
Text Label 2050 2750 2    60   ~ 0
vma-held-or-pc.3
Text Label 2050 2850 2    60   ~ 0
vma-held-or-pc.4
Text Label 2050 2950 2    60   ~ 0
vma-held-or-pc.5
Entry Wire Line
	2050 2450 2150 2550
Entry Wire Line
	2050 2550 2150 2650
Entry Wire Line
	2050 2650 2150 2750
Entry Wire Line
	2050 2750 2150 2850
Entry Wire Line
	2050 2850 2150 2950
Entry Wire Line
	2050 2950 2150 3050
Text HLabel 2050 3150 0    60   Input ~ 0
vma-held-or-pc
Text Label 1250 600  2    60   ~ 0
brx.0
Text Label 1250 700  2    60   ~ 0
brx.1
Text Label 1250 800  2    60   ~ 0
brx.2
Text Label 1250 900  2    60   ~ 0
brx.3
Text Label 1250 1000 2    60   ~ 0
brx.4
Text Label 1250 1100 2    60   ~ 0
brx.5
Entry Wire Line
	1250 600  1350 700 
Entry Wire Line
	1250 700  1350 800 
Entry Wire Line
	1250 800  1350 900 
Entry Wire Line
	1250 900  1350 1000
Entry Wire Line
	1250 1000 1350 1100
Entry Wire Line
	1250 1100 1350 1200
Text HLabel 1250 1300 0    60   Input ~ 0
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
Text HLabel 1800 4350 0    60   Input ~ 0
fm
Text Label 3350 2700 2    60   ~ 0
ada.0
Text Label 3350 3200 2    60   ~ 0
adb.0
Text Label 3350 3100 2    60   ~ 0
adb.1
Text Label 3350 2600 2    60   ~ 0
ada.1
Text Label 3350 3300 2    60   ~ 0
adb.-1
Text Label 3350 3400 2    60   ~ 0
adb.-2
Text HLabel 3400 3800 0    60   Input ~ 0
cram-ad-sel-1
Text HLabel 3400 3900 0    60   Input ~ 0
cram-ad-sel-2
Text HLabel 3400 4100 0    60   Input ~ 0
cram-ad-sel-8
Text HLabel 3400 4000 0    60   Input ~ 0
cram-ad-sel-4
Text HLabel 3400 4200 0    60   Input ~ 0
cram-ad-boole
Text Label 3350 3600 2    60   ~ 0
ad-cry.2
Text Label 5000 3500 0    60   ~ 0
ad-cry.-2
Text Label 5000 3600 0    60   ~ 0
ad-cg.0
Text Label 5000 3700 0    60   ~ 0
ad-cp.0
Text Label 5000 2900 0    60   ~ 0
ad-ex.-2
Text Label 5000 2800 0    60   ~ 0
ad-ex.-1
Text Label 5000 2700 0    60   ~ 0
ad.0
Text Label 5000 2600 0    60   ~ 0
ad.1
$Comp
L MC10181 e2
U 1 1 57B4AC90
P 6850 3400
AR Path="/57B68864/57B6BA15/57B4AC90" Ref="e2"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B4AC90" Ref="e2"  Part="1" 
F 0 "e2" H 6850 4350 60  0000 C CNN
F 1 "MC10181" H 6850 2450 60  0000 C CNN
F 2 "" H 6850 3400 60  0001 C CNN
F 3 "" H 6850 3400 60  0001 C CNN
	1    6850 3400
	1    0    0    -1  
$EndComp
Text Label 6000 2700 2    60   ~ 0
ada.4
Text Label 6000 3200 2    60   ~ 0
adb.4
Text Label 6000 3100 2    60   ~ 0
adb.5
Text Label 6000 2600 2    60   ~ 0
ada.5
Text Label 6000 3300 2    60   ~ 0
adb.3
Text Label 6000 3400 2    60   ~ 0
adb.2
Text Label 7650 3500 0    60   ~ 0
ad-cry.2
Text Label 7650 3600 0    60   ~ 0
ad-cg.2
Text Label 7650 3700 0    60   ~ 0
ad-cp.2
Text Label 7650 2900 0    60   ~ 0
ad.2
Text Label 7650 2800 0    60   ~ 0
ad.3
Text Label 7650 2700 0    60   ~ 0
ad.4
Text Label 7650 2600 0    60   ~ 0
ad.5
Text Label 6000 2800 2    60   ~ 0
ada.3
Text Label 6000 2900 2    60   ~ 0
ada.2
Text HLabel 6100 3600 0    60   Input ~ 0
ad-2-5-cin
$Comp
L MC10181 e3
U 1 1 57B4BAC9
P 9550 3400
AR Path="/57B68864/57B6BA15/57B4BAC9" Ref="e3"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B4BAC9" Ref="e3"  Part="1" 
F 0 "e3" H 9550 4350 60  0000 C CNN
F 1 "MC10181" H 9550 2450 60  0000 C CNN
F 2 "" H 9550 3400 60  0001 C CNN
F 3 "" H 9550 3400 60  0001 C CNN
	1    9550 3400
	1    0    0    -1  
$EndComp
Text Label 8700 2700 2    60   ~ 0
adxa.1
Text Label 8700 3200 2    60   ~ 0
adxb.1
Text Label 8700 3100 2    60   ~ 0
adxb.2
Text Label 8700 2600 2    60   ~ 0
adxa.2
Text Label 8700 3300 2    60   ~ 0
adxb.0
Text Label 10350 3600 0    60   ~ 0
ad-cg.0
Text Label 10350 3700 0    60   ~ 0
ad-cp.0
Text Label 10350 2800 0    60   ~ 0
adx.0
Text Label 10350 2700 0    60   ~ 0
adx.1
Text Label 10350 2600 0    60   ~ 0
adx.2
Text Label 8700 2800 2    60   ~ 0
adxa.0
Text Label 8800 3600 2    60   ~ 0
adx-cry.3
NoConn ~ 10250 3500
NoConn ~ 10250 2900
$Comp
L MC10181 e4
U 1 1 57B4C236
P 12250 3400
AR Path="/57B68864/57B6BA15/57B4C236" Ref="e4"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B4C236" Ref="e4"  Part="1" 
F 0 "e4" H 12250 4350 60  0000 C CNN
F 1 "MC10181" H 12250 2450 60  0000 C CNN
F 2 "" H 12250 3400 60  0001 C CNN
F 3 "" H 12250 3400 60  0001 C CNN
	1    12250 3400
	1    0    0    -1  
$EndComp
Text Label 11400 2700 2    60   ~ 0
adxa.4
Text Label 11400 3200 2    60   ~ 0
adxb.4
Text Label 11400 3100 2    60   ~ 0
adxb.5
Text Label 11400 2600 2    60   ~ 0
adxa.5
Text Label 11400 3300 2    60   ~ 0
adxb.3
Text Label 13050 3600 0    60   ~ 0
ad-cg.3
Text Label 13050 3700 0    60   ~ 0
ad-cp.3
Text Label 13050 2800 0    60   ~ 0
adx.3
Text Label 13050 2700 0    60   ~ 0
adx.4
Text Label 13050 2600 0    60   ~ 0
adx.5
Text Label 11400 2800 2    60   ~ 0
adxa.3
NoConn ~ 12950 2900
Text HLabel 11500 3600 0    60   Input ~ 0
adx-3-5-cin
Text Label 13050 3500 0    60   ~ 0
adx-cry.3
$Comp
L MC10107 e33
U 1 1 57B4D96A
P 3450 800
AR Path="/57B68864/57B6BA15/57B4D96A" Ref="e33"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B4D96A" Ref="e33"  Part="1" 
F 0 "e33" H 3470 1050 60  0000 C CNN
F 1 "MC10107" H 3490 550 60  0000 C CNN
F 2 "" H 3450 800 60  0001 C CNN
F 3 "" H 3450 800 60  0001 C CNN
	1    3450 800 
	1    0    0    -1  
$EndComp
$Comp
L MC10105 e29
U 3 1 57B4D989
P 4800 1000
AR Path="/57B68864/57B6BA15/57B4D989" Ref="e29"  Part="3" 
AR Path="/57B6D511/57B6BA15/57B4D989" Ref="e29"  Part="3" 
F 0 "e29" H 4820 1250 60  0000 C CNN
F 1 "MC10105" H 4840 750 60  0000 C CNN
F 2 "" H 4800 1000 60  0001 C CNN
F 3 "" H 4800 1000 60  0001 C CNN
	3    4800 1000
	1    0    0    -1  
$EndComp
$Comp
L MC10107 e33
U 2 1 57B4D9BA
P 3450 1500
AR Path="/57B68864/57B6BA15/57B4D9BA" Ref="e33"  Part="2" 
AR Path="/57B6D511/57B6BA15/57B4D9BA" Ref="e33"  Part="2" 
F 0 "e33" H 3470 1750 60  0000 C CNN
F 1 "MC10107" H 3490 1250 60  0000 C CNN
F 2 "" H 3450 1500 60  0001 C CNN
F 3 "" H 3450 1500 60  0001 C CNN
	2    3450 1500
	1    0    0    -1  
$EndComp
$Comp
L MC10107 e33
U 3 1 57B4DC20
P 4800 1700
AR Path="/57B68864/57B6BA15/57B4DC20" Ref="e33"  Part="3" 
AR Path="/57B6D511/57B6BA15/57B4DC20" Ref="e33"  Part="3" 
F 0 "e33" H 4820 1950 60  0000 C CNN
F 1 "MC10107" H 4840 1450 60  0000 C CNN
F 2 "" H 4800 1700 60  0001 C CNN
F 3 "" H 4800 1700 60  0001 C CNN
	3    4800 1700
	1    0    0    -1  
$EndComp
NoConn ~ 4050 1400
NoConn ~ 4050 700 
NoConn ~ 5400 1100
Text Label 2800 700  2    60   ~ 0
ad-ex.-2
Text Label 2800 900  2    60   ~ 0
ad-ex.-1
Text Label 2800 1600 2    60   ~ 0
ad.0
Text HLabel 5400 900  2    60   Output ~ 0
ad-overflow.0-l
Text Label 5400 1600 0    60   ~ 0
ad-cry.1-l
Text Label 5400 1800 0    60   ~ 0
ad-cry.1
Text Label 4200 1800 2    60   ~ 0
ad-cry.-2
$Comp
L MC10109 e7
U 2 1 57B515E0
P 8850 900
AR Path="/57B515E0" Ref="e7"  Part="2" 
AR Path="/57ACBE4E/57B515E0" Ref="e7"  Part="2" 
AR Path="/57B68864/57B6BA15/57B515E0" Ref="e7"  Part="2" 
AR Path="/57B6D511/57B6BA15/57B515E0" Ref="e7"  Part="2" 
F 0 "e7" H 8870 1150 60  0000 C CNN
F 1 "MC10109" H 8890 650 60  0000 C CNN
F 2 "" H 8850 900 60  0001 C CNN
F 3 "" H 8850 900 60  0001 C CNN
	2    8850 900 
	1    0    0    -1  
$EndComp
$Comp
L MC10109 e7
U 1 1 57B51998
P 7550 1600
AR Path="/57B51998" Ref="e7"  Part="1" 
AR Path="/57ACBE4E/57B51998" Ref="e7"  Part="1" 
AR Path="/57B68864/57B6BA15/57B51998" Ref="e7"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B51998" Ref="e7"  Part="1" 
F 0 "e7" H 7570 1850 60  0000 C CNN
F 1 "MC10109" H 7590 1350 60  0000 C CNN
F 2 "" H 7550 1600 60  0001 C CNN
F 3 "" H 7550 1600 60  0001 C CNN
	1    7550 1600
	1    0    0    -1  
$EndComp
Text Label 8200 800  2    60   ~ 0
ad.0
Text Label 8200 900  2    60   ~ 0
ad.1
Text Label 8200 1000 2    60   ~ 0
ad.2
NoConn ~ 8100 1500
NoConn ~ 9400 800 
NoConn ~ 8250 700 
NoConn ~ 6950 1400
Text Label 6900 1500 2    60   ~ 0
ad.3
Text Label 6900 1700 2    60   ~ 0
ad.4
Text Label 6900 1800 2    60   ~ 0
ad.5
Text HLabel 9400 1000 2    60   Output ~ 0
ad.0-5=0
$Comp
L MC10164 e22
U 1 1 57B53A7D
P 3250 5650
AR Path="/57B68864/57B6BA15/57B53A7D" Ref="e22"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B53A7D" Ref="e22"  Part="1" 
F 0 "e22" H 3270 6400 60  0000 C CNN
F 1 "MC10164" H 3290 4900 60  0000 C CNN
F 2 "" H 3250 5650 60  0001 C CNN
F 3 "" H 3250 5650 60  0001 C CNN
	1    3250 5650
	1    0    0    -1  
$EndComp
Text Label 2450 5050 2    60   ~ 0
fm.0
Text Label 2450 5150 2    60   ~ 0
br.1
Text Label 2450 5250 2    60   ~ 0
br.0
Text Label 2450 5350 2    60   ~ 0
ar.2
Text Label 2450 5750 2    60   ~ 0
ar.0
Text HLabel 2650 6150 0    60   Input ~ 0
adb.-2-sel4
Text HLabel 2650 5950 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 2650 6050 0    60   Input ~ 0
cram-adb-sel2
NoConn ~ 2650 6250
Text Label 3850 5050 0    60   ~ 0
adb.-2
$Comp
L MC10164 e21
U 1 1 57B54C8B
P 5200 5650
AR Path="/57B68864/57B6BA15/57B54C8B" Ref="e21"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B54C8B" Ref="e21"  Part="1" 
F 0 "e21" H 5220 6400 60  0000 C CNN
F 1 "MC10164" H 5240 4900 60  0000 C CNN
F 2 "" H 5200 5650 60  0001 C CNN
F 3 "" H 5200 5650 60  0001 C CNN
	1    5200 5650
	1    0    0    -1  
$EndComp
Wire Bus Line
	2100 2000 2100 2200
Wire Bus Line
	2100 2200 2000 2200
Wire Bus Line
	900  2550 900  3150
Wire Bus Line
	900  3150 800  3150
Wire Bus Line
	1750 700  1750 1300
Wire Bus Line
	1750 1300 1650 1300
Wire Bus Line
	1000 3750 1000 4350
Wire Bus Line
	1000 4350 900  4350
Wire Bus Line
	850  700  850  1300
Wire Bus Line
	850  1300 750  1300
Wire Bus Line
	1450 3750 1450 4350
Wire Bus Line
	1450 4350 1350 4350
Wire Bus Line
	2150 2550 2150 3150
Wire Bus Line
	2150 3150 2050 3150
Wire Bus Line
	1350 700  1350 1300
Wire Bus Line
	1350 1300 1250 1300
Wire Bus Line
	1900 3750 1900 4350
Wire Bus Line
	1900 4350 1800 4350
Wire Wire Line
	3500 2900 3500 2700
Wire Wire Line
	3500 2700 3350 2700
Wire Wire Line
	3350 3200 3500 3200
Wire Wire Line
	3350 3100 3500 3100
Wire Wire Line
	3500 2600 3350 2600
Wire Wire Line
	3350 3300 3500 3300
Wire Wire Line
	3350 3400 3500 3400
Wire Wire Line
	3400 3800 3500 3800
Wire Wire Line
	3400 3900 3500 3900
Wire Wire Line
	3400 4000 3500 4000
Wire Wire Line
	3400 4100 3500 4100
Wire Wire Line
	3400 4200 3500 4200
Wire Wire Line
	3350 3600 3500 3600
Wire Wire Line
	4900 3600 5000 3600
Wire Wire Line
	4900 3700 5000 3700
Wire Wire Line
	4900 2900 5000 2900
Wire Wire Line
	4900 2800 5000 2800
Wire Wire Line
	4900 2700 5000 2700
Wire Wire Line
	4900 2600 5000 2600
Wire Wire Line
	6150 2700 6000 2700
Wire Wire Line
	6000 3200 6150 3200
Wire Wire Line
	6000 3100 6150 3100
Wire Wire Line
	6150 2600 6000 2600
Wire Wire Line
	6000 3300 6150 3300
Wire Wire Line
	6000 3400 6150 3400
Wire Wire Line
	6100 3600 6150 3600
Wire Wire Line
	7550 3500 7650 3500
Wire Wire Line
	7550 3600 7650 3600
Wire Wire Line
	7550 3700 7650 3700
Wire Wire Line
	7550 2900 7650 2900
Wire Wire Line
	7550 2800 7650 2800
Wire Wire Line
	7550 2700 7650 2700
Wire Wire Line
	7550 2600 7650 2600
Wire Wire Line
	4900 3500 5000 3500
Wire Wire Line
	6150 2800 6000 2800
Wire Wire Line
	6150 2900 6000 2900
Wire Wire Line
	8850 2700 8700 2700
Wire Wire Line
	8700 3200 8850 3200
Wire Wire Line
	8700 3100 8850 3100
Wire Wire Line
	8850 2600 8700 2600
Wire Wire Line
	8700 3300 8850 3300
Wire Wire Line
	8800 3600 8850 3600
Wire Wire Line
	10250 3600 10350 3600
Wire Wire Line
	10250 3700 10350 3700
Wire Wire Line
	10250 2800 10350 2800
Wire Wire Line
	10250 2700 10350 2700
Wire Wire Line
	10250 2600 10350 2600
Wire Wire Line
	8850 2800 8700 2800
Wire Wire Line
	8850 2900 8850 2800
Wire Wire Line
	8850 3300 8850 3400
Wire Wire Line
	11550 2700 11400 2700
Wire Wire Line
	11400 3200 11550 3200
Wire Wire Line
	11400 3100 11550 3100
Wire Wire Line
	11550 2600 11400 2600
Wire Wire Line
	11400 3300 11550 3300
Wire Wire Line
	11500 3600 11550 3600
Wire Wire Line
	12950 3600 13050 3600
Wire Wire Line
	12950 3700 13050 3700
Wire Wire Line
	12950 2800 13050 2800
Wire Wire Line
	12950 2700 13050 2700
Wire Wire Line
	12950 2600 13050 2600
Wire Wire Line
	11550 2800 11400 2800
Wire Wire Line
	11550 2900 11550 2800
Wire Wire Line
	11550 3300 11550 3400
Wire Wire Line
	12950 3500 13050 3500
Wire Wire Line
	2850 900  2850 1400
Wire Wire Line
	4200 1100 4200 1100
Wire Wire Line
	4050 1600 4200 1600
Wire Wire Line
	4200 1600 4200 1100
Wire Wire Line
	4050 900  4200 900 
Wire Wire Line
	2800 1600 2850 1600
Wire Wire Line
	2800 700  2850 700 
Wire Wire Line
	2800 900  2850 900 
Wire Wire Line
	8200 800  8250 800 
Wire Wire Line
	8200 900  8250 900 
Wire Wire Line
	8200 1000 8250 1000
Wire Wire Line
	8100 1700 8250 1700
Wire Wire Line
	8250 1700 8250 1100
Wire Wire Line
	6900 1500 6950 1500
Wire Wire Line
	6900 1700 6950 1700
Wire Wire Line
	6900 1800 6950 1800
Wire Wire Line
	2450 5050 2650 5050
Wire Wire Line
	2450 5150 2650 5150
Wire Wire Line
	2450 5250 2650 5250
Wire Wire Line
	2450 5350 2650 5350
Wire Wire Line
	2500 5050 2500 5450
Wire Wire Line
	2500 5450 2650 5450
Connection ~ 2500 5050
Wire Wire Line
	2600 4700 2600 5650
Wire Wire Line
	2600 5550 2650 5550
Connection ~ 2600 5250
Wire Wire Line
	2600 5650 2650 5650
Connection ~ 2600 5550
Wire Wire Line
	2450 5750 2650 5750
Wire Wire Line
	2700 4600 2700 5050
Wire Wire Line
	2700 4600 4600 4600
Wire Wire Line
	4600 4600 4600 5450
Wire Wire Line
	2650 5150 2650 4650
Wire Wire Line
	2650 4650 4550 4650
Wire Wire Line
	4550 4650 4550 5150
Wire Wire Line
	4550 5150 4600 5150
Wire Wire Line
	2600 4700 4500 4700
Wire Wire Line
	4500 4700 4500 5650
Wire Wire Line
	4500 5250 4600 5250
Wire Wire Line
	2550 5350 2550 4750
Wire Wire Line
	2550 4750 4450 4750
Wire Wire Line
	4450 4750 4450 5350
Wire Wire Line
	4450 5350 4600 5350
Connection ~ 2550 5350
Connection ~ 4600 5050
Wire Wire Line
	4500 5550 4600 5550
Connection ~ 4500 5250
Wire Wire Line
	4500 5650 4600 5650
Connection ~ 4500 5550
Text Label 4400 5750 2    60   ~ 0
ar.1
Wire Wire Line
	4400 5750 4600 5750
NoConn ~ 4600 6250
Text Label 5800 5050 0    60   ~ 0
adb.-1
$Comp
L MC10174 e14
U 1 1 57B565E8
P 7800 5500
AR Path="/57B68864/57B6BA15/57B565E8" Ref="e14"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B565E8" Ref="e14"  Part="1" 
F 0 "e14" H 7820 6150 60  0000 C CNN
F 1 "MC10174" H 7840 4850 60  0000 C CNN
F 2 "" H 7800 5500 60  0001 C CNN
F 3 "" H 7800 5500 60  0001 C CNN
	1    7800 5500
	1    0    0    -1  
$EndComp
Text Label 7200 5000 2    60   ~ 0
ar.0
Text Label 7200 5100 2    60   ~ 0
arx.0
Text Label 7200 5200 2    60   ~ 0
mq.0
Text Label 7200 5300 2    60   ~ 0
vma-held-or-pc.0
Text Label 7200 5400 2    60   ~ 0
ar.1
Text Label 7200 5500 2    60   ~ 0
arx.1
Text Label 7200 5600 2    60   ~ 0
mq.1
Text Label 7200 5700 2    60   ~ 0
vma-held-or-pc.1
Text HLabel 7200 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 7200 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 7200 6000 0    60   Input ~ 0
cram-ada-dis.0
Text Label 8400 5000 0    60   ~ 0
ada.0
Text Label 8450 5400 0    60   ~ 0
ada.1
$Comp
L MC10174 e16
U 1 1 57B574E0
P 10400 5500
AR Path="/57B68864/57B6BA15/57B574E0" Ref="e16"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B574E0" Ref="e16"  Part="1" 
F 0 "e16" H 10420 6150 60  0000 C CNN
F 1 "MC10174" H 10440 4850 60  0000 C CNN
F 2 "" H 10400 5500 60  0001 C CNN
F 3 "" H 10400 5500 60  0001 C CNN
	1    10400 5500
	1    0    0    -1  
$EndComp
Text Label 9800 5000 2    60   ~ 0
ar.2
Text Label 9800 5100 2    60   ~ 0
arx.2
Text Label 9800 5200 2    60   ~ 0
mq.2
Text Label 9800 5300 2    60   ~ 0
vma-held-or-pc.2
Text Label 9800 5400 2    60   ~ 0
ar.3
Text Label 9800 5500 2    60   ~ 0
arx.3
Text Label 9800 5600 2    60   ~ 0
mq.3
Text Label 9800 5700 2    60   ~ 0
vma-held-or-pc.3
Text HLabel 9800 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 9800 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 9800 6000 0    60   Input ~ 0
cram-ada-dis.0
Text Label 11000 5000 0    60   ~ 0
ada.2
Text Label 11050 5400 0    60   ~ 0
ada.3
$Comp
L MC10174 e18
U 1 1 57B57BA7
P 13050 5500
AR Path="/57B68864/57B6BA15/57B57BA7" Ref="e18"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B57BA7" Ref="e18"  Part="1" 
F 0 "e18" H 13070 6150 60  0000 C CNN
F 1 "MC10174" H 13090 4850 60  0000 C CNN
F 2 "" H 13050 5500 60  0001 C CNN
F 3 "" H 13050 5500 60  0001 C CNN
	1    13050 5500
	1    0    0    -1  
$EndComp
Text Label 12450 5000 2    60   ~ 0
ar.4
Text Label 12450 5100 2    60   ~ 0
arx.4
Text Label 12450 5200 2    60   ~ 0
mq.4
Text Label 12450 5300 2    60   ~ 0
vma-held-or-pc.4
Text Label 12450 5400 2    60   ~ 0
ar.5
Text Label 12450 5500 2    60   ~ 0
arx.5
Text Label 12450 5600 2    60   ~ 0
mq.5
Text Label 12450 5700 2    60   ~ 0
vma-held-or-pc.5
Text HLabel 12450 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 12450 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 12450 6000 0    60   Input ~ 0
cram-ada-dis.0
Text Label 13650 5000 0    60   ~ 0
ada.4
Text Label 13700 5400 0    60   ~ 0
ada.5
Text HLabel 6150 3800 0    60   Input ~ 0
cram-ad-sel-1
Text HLabel 6150 3900 0    60   Input ~ 0
cram-ad-sel-2
Text HLabel 6150 4100 0    60   Input ~ 0
cram-ad-sel-8
Text HLabel 6150 4000 0    60   Input ~ 0
cram-ad-sel-4
Text HLabel 6150 4200 0    60   Input ~ 0
cram-ad-boole
Text HLabel 8850 3800 0    60   Input ~ 0
cram-ad-sel-1
Text HLabel 8850 3900 0    60   Input ~ 0
cram-ad-sel-2
Text HLabel 8850 4100 0    60   Input ~ 0
cram-ad-sel-8
Text HLabel 8850 4000 0    60   Input ~ 0
cram-ad-sel-4
Text HLabel 8850 4200 0    60   Input ~ 0
cram-ad-boole
Text HLabel 11550 3800 0    60   Input ~ 0
cram-ad-sel-1
Text HLabel 11550 3900 0    60   Input ~ 0
cram-ad-sel-2
Text HLabel 11550 4100 0    60   Input ~ 0
cram-ad-sel-8
Text HLabel 11550 4000 0    60   Input ~ 0
cram-ad-sel-4
Text HLabel 11550 4200 0    60   Input ~ 0
cram-ad-boole
$Comp
L MC10158 e17
U 1 1 57B58502
P 15050 3100
AR Path="/57B68864/57B6BA15/57B58502" Ref="e17"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B58502" Ref="e17"  Part="1" 
F 0 "e17" H 15050 3700 60  0000 C CNN
F 1 "MC10158" H 15090 2500 60  0000 C CNN
F 2 "" H 15050 3100 60  0001 C CNN
F 3 "" H 15050 3100 60  0001 C CNN
	1    15050 3100
	1    0    0    -1  
$EndComp
NoConn ~ 14450 2650
NoConn ~ 14450 2750
NoConn ~ 15650 2650
NoConn ~ 14450 2850
NoConn ~ 14450 3050
NoConn ~ 14450 3250
Text Label 14450 2950 2    60   ~ 0
arx.0
Text Label 14450 3150 2    60   ~ 0
arx.1
Text Label 14450 3350 2    60   ~ 0
arx.2
Text HLabel 14450 3550 0    60   Input ~ 0
cram-ad-boole
Text Label 15650 2850 0    60   ~ 0
adxa.0
Text Label 15650 3050 0    60   ~ 0
adxa.1
Text Label 15650 3250 0    60   ~ 0
adxa.2
$Comp
L MC10158 e5
U 1 1 57B590AD
P 15050 1500
AR Path="/57B68864/57B6BA15/57B590AD" Ref="e5"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B590AD" Ref="e5"  Part="1" 
F 0 "e5" H 15050 2100 60  0000 C CNN
F 1 "MC10158" H 15090 900 60  0000 C CNN
F 2 "" H 15050 1500 60  0001 C CNN
F 3 "" H 15050 1500 60  0001 C CNN
	1    15050 1500
	1    0    0    -1  
$EndComp
NoConn ~ 14450 1050
NoConn ~ 14450 1150
NoConn ~ 15650 1050
NoConn ~ 14450 1250
NoConn ~ 14450 1450
NoConn ~ 14450 1650
Text Label 14450 1350 2    60   ~ 0
arx.3
Text Label 14450 1550 2    60   ~ 0
arx.4
Text Label 14450 1750 2    60   ~ 0
arx.5
Text HLabel 14450 1950 0    60   Input ~ 0
cram-ad-boole
Text Label 15650 1250 0    60   ~ 0
adxa.3
Text Label 15650 1450 0    60   ~ 0
adxa.4
Text Label 15650 1650 0    60   ~ 0
adxa.5
$Comp
L MC10174 e23
U 1 1 57B59E83
P 2400 7550
AR Path="/57B68864/57B6BA15/57B59E83" Ref="e23"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B59E83" Ref="e23"  Part="1" 
F 0 "e23" H 2420 8200 60  0000 C CNN
F 1 "MC10174" H 2440 6900 60  0000 C CNN
F 2 "" H 2400 7550 60  0001 C CNN
F 3 "" H 2400 7550 60  0001 C CNN
	1    2400 7550
	1    0    0    -1  
$EndComp
NoConn ~ 1800 8050
Text HLabel 1800 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 1800 7950 0    60   Input ~ 0
cram-adb-sel2
Text HLabel 4600 6150 0    60   Input ~ 0
adb.-2-sel4
Text HLabel 4600 5950 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 4600 6050 0    60   Input ~ 0
cram-adb-sel2
Text Label 1800 7050 2    60   ~ 0
fm.0
Text Label 1800 7150 2    60   ~ 0
br.1
Text Label 1800 7250 2    60   ~ 0
br.0
Text Label 1800 7350 2    60   ~ 0
ar.2
Text Label 1800 7450 2    60   ~ 0
fm.1
Text Label 1800 7550 2    60   ~ 0
br.2
Text Label 1800 7650 2    60   ~ 0
br.1
Text Label 1800 7750 2    60   ~ 0
ar.3
Text Label 3000 7050 0    60   ~ 0
adb.0
Text Label 3000 7450 0    60   ~ 0
adb.1
$Comp
L MC10174 e26
U 1 1 57B5AE9B
P 4800 7550
AR Path="/57B68864/57B6BA15/57B5AE9B" Ref="e26"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B5AE9B" Ref="e26"  Part="1" 
F 0 "e26" H 4820 8200 60  0000 C CNN
F 1 "MC10174" H 4840 6900 60  0000 C CNN
F 2 "" H 4800 7550 60  0001 C CNN
F 3 "" H 4800 7550 60  0001 C CNN
	1    4800 7550
	1    0    0    -1  
$EndComp
NoConn ~ 4200 8050
Text HLabel 4200 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 4200 7950 0    60   Input ~ 0
cram-adb-sel2
Text Label 4200 7050 2    60   ~ 0
fm.2
Text Label 4200 7150 2    60   ~ 0
br.3
Text Label 4200 7250 2    60   ~ 0
br.2
Text Label 4200 7350 2    60   ~ 0
ar.4
Text Label 4200 7450 2    60   ~ 0
fm.3
Text Label 4200 7550 2    60   ~ 0
br.4
Text Label 4200 7650 2    60   ~ 0
br.3
Text Label 4200 7750 2    60   ~ 0
ar.5
Text Label 5400 7050 0    60   ~ 0
adb.2
Text Label 5400 7450 0    60   ~ 0
adb.3
$Comp
L MC10174 e19
U 1 1 57B5B5EA
P 7300 7550
AR Path="/57B68864/57B6BA15/57B5B5EA" Ref="e19"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B5B5EA" Ref="e19"  Part="1" 
F 0 "e19" H 7320 8200 60  0000 C CNN
F 1 "MC10174" H 7340 6900 60  0000 C CNN
F 2 "" H 7300 7550 60  0001 C CNN
F 3 "" H 7300 7550 60  0001 C CNN
	1    7300 7550
	1    0    0    -1  
$EndComp
NoConn ~ 6700 8050
Text HLabel 6700 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 6700 7950 0    60   Input ~ 0
cram-adb-sel2
Text Label 6700 7050 2    60   ~ 0
fm.4
Text Label 6700 7150 2    60   ~ 0
br.5
Text Label 6700 7250 2    60   ~ 0
br.4
Text Label 6700 7450 2    60   ~ 0
fm.5
Text Label 6700 7650 2    60   ~ 0
br.5
Text Label 7900 7050 0    60   ~ 0
adb.4
Text Label 7900 7450 0    60   ~ 0
adb.5
Text HLabel 6700 7350 0    60   Input ~ 0
adb.4-d03
Text HLabel 6700 7550 0    60   Input ~ 0
adb.5-d11
Text HLabel 6700 7750 0    60   Input ~ 0
adb.5-d13
$Comp
L MC10174 e9
U 1 1 57B5C580
P 9650 7550
AR Path="/57B68864/57B6BA15/57B5C580" Ref="e9"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B5C580" Ref="e9"  Part="1" 
F 0 "e9" H 9670 8200 60  0000 C CNN
F 1 "MC10174" H 9690 6900 60  0000 C CNN
F 2 "" H 9650 7550 60  0001 C CNN
F 3 "" H 9650 7550 60  0001 C CNN
	1    9650 7550
	1    0    0    -1  
$EndComp
NoConn ~ 9050 8050
Text HLabel 9050 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 9050 7950 0    60   Input ~ 0
cram-adb-sel2
Text Label 9050 7050 2    60   ~ 0
#.0
Text Label 9050 7150 2    60   ~ 0
brx.1
Text Label 9050 7250 2    60   ~ 0
brx.0
Text Label 9050 7450 2    60   ~ 0
#.1
Text Label 10250 7050 0    60   ~ 0
adxb.0
Text Label 10250 7450 0    60   ~ 0
adxb.1
Text Label 9050 7350 2    60   ~ 0
arx.2
Text Label 9050 7550 2    60   ~ 0
brx.2
Text Label 9050 7650 2    60   ~ 0
brx.1
Text Label 9050 7750 2    60   ~ 0
brx.3
$Comp
L MC10174 e12
U 1 1 57B5CF64
P 12050 7550
AR Path="/57B68864/57B6BA15/57B5CF64" Ref="e12"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B5CF64" Ref="e12"  Part="1" 
F 0 "e12" H 12070 8200 60  0000 C CNN
F 1 "MC10174" H 12090 6900 60  0000 C CNN
F 2 "" H 12050 7550 60  0001 C CNN
F 3 "" H 12050 7550 60  0001 C CNN
	1    12050 7550
	1    0    0    -1  
$EndComp
NoConn ~ 11450 8050
Text HLabel 11450 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 11450 7950 0    60   Input ~ 0
cram-adb-sel2
Text Label 11450 7050 2    60   ~ 0
#.2
Text Label 11450 7150 2    60   ~ 0
brx.3
Text Label 11450 7250 2    60   ~ 0
brx.2
Text Label 11450 7450 2    60   ~ 0
#.3
Text Label 12650 7050 0    60   ~ 0
adxb.2
Text Label 12650 7450 0    60   ~ 0
adxb.3
Text Label 11450 7350 2    60   ~ 0
arx.4
Text Label 11450 7550 2    60   ~ 0
brx.4
Text Label 11450 7650 2    60   ~ 0
brx.3
Text Label 11450 7750 2    60   ~ 0
brx.5
$Comp
L MC10174 e6
U 1 1 57B5D8E4
P 14500 7550
AR Path="/57B68864/57B6BA15/57B5D8E4" Ref="e6"  Part="1" 
AR Path="/57B6D511/57B6BA15/57B5D8E4" Ref="e6"  Part="1" 
F 0 "e6" H 14520 8200 60  0000 C CNN
F 1 "MC10174" H 14540 6900 60  0000 C CNN
F 2 "" H 14500 7550 60  0001 C CNN
F 3 "" H 14500 7550 60  0001 C CNN
	1    14500 7550
	1    0    0    -1  
$EndComp
NoConn ~ 13900 8050
Text HLabel 13900 7850 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 13900 7950 0    60   Input ~ 0
cram-adb-sel2
Text Label 13900 7050 2    60   ~ 0
#.4
Text Label 13900 7150 2    60   ~ 0
brx.5
Text Label 13900 7250 2    60   ~ 0
brx.4
Text Label 13900 7450 2    60   ~ 0
#.5
Text Label 15100 7050 0    60   ~ 0
adxb.4
Text Label 15100 7450 0    60   ~ 0
adxb.5
Text Label 13900 7350 2    60   ~ 0
arx.6
Text Label 13900 7550 2    60   ~ 0
brx.6
Text Label 13900 7650 2    60   ~ 0
brx.5
Text Label 13900 7750 2    60   ~ 0
brx.7
$EndSCHEMATC
