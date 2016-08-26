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
Text HLabel 3350 2700 0    60   Input ~ 0
ada.[n+0]
Text HLabel 3350 3200 0    60   Input ~ 0
adb.[n+0]
Text HLabel 3350 3100 0    60   Input ~ 0
adb.[n+1]
Text HLabel 3350 2600 0    60   Input ~ 0
ada.[n+1]
Text HLabel 3350 3300 0    60   Input ~ 0
adb.[n+-1]
Text HLabel 3350 3400 0    60   Input ~ 0
adb.[n+-2]
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
Text HLabel 3350 3600 0    60   Input ~ 0
ad-cry.[n+2]
Text HLabel 5000 3500 2    60   Input ~ 0
ad-cry.[n+-2]
Text HLabel 5000 3600 2    60   Input ~ 0
ad-cg.[n+0]
Text HLabel 5000 3700 2    60   Input ~ 0
ad-cp.[n+0]
Text HLabel 5000 2900 2    60   Input ~ 0
ad-ex.[n+-2]
Text HLabel 5000 2800 2    60   Input ~ 0
ad-ex.[n+-1]
Text HLabel 5000 2700 2    60   Input ~ 0
ad.[n+0]
Text HLabel 5000 2600 2    60   Input ~ 0
ad.[n+1]
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
Text HLabel 6000 2700 0    60   Input ~ 0
ada.[n+4]
Text HLabel 6000 3200 0    60   Input ~ 0
adb.[n+4]
Text HLabel 6000 3100 0    60   Input ~ 0
adb.[n+5]
Text HLabel 6000 2600 0    60   Input ~ 0
ada.[n+5]
Text HLabel 6000 3300 0    60   Input ~ 0
adb.[n+3]
Text HLabel 6000 3400 0    60   Input ~ 0
adb.[n+2]
Text HLabel 7650 3500 2    60   Input ~ 0
ad-cry.[n+2]
Text HLabel 7650 3600 2    60   Input ~ 0
ad-cg.[n+2]
Text HLabel 7650 3700 2    60   Input ~ 0
ad-cp.[n+2]
Text HLabel 7650 2900 2    60   Input ~ 0
ad.[n+2]
Text HLabel 7650 2800 2    60   Input ~ 0
ad.[n+3]
Text HLabel 7650 2700 2    60   Input ~ 0
ad.[n+4]
Text HLabel 7650 2600 2    60   Input ~ 0
ad.[n+5]
Text HLabel 6000 2800 0    60   Input ~ 0
ada.[n+3]
Text HLabel 6000 2900 0    60   Input ~ 0
ada.[n+2]
Text HLabel 6100 3600 0    60   Input ~ 0
[n/30+1,ad-cry.[n+6],ad-cry-36]
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
Text HLabel 8700 2700 0    60   Input ~ 0
adxa.[n+1]
Text HLabel 8700 3200 0    60   Input ~ 0
adxb.[n+1]
Text HLabel 8700 3100 0    60   Input ~ 0
adxb.[n+2]
Text HLabel 8700 2600 0    60   Input ~ 0
adxa.[n+2]
Text HLabel 8700 3300 0    60   Input ~ 0
adxb.[n+0]
Text HLabel 10350 3600 2    60   Input ~ 0
ad-cg.[n+0]
Text HLabel 10350 3700 2    60   Input ~ 0
ad-cp.[n+0]
Text HLabel 10350 2800 2    60   Input ~ 0
adx.[n+0]
Text HLabel 10350 2700 2    60   Input ~ 0
adx.[n+1]
Text HLabel 10350 2600 2    60   Input ~ 0
adx.[n+2]
Text HLabel 8700 2800 0    60   Input ~ 0
adxa.[n+0]
Text HLabel 8800 3600 0    60   Input ~ 0
adx-cry.[n+3]
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
Text HLabel 11400 2700 0    60   Input ~ 0
adxa.[n+4]
Text HLabel 11400 3200 0    60   Input ~ 0
adxb.[n+4]
Text HLabel 11400 3100 0    60   Input ~ 0
adxb.[n+5]
Text HLabel 11400 2600 0    60   Input ~ 0
adxa.[n+5]
Text HLabel 11400 3300 0    60   Input ~ 0
adxb.[n+3]
Text HLabel 13050 3600 2    60   Input ~ 0
ad-cg.[n+3]
Text HLabel 13050 3700 2    60   Input ~ 0
ad-cp.[n+3]
Text HLabel 13050 2800 2    60   Input ~ 0
adx.[n+3]
Text HLabel 13050 2700 2    60   Input ~ 0
adx.[n+4]
Text HLabel 13050 2600 2    60   Input ~ 0
adx.[n+5]
Text HLabel 11400 2800 0    60   Input ~ 0
adxa.[n+3]
NoConn ~ 12950 2900
Text HLabel 11500 3600 0    60   Input ~ 0
[n/30+1,adx-cry.[n+6],ctl-adx-cry-36]
Text HLabel 13050 3500 2    60   Input ~ 0
adx-cry.[n+3]
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
Text HLabel 2800 700  0    60   Input ~ 0
ad-ex.[n+-2]
Text HLabel 2800 900  0    60   Input ~ 0
ad-ex.[n+-1]
Text HLabel 2800 1600 0    60   Input ~ 0
ad.[n+0]
Text HLabel 5400 900  2    60   Output ~ 0
ad-overflow.[n+0]-l
Text HLabel 5400 1600 2    60   Input ~ 0
ad-cry.[n+1]-l
Text HLabel 5400 1800 2    60   Input ~ 0
ad-cry.[n+1]
Text HLabel 4200 1800 0    60   Input ~ 0
ad-cry.[n+-2]
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
Text HLabel 8200 800  0    60   Input ~ 0
ad.[n+0]
Text HLabel 8200 900  0    60   Input ~ 0
ad.[n+1]
Text HLabel 8200 1000 0    60   Input ~ 0
ad.[n+2]
NoConn ~ 8100 1500
NoConn ~ 9400 800 
NoConn ~ 8250 700 
NoConn ~ 6950 1400
Text HLabel 6900 1500 0    60   Input ~ 0
ad.[n+3]
Text HLabel 6900 1700 0    60   Input ~ 0
ad.[n+4]
Text HLabel 6900 1800 0    60   Input ~ 0
ad.[n+5]
Text HLabel 9400 1000 2    60   Output ~ 0
ad.[n+0]-[n+5]=0
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
Text HLabel 2450 5050 0    60   Input ~ 0
fm.[n+0]
Text HLabel 2450 5150 0    60   Input ~ 0
br.[n+1]
Text HLabel 2450 5250 0    60   Input ~ 0
br.[n+0]
Text HLabel 2450 5350 0    60   Input ~ 0
ar.[n+2]
Text HLabel 2450 5750 0    60   Input ~ 0
ar.[n+0]
Text HLabel 2650 6150 0    60   Input ~ 0
adb.[n+-2]-sel4
Text HLabel 2650 5950 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 2650 6050 0    60   Input ~ 0
cram-adb-sel2
NoConn ~ 2650 6250
Text HLabel 3850 5050 2    60   Input ~ 0
adb.[n+-2]
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
Text HLabel 4400 5750 0    60   Input ~ 0
ar.[n+1]
Wire Wire Line
	4400 5750 4600 5750
NoConn ~ 4600 6250
Text HLabel 5800 5050 2    60   Input ~ 0
adb.[n+-1]
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
Text HLabel 7200 5000 0    60   Input ~ 0
ar.[n+0]
Text HLabel 7200 5100 0    60   Input ~ 0
arx.[n+0]
Text HLabel 7200 5200 0    60   Input ~ 0
mq.[n+0]
Text HLabel 7200 5300 0    60   Input ~ 0
vma-held-or-pc.[n+0]
Text HLabel 7200 5400 0    60   Input ~ 0
ar.[n+1]
Text HLabel 7200 5500 0    60   Input ~ 0
arx.[n+1]
Text HLabel 7200 5600 0    60   Input ~ 0
mq.[n+1]
Text HLabel 7200 5700 0    60   Input ~ 0
vma-held-or-pc.[n+1]
Text HLabel 7200 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 7200 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 7200 6000 0    60   Input ~ 0
cram-ada-dis.[n+0]
Text HLabel 8400 5000 2    60   Input ~ 0
ada.[n+0]
Text HLabel 8450 5400 2    60   Input ~ 0
ada.[n+1]
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
Text HLabel 9800 5000 0    60   Input ~ 0
ar.[n+2]
Text HLabel 9800 5100 0    60   Input ~ 0
arx.[n+2]
Text HLabel 9800 5200 0    60   Input ~ 0
mq.[n+2]
Text HLabel 9800 5300 0    60   Input ~ 0
vma-held-or-pc.[n+2]
Text HLabel 9800 5400 0    60   Input ~ 0
ar.[n+3]
Text HLabel 9800 5500 0    60   Input ~ 0
arx.[n+3]
Text HLabel 9800 5600 0    60   Input ~ 0
mq.[n+3]
Text HLabel 9800 5700 0    60   Input ~ 0
vma-held-or-pc.[n+3]
Text HLabel 9800 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 9800 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 9800 6000 0    60   Input ~ 0
cram-ada-dis.[n+0]
Text HLabel 11000 5000 2    60   Input ~ 0
ada.[n+2]
Text HLabel 11050 5400 2    60   Input ~ 0
ada.[n+3]
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
Text HLabel 12450 5000 0    60   Input ~ 0
ar.[n+4]
Text HLabel 12450 5100 0    60   Input ~ 0
arx.[n+4]
Text HLabel 12450 5200 0    60   Input ~ 0
mq.[n+4]
Text HLabel 12450 5300 0    60   Input ~ 0
vma-held-or-pc.[n+4]
Text HLabel 12450 5400 0    60   Input ~ 0
ar.[n+5]
Text HLabel 12450 5500 0    60   Input ~ 0
arx.[n+5]
Text HLabel 12450 5600 0    60   Input ~ 0
mq.[n+5]
Text HLabel 12450 5700 0    60   Input ~ 0
vma-held-or-pc.[n+5]
Text HLabel 12450 5800 0    60   Input ~ 0
cram-ada-sel1
Text HLabel 12450 5900 0    60   Input ~ 0
cram-ada-sel2
Text HLabel 12450 6000 0    60   Input ~ 0
cram-ada-dis.[n+0]
Text HLabel 13650 5000 2    60   Input ~ 0
ada.[n+4]
Text HLabel 13700 5400 2    60   Input ~ 0
ada.[n+5]
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
Text HLabel 14450 2950 0    60   Input ~ 0
arx.[n+0]
Text HLabel 14450 3150 0    60   Input ~ 0
arx.[n+1]
Text HLabel 14450 3350 0    60   Input ~ 0
arx.[n+2]
Text HLabel 14450 3550 0    60   Input ~ 0
cram-ad-boole
Text HLabel 15650 2850 2    60   Input ~ 0
adxa.[n+0]
Text HLabel 15650 3050 2    60   Input ~ 0
adxa.[n+1]
Text HLabel 15650 3250 2    60   Input ~ 0
adxa.[n+2]
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
Text HLabel 14450 1350 0    60   Input ~ 0
arx.[n+3]
Text HLabel 14450 1550 0    60   Input ~ 0
arx.[n+4]
Text HLabel 14450 1750 0    60   Input ~ 0
arx.[n+5]
Text HLabel 14450 1950 0    60   Input ~ 0
cram-ad-boole
Text HLabel 15650 1250 2    60   Input ~ 0
adxa.[n+3]
Text HLabel 15650 1450 2    60   Input ~ 0
adxa.[n+4]
Text HLabel 15650 1650 2    60   Input ~ 0
adxa.[n+5]
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
[(n+199)/100,HI,NC]
Text HLabel 4600 5950 0    60   Input ~ 0
cram-adb-sel1
Text HLabel 4600 6050 0    60   Input ~ 0
cram-adb-sel2
Text HLabel 1800 7050 0    60   Input ~ 0
fm.[n+0]
Text HLabel 1800 7150 0    60   Input ~ 0
br.[n+1]
Text HLabel 1800 7250 0    60   Input ~ 0
br.[n+0]
Text HLabel 1800 7350 0    60   Input ~ 0
ar.[n+2]
Text HLabel 1800 7450 0    60   Input ~ 0
fm.[n+1]
Text HLabel 1800 7550 0    60   Input ~ 0
br.[n+2]
Text HLabel 1800 7650 0    60   Input ~ 0
br.[n+1]
Text HLabel 1800 7750 0    60   Input ~ 0
ar.[n+3]
Text HLabel 3000 7050 2    60   Input ~ 0
adb.[n+0]
Text HLabel 3000 7450 2    60   Input ~ 0
adb.[n+1]
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
Text HLabel 4200 7050 0    60   Input ~ 0
fm.[n+2]
Text HLabel 4200 7150 0    60   Input ~ 0
br.[n+3]
Text HLabel 4200 7250 0    60   Input ~ 0
br.[n+2]
Text HLabel 4200 7350 0    60   Input ~ 0
ar.[n+4]
Text HLabel 4200 7450 0    60   Input ~ 0
fm.[n+3]
Text HLabel 4200 7550 0    60   Input ~ 0
br.[n+4]
Text HLabel 4200 7650 0    60   Input ~ 0
br.[n+3]
Text HLabel 4200 7750 0    60   Input ~ 0
ar.[n+5]
Text HLabel 5400 7050 2    60   Input ~ 0
adb.[n+2]
Text HLabel 5400 7450 2    60   Input ~ 0
adb.[n+3]
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
Text HLabel 6700 7050 0    60   Input ~ 0
fm.[n+4]
Text HLabel 6700 7150 0    60   Input ~ 0
br.[n+5]
Text HLabel 6700 7250 0    60   Input ~ 0
br.[n+4]
Text HLabel 6700 7450 0    60   Input ~ 0
fm.[n+5]
Text HLabel 6700 7650 0    60   Input ~ 0
br.[n+5]
Text HLabel 7900 7050 2    60   Input ~ 0
adb.[n+4]
Text HLabel 7900 7450 2    60   Input ~ 0
adb.[n+5]
Text HLabel 6700 7350 0    60   Input ~ 0
[n/30+1,AR.[n+6],arx.0]
Text HLabel 6700 7550 0    60   Input ~ 0
[n/30+1,br.[n+6],brx.0]
Text HLabel 6700 7750 0    60   Input ~ 0
[n/30+1,ar.[n+7],arx.1]
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
Text HLabel 9050 7050 0    60   Input ~ 0
#.[n+0]
Text HLabel 9050 7150 0    60   Input ~ 0
brx.[n+1]
Text HLabel 9050 7250 0    60   Input ~ 0
brx.[n+0]
Text HLabel 9050 7450 0    60   Input ~ 0
#.[n+1]
Text HLabel 10250 7050 2    60   Input ~ 0
adxb.[n+0]
Text HLabel 10250 7450 2    60   Input ~ 0
adxb.[n+1]
Text HLabel 9050 7350 0    60   Input ~ 0
arx.[n+2]
Text HLabel 9050 7550 0    60   Input ~ 0
brx.[n+2]
Text HLabel 9050 7650 0    60   Input ~ 0
brx.[n+1]
Text HLabel 9050 7750 0    60   Input ~ 0
brx.[n+3]
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
Text HLabel 11450 7050 0    60   Input ~ 0
#.[n+2]
Text HLabel 11450 7150 0    60   Input ~ 0
brx.[n+3]
Text HLabel 11450 7250 0    60   Input ~ 0
brx.[n+2]
Text HLabel 11450 7450 0    60   Input ~ 0
#.[n+3]
Text HLabel 12650 7050 2    60   Input ~ 0
adxb.[n+2]
Text HLabel 12650 7450 2    60   Input ~ 0
adxb.[n+3]
Text HLabel 11450 7350 0    60   Input ~ 0
arx.[n+4]
Text HLabel 11450 7550 0    60   Input ~ 0
brx.[n+4]
Text HLabel 11450 7650 0    60   Input ~ 0
brx.[n+3]
Text HLabel 11450 7750 0    60   Input ~ 0
brx.[n+5]
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
Text HLabel 13900 7050 0    60   Input ~ 0
#.[n+4]
Text HLabel 13900 7150 0    60   Input ~ 0
brx.[n+5]
Text HLabel 13900 7250 0    60   Input ~ 0
brx.[n+4]
Text HLabel 13900 7450 0    60   Input ~ 0
#.[n+5]
Text HLabel 15100 7050 2    60   Input ~ 0
adxb.[n+4]
Text HLabel 15100 7450 2    60   Input ~ 0
adxb.[n+5]
Text HLabel 13900 7350 0    60   Input ~ 0
arx.[n+6]
Text HLabel 13900 7550 0    60   Input ~ 0
brx.[n+6]
Text HLabel 13900 7650 0    60   Input ~ 0
brx.[n+5]
Text HLabel 13900 7750 0    60   Input ~ 0
brx.[n+7]
$EndSCHEMATC
