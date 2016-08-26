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
Sheet 6 6
Title "DATA PATH EBUS, FM, BR, BRX"
Date "10/21/1976"
Rev "A"
Comp "Digitized Equipment Corporation"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MC10101 e59
U 1 1 57B64287
P 2750 3650
AR Path="/57B68864/57B6BA75/57B64287" Ref="e59"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B64287" Ref="e59"  Part="1" 
F 0 "e59" H 2770 3900 60  0000 C CNN
F 1 "MC10101" H 2790 3400 60  0000 C CNN
F 2 "" H 2750 3650 60  0001 C CNN
F 3 "" H 2750 3650 60  0001 C CNN
	1    2750 3650
	1    0    0    -1  
$EndComp
$Comp
L MC10101 e59
U 2 1 57B6430A
P 2750 4350
AR Path="/57B68864/57B6BA75/57B6430A" Ref="e59"  Part="2" 
AR Path="/57B6D511/57B6BA75/57B6430A" Ref="e59"  Part="2" 
F 0 "e59" H 2770 4600 60  0000 C CNN
F 1 "MC10101" H 2790 4100 60  0000 C CNN
F 2 "" H 2750 4350 60  0001 C CNN
F 3 "" H 2750 4350 60  0001 C CNN
	2    2750 4350
	1    0    0    -1  
$EndComp
$Comp
L MC10101 e59
U 3 1 57B64349
P 2750 5050
AR Path="/57B68864/57B6BA75/57B64349" Ref="e59"  Part="3" 
AR Path="/57B6D511/57B6BA75/57B64349" Ref="e59"  Part="3" 
F 0 "e59" H 2770 5300 60  0000 C CNN
F 1 "MC10101" H 2790 4800 60  0000 C CNN
F 2 "" H 2750 5050 60  0001 C CNN
F 3 "" H 2750 5050 60  0001 C CNN
	3    2750 5050
	1    0    0    -1  
$EndComp
$Comp
L MC10101 e59
U 4 1 57B6437D
P 2750 5750
AR Path="/57B68864/57B6BA75/57B6437D" Ref="e59"  Part="4" 
AR Path="/57B6D511/57B6BA75/57B6437D" Ref="e59"  Part="4" 
F 0 "e59" H 2770 6000 60  0000 C CNN
F 1 "MC10101" H 2790 5500 60  0000 C CNN
F 2 "" H 2750 5750 60  0001 C CNN
F 3 "" H 2750 5750 60  0001 C CNN
	4    2750 5750
	1    0    0    -1  
$EndComp
NoConn ~ 3350 5650
NoConn ~ 3350 4250
NoConn ~ 3350 3550
Text HLabel 1900 5850 0    60   Input ~ 0
ebus-driver-mask.[n+0]
Text HLabel 1850 3550 0    60   Input ~ 0
diag.[n+4]
Text HLabel 1850 4250 0    60   Input ~ 0
diag.[n+5]
Text HLabel 1850 4950 0    60   Input ~ 0
diag.[n+6]
Text HLabel 1900 5650 0    60   Input ~ 0
diag-read-func-12x
$Comp
L MC10164 e57
U 1 1 57B65227
P 4500 2450
AR Path="/57B68864/57B6BA75/57B65227" Ref="e57"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B65227" Ref="e57"  Part="1" 
F 0 "e57" H 4520 3200 60  0000 C CNN
F 1 "MC10164" H 4540 1700 60  0000 C CNN
F 2 "" H 4500 2450 60  0001 C CNN
F 3 "" H 4500 2450 60  0001 C CNN
	1    4500 2450
	1    0    0    -1  
$EndComp
Text HLabel 3900 1850 0    60   Input ~ 0
ar.[n+0]
Text HLabel 3900 1950 0    60   Input ~ 0
br.[n+0]
Text HLabel 3900 2050 0    60   Input ~ 0
mq.[n+0]
Text HLabel 3900 2150 0    60   Input ~ 0
fm.[n+0]
Text HLabel 3900 2250 0    60   Input ~ 0
brx.[n+0]
Text HLabel 3900 2350 0    60   Input ~ 0
arx.[n+0]
Text HLabel 3900 2450 0    60   Input ~ 0
adx.[n+0]
Text HLabel 3900 2550 0    60   Input ~ 0
ad.[n+0]
NoConn ~ 3350 5150
Text HLabel 5100 1850 2    60   Input ~ 0
ebus-d.[n+0]
$Comp
L MC10164 e50
U 1 1 57B66733
P 6350 2450
AR Path="/57B68864/57B6BA75/57B66733" Ref="e50"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B66733" Ref="e50"  Part="1" 
F 0 "e50" H 6370 3200 60  0000 C CNN
F 1 "MC10164" H 6390 1700 60  0000 C CNN
F 2 "" H 6350 2450 60  0001 C CNN
F 3 "" H 6350 2450 60  0001 C CNN
	1    6350 2450
	1    0    0    -1  
$EndComp
Text HLabel 5750 1850 0    60   Input ~ 0
ar.[n+1]
Text HLabel 5750 1950 0    60   Input ~ 0
br.[n+1]
Text HLabel 5750 2050 0    60   Input ~ 0
mq.[n+1]
Text HLabel 5750 2150 0    60   Input ~ 0
fm.[n+1]
Text HLabel 5750 2250 0    60   Input ~ 0
brx.[n+1]
Text HLabel 5750 2350 0    60   Input ~ 0
arx.[n+1]
Text HLabel 5750 2450 0    60   Input ~ 0
adx.[n+1]
Text HLabel 5750 2550 0    60   Input ~ 0
ad.[n+1]
Text HLabel 6950 1850 2    60   Input ~ 0
ebus-d.[n+1]
$Comp
L MC10164 e43
U 1 1 57B67599
P 8200 2450
AR Path="/57B68864/57B6BA75/57B67599" Ref="e43"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B67599" Ref="e43"  Part="1" 
F 0 "e43" H 8220 3200 60  0000 C CNN
F 1 "MC10164" H 8240 1700 60  0000 C CNN
F 2 "" H 8200 2450 60  0001 C CNN
F 3 "" H 8200 2450 60  0001 C CNN
	1    8200 2450
	1    0    0    -1  
$EndComp
Text HLabel 7600 1850 0    60   Input ~ 0
ar.[n+2]
Text HLabel 7600 1950 0    60   Input ~ 0
br.[n+2]
Text HLabel 7600 2050 0    60   Input ~ 0
mq.[n+2]
Text HLabel 7600 2150 0    60   Input ~ 0
fm.[n+2]
Text HLabel 7600 2250 0    60   Input ~ 0
brx.[n+2]
Text HLabel 7600 2350 0    60   Input ~ 0
arx.[n+2]
Text HLabel 7600 2450 0    60   Input ~ 0
adx.[n+2]
Text HLabel 7600 2550 0    60   Input ~ 0
ad.[n+2]
Text HLabel 8800 1850 2    60   Input ~ 0
ebus-d.[n+2]
$Comp
L MC10164 e44
U 1 1 57B687C3
P 10050 2450
AR Path="/57B68864/57B6BA75/57B687C3" Ref="e44"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B687C3" Ref="e44"  Part="1" 
F 0 "e44" H 10070 3200 60  0000 C CNN
F 1 "MC10164" H 10090 1700 60  0000 C CNN
F 2 "" H 10050 2450 60  0001 C CNN
F 3 "" H 10050 2450 60  0001 C CNN
	1    10050 2450
	1    0    0    -1  
$EndComp
Text HLabel 9450 1850 0    60   Input ~ 0
ar.[n+3]
Text HLabel 9450 1950 0    60   Input ~ 0
br.[n+3]
Text HLabel 9450 2050 0    60   Input ~ 0
mq.[n+3]
Text HLabel 9450 2150 0    60   Input ~ 0
fm.[n+3]
Text HLabel 9450 2250 0    60   Input ~ 0
brx.[n+3]
Text HLabel 9450 2350 0    60   Input ~ 0
arx.[n+3]
Text HLabel 9450 2450 0    60   Input ~ 0
adx.[n+3]
Text HLabel 9450 2550 0    60   Input ~ 0
ad.[n+3]
Text HLabel 10650 1850 2    60   Input ~ 0
ebus-d.[n+3]
Wire Wire Line
	1900 5850 2150 5850
Wire Wire Line
	2050 3750 2050 5850
Wire Wire Line
	2050 3750 2150 3750
Connection ~ 2050 5850
Wire Wire Line
	2050 4450 2150 4450
Connection ~ 2050 4450
Wire Wire Line
	2050 5150 2150 5150
Connection ~ 2050 5150
Wire Wire Line
	1900 5650 2150 5650
Wire Wire Line
	3700 2750 3900 2750
Wire Wire Line
	3850 3050 3850 5850
Wire Wire Line
	3700 2750 3700 4950
Wire Wire Line
	3600 2850 3900 2850
Wire Wire Line
	3600 2850 3600 4450
Wire Wire Line
	3500 2950 3900 2950
Wire Wire Line
	3500 2950 3500 3750
Wire Wire Line
	1850 3550 2150 3550
Wire Wire Line
	1850 4250 2150 4250
Wire Wire Line
	1850 4950 2150 4950
Wire Wire Line
	3850 5850 3350 5850
Wire Wire Line
	3700 4950 3350 4950
Wire Wire Line
	3600 4450 3350 4450
Wire Wire Line
	3500 3750 3350 3750
Connection ~ 3850 2750
Connection ~ 3850 2850
Connection ~ 3850 2950
Connection ~ 3900 3050
Connection ~ 5750 2750
Connection ~ 5750 2850
Connection ~ 5750 2950
Connection ~ 5750 3050
Wire Wire Line
	3850 2750 9450 2750
Wire Wire Line
	3850 2850 9450 2850
Wire Wire Line
	3850 2950 9450 2950
Wire Wire Line
	3850 3050 9450 3050
Connection ~ 7600 2750
Connection ~ 7600 2850
Connection ~ 7600 2950
Connection ~ 7600 3050
$Comp
L MC10164 e36
U 1 1 57B68EF7
P 11900 2450
AR Path="/57B68864/57B6BA75/57B68EF7" Ref="e36"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B68EF7" Ref="e36"  Part="1" 
F 0 "e36" H 11920 3200 60  0000 C CNN
F 1 "MC10164" H 11940 1700 60  0000 C CNN
F 2 "" H 11900 2450 60  0001 C CNN
F 3 "" H 11900 2450 60  0001 C CNN
	1    11900 2450
	1    0    0    -1  
$EndComp
Text HLabel 11300 1850 0    60   Input ~ 0
ar.[n+4]
Text HLabel 11300 1950 0    60   Input ~ 0
br.[n+4]
Text HLabel 11300 2050 0    60   Input ~ 0
mq.[n+4]
Text HLabel 11300 2150 0    60   Input ~ 0
fm.[n+4]
Text HLabel 11300 2250 0    60   Input ~ 0
brx.[n+4]
Text HLabel 11300 2350 0    60   Input ~ 0
arx.[n+4]
Text HLabel 11300 2450 0    60   Input ~ 0
adx.[n+4]
Text HLabel 11300 2550 0    60   Input ~ 0
ad.[n+4]
Text HLabel 12500 1850 2    60   Input ~ 0
ebus-d.[n+4]
Wire Wire Line
	9400 2750 13150 2750
Connection ~ 9400 2750
Wire Wire Line
	9400 2850 13150 2850
Connection ~ 9400 2850
Wire Wire Line
	9400 2950 13150 2950
Connection ~ 9400 2950
Wire Wire Line
	9400 3050 13150 3050
Connection ~ 9400 3050
$Comp
L MC10164 e37
U 1 1 57B697CA
P 13750 2450
AR Path="/57B68864/57B6BA75/57B697CA" Ref="e37"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B697CA" Ref="e37"  Part="1" 
F 0 "e37" H 13770 3200 60  0000 C CNN
F 1 "MC10164" H 13790 1700 60  0000 C CNN
F 2 "" H 13750 2450 60  0001 C CNN
F 3 "" H 13750 2450 60  0001 C CNN
	1    13750 2450
	1    0    0    -1  
$EndComp
Text HLabel 13150 1850 0    60   Input ~ 0
ar.[n+5]
Text HLabel 13150 1950 0    60   Input ~ 0
br.[n+5]
Text HLabel 13150 2050 0    60   Input ~ 0
mq.[n+5]
Text HLabel 13150 2150 0    60   Input ~ 0
fm.[n+5]
Text HLabel 13150 2250 0    60   Input ~ 0
brx.[n+5]
Text HLabel 13150 2350 0    60   Input ~ 0
arx.[n+5]
Text HLabel 13150 2450 0    60   Input ~ 0
adx.[n+5]
Text HLabel 13150 2550 0    60   Input ~ 0
ad.[n+5]
Text HLabel 14350 1850 2    60   Input ~ 0
ebus-d.[n+5]
Connection ~ 11300 2750
Connection ~ 11300 2850
Connection ~ 11300 2950
Connection ~ 11300 3050
$Comp
L MC10147 e69
U 1 1 57B6B34B
P 5550 4800
AR Path="/57B68864/57B6BA75/57B6B34B" Ref="e69"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6B34B" Ref="e69"  Part="1" 
F 0 "e69" H 5570 5450 60  0000 C CNN
F 1 "MC10147" H 5550 4600 60  0000 C CNN
F 2 "" H 5550 4800 60  0001 C CNN
F 3 "" H 5550 4800 60  0001 C CNN
	1    5550 4800
	1    0    0    -1  
$EndComp
NoConn ~ 4950 5100
NoConn ~ 4950 5200
Text HLabel 4950 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 4950 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 4950 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 4950 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 4950 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 4950 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 4950 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
$Comp
L MC10105 U1
U 1 1 57B6BFA9
P 1900 6700
AR Path="/57B68864/57B6BA75/57B6BFA9" Ref="U1"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6BFA9" Ref="U?"  Part="1" 
F 0 "U1" H 1920 6950 60  0000 C CNN
F 1 "MC10105" H 1940 6450 60  0000 C CNN
F 2 "" H 1900 6700 60  0001 C CNN
F 3 "" H 1900 6700 60  0001 C CNN
	1    1900 6700
	1    0    0    -1  
$EndComp
$Comp
L MC10105 U1
U 2 1 57B6C012
P 4250 6800
AR Path="/57B68864/57B6BA75/57B6C012" Ref="U1"  Part="2" 
AR Path="/57B6D511/57B6BA75/57B6C012" Ref="U?"  Part="2" 
F 0 "U1" H 4270 7050 60  0000 C CNN
F 1 "MC10105" H 4290 6550 60  0000 C CNN
F 2 "" H 4250 6800 60  0001 C CNN
F 3 "" H 4250 6800 60  0001 C CNN
	2    4250 6800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 6800 3650 6800
NoConn ~ 1300 6800
NoConn ~ 1300 6700
NoConn ~ 4850 6700
Wire Wire Line
	4950 5300 4950 6900
Wire Wire Line
	4950 6900 4850 6900
Text HLabel 4700 6200 0    60   Input ~ 0
dp04-fm-write-l
Connection ~ 4950 6200
$Comp
L DELAYLINE DL1
U 1 1 57B6D95B
P 3100 6500
AR Path="/57B68864/57B6BA75/57B6D95B" Ref="DL1"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6D95B" Ref="DL1"  Part="1" 
F 0 "DL1" H 3100 6700 60  0000 C CNN
F 1 "35ns" H 3100 6600 60  0000 C CNN
F 2 "" H 3100 6500 60  0001 C CNN
F 3 "" H 3100 6500 60  0001 C CNN
	1    3100 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 6600 2700 6600
Wire Wire Line
	2700 6600 2700 6500
Wire Wire Line
	3500 6500 3600 6500
Wire Wire Line
	3600 6500 3600 6700
Wire Wire Line
	3600 6700 3650 6700
Text HLabel 3650 6900 0    60   Input ~ 0
fm-write.0-35-l
$Comp
L MC10147 e70
U 1 1 57B6DF9C
P 7300 4800
AR Path="/57B68864/57B6BA75/57B6DF9C" Ref="e70"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6DF9C" Ref="e70"  Part="1" 
F 0 "e70" H 7320 5450 60  0000 C CNN
F 1 "MC10147" H 7300 4600 60  0000 C CNN
F 2 "" H 7300 4800 60  0001 C CNN
F 3 "" H 7300 4800 60  0001 C CNN
	1    7300 4800
	1    0    0    -1  
$EndComp
NoConn ~ 6700 5100
NoConn ~ 6700 5200
Text HLabel 6700 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 6700 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 6700 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 6700 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 6700 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 6700 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 6700 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
Wire Wire Line
	4700 6200 4950 6200
Wire Wire Line
	4950 6100 8450 6100
Wire Wire Line
	6700 6100 6700 5300
$Comp
L MC10147 e71
U 1 1 57B6E4E7
P 9050 4800
AR Path="/57B68864/57B6BA75/57B6E4E7" Ref="e71"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6E4E7" Ref="e71"  Part="1" 
F 0 "e71" H 9070 5450 60  0000 C CNN
F 1 "MC10147" H 9050 4600 60  0000 C CNN
F 2 "" H 9050 4800 60  0001 C CNN
F 3 "" H 9050 4800 60  0001 C CNN
	1    9050 4800
	1    0    0    -1  
$EndComp
NoConn ~ 8450 5100
NoConn ~ 8450 5200
Text HLabel 8450 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 8450 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 8450 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 8450 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 8450 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 8450 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 8450 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
Wire Wire Line
	8450 6100 8450 5300
Connection ~ 6700 6100
Connection ~ 4950 6100
Wire Wire Line
	6700 6100 13700 6100
$Comp
L MC10147 e72
U 1 1 57B6EA16
P 10800 4800
AR Path="/57B68864/57B6BA75/57B6EA16" Ref="e72"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6EA16" Ref="e72"  Part="1" 
F 0 "e72" H 10820 5450 60  0000 C CNN
F 1 "MC10147" H 10800 4600 60  0000 C CNN
F 2 "" H 10800 4800 60  0001 C CNN
F 3 "" H 10800 4800 60  0001 C CNN
	1    10800 4800
	1    0    0    -1  
$EndComp
NoConn ~ 10200 5100
NoConn ~ 10200 5200
Text HLabel 10200 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 10200 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 10200 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 10200 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 10200 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 10200 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 10200 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
Wire Wire Line
	10200 6100 10200 5300
$Comp
L MC10147 e65
U 1 1 57B6EE8E
P 12550 4800
AR Path="/57B68864/57B6BA75/57B6EE8E" Ref="e65"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6EE8E" Ref="e65"  Part="1" 
F 0 "e65" H 12570 5450 60  0000 C CNN
F 1 "MC10147" H 12550 4600 60  0000 C CNN
F 2 "" H 12550 4800 60  0001 C CNN
F 3 "" H 12550 4800 60  0001 C CNN
	1    12550 4800
	1    0    0    -1  
$EndComp
NoConn ~ 11950 5100
NoConn ~ 11950 5200
Text HLabel 11950 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 11950 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 11950 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 11950 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 11950 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 11950 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 11950 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
Wire Wire Line
	11950 6100 11950 5300
Connection ~ 10200 6100
Connection ~ 8450 6100
$Comp
L MC10147 e58
U 1 1 57B6F292
P 14300 4800
AR Path="/57B68864/57B6BA75/57B6F292" Ref="e58"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6F292" Ref="e58"  Part="1" 
F 0 "e58" H 14320 5450 60  0000 C CNN
F 1 "MC10147" H 14300 4600 60  0000 C CNN
F 2 "" H 14300 4800 60  0001 C CNN
F 3 "" H 14300 4800 60  0001 C CNN
	1    14300 4800
	1    0    0    -1  
$EndComp
NoConn ~ 13700 5100
NoConn ~ 13700 5200
Text HLabel 13700 4300 0    60   Input ~ 0
apr-fm-block.[n+2]
Text HLabel 13700 4400 0    60   Input ~ 0
apr-fm-block.[n+1]
Text HLabel 13700 4500 0    60   Input ~ 0
apr-fm-block.[n+0]
Text HLabel 13700 4600 0    60   Input ~ 0
apr-fm-adr.[n+3]
Text HLabel 13700 4700 0    60   Input ~ 0
apr-fm-adr.[n+2]
Text HLabel 13700 4800 0    60   Input ~ 0
apr-fm-adr.[n+1]
Text HLabel 13700 4900 0    60   Input ~ 0
apr-fm-adr.[n+0]
Wire Wire Line
	13700 6100 13700 5300
Connection ~ 11950 6100
$Comp
L MC10160 e64
U 1 1 57B6F81F
P 12750 7300
AR Path="/57B68864/57B6BA75/57B6F81F" Ref="e64"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B6F81F" Ref="e64"  Part="1" 
F 0 "e64" H 12770 8000 60  0000 C CNN
F 1 "MC10160" H 12790 6600 60  0000 C CNN
F 2 "" H 12750 7300 60  0001 C CNN
F 3 "" H 12750 7300 60  0001 C CNN
	1    12750 7300
	1    0    0    -1  
$EndComp
Text HLabel 12150 6750 0    60   Input ~ 0
fm.[n+0]
Text HLabel 12150 6850 0    60   Input ~ 0
fm.[n+1]
Text HLabel 12150 6950 0    60   Input ~ 0
fm.[n+2]
Text HLabel 12150 7050 0    60   Input ~ 0
fm.[n+3]
Text HLabel 12150 7150 0    60   Input ~ 0
fm.[n+4]
Text HLabel 12150 7250 0    60   Input ~ 0
fm.[n+5]
Text HLabel 13350 7250 2    60   Output ~ 0
edp-fm-parity.0-5
NoConn ~ 12150 7350
NoConn ~ 12150 7450
NoConn ~ 12150 7550
NoConn ~ 12150 7650
NoConn ~ 12150 7750
NoConn ~ 12150 7850
$Comp
L MC10101 e38
U 1 1 57B701A9
P 2050 9250
AR Path="/57B68864/57B6BA75/57B701A9" Ref="e38"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B701A9" Ref="e38"  Part="1" 
F 0 "e38" H 2070 9500 60  0000 C CNN
F 1 "MC10101" H 2090 9000 60  0000 C CNN
F 2 "" H 2050 9250 60  0001 C CNN
F 3 "" H 2050 9250 60  0001 C CNN
	1    2050 9250
	1    0    0    -1  
$EndComp
Text HLabel 1450 9150 0    60   Input ~ 0
cram-br-load
NoConn ~ 1450 9350
NoConn ~ 2650 9350
$Comp
L MC10141 e61
U 1 1 57B70692
P 4150 8950
AR Path="/57B68864/57B6BA75/57B70692" Ref="e61"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B70692" Ref="e61"  Part="1" 
F 0 "e61" H 4170 9550 60  0000 C CNN
F 1 "MC10141" H 4190 8350 60  0000 C CNN
F 2 "" H 4150 8950 60  0001 C CNN
F 3 "" H 4150 8950 60  0001 C CNN
	1    4150 8950
	1    0    0    -1  
$EndComp
Text HLabel 3550 9200 0    60   Input ~ 0
dp04-clk
Wire Wire Line
	2650 9150 2950 9150
Wire Wire Line
	2950 9150 2950 9300
Wire Wire Line
	2950 9300 9050 9300
Wire Wire Line
	3550 9300 3550 9400
Wire Wire Line
	3550 8600 3550 8700
Text HLabel 3450 8700 0    60   Input ~ 0
ar.[n+0]
Wire Wire Line
	3550 8700 3450 8700
Text HLabel 3450 8800 0    60   Input ~ 0
ar.[n+1]
Text HLabel 3450 8900 0    60   Input ~ 0
ar.[n+2]
Wire Wire Line
	3450 8900 3550 8900
Wire Wire Line
	3450 8800 3550 8800
NoConn ~ 3550 9000
NoConn ~ 3550 8500
Text HLabel 4750 8600 2    60   Input ~ 0
br.[n+0]
Text HLabel 4750 8700 2    60   Input ~ 0
br.[n+0]
Text HLabel 4750 8800 2    60   Input ~ 0
br.[n+1]
Text HLabel 4750 8900 2    60   Input ~ 0
br.[n+2]
$Comp
L MC10141 e63
U 1 1 57B71A9E
P 5950 8950
AR Path="/57B68864/57B6BA75/57B71A9E" Ref="e63"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B71A9E" Ref="e63"  Part="1" 
F 0 "e63" H 5970 9550 60  0000 C CNN
F 1 "MC10141" H 5990 8350 60  0000 C CNN
F 2 "" H 5950 8950 60  0001 C CNN
F 3 "" H 5950 8950 60  0001 C CNN
	1    5950 8950
	1    0    0    -1  
$EndComp
Text HLabel 5350 9200 0    60   Input ~ 0
dp04-clk
Wire Wire Line
	5350 9300 5350 9400
Text HLabel 5250 8700 0    60   Input ~ 0
ar.[n+4]
Wire Wire Line
	5350 8700 5250 8700
Text HLabel 5250 8800 0    60   Input ~ 0
ar.[n+5]
Wire Wire Line
	5250 8800 5350 8800
NoConn ~ 5350 9000
NoConn ~ 5350 8500
Text HLabel 6550 8600 2    60   Input ~ 0
br.[n+3]
Text HLabel 6550 8700 2    60   Input ~ 0
br.[n+4]
Text HLabel 6550 8800 2    60   Input ~ 0
br.[n+5]
Connection ~ 3550 9300
Text HLabel 5250 8600 0    60   Input ~ 0
ar.[n+3]
Wire Wire Line
	5250 8600 5350 8600
NoConn ~ 5350 8900
NoConn ~ 6550 8900
$Comp
L MC10141 e8
U 1 1 57B724AF
P 7750 8950
AR Path="/57B68864/57B6BA75/57B724AF" Ref="e8"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B724AF" Ref="e8"  Part="1" 
F 0 "e8" H 7770 9550 60  0000 C CNN
F 1 "MC10141" H 7790 8350 60  0000 C CNN
F 2 "" H 7750 8950 60  0001 C CNN
F 3 "" H 7750 8950 60  0001 C CNN
	1    7750 8950
	1    0    0    -1  
$EndComp
Text HLabel 7150 9200 0    60   Input ~ 0
dp04-clk
Text HLabel 7050 8700 0    60   Input ~ 0
arx.[n+1]
Wire Wire Line
	7150 8700 7050 8700
Text HLabel 7050 8800 0    60   Input ~ 0
arx.[n+2]
Wire Wire Line
	7050 8800 7150 8800
NoConn ~ 7150 9000
NoConn ~ 7150 8500
Text HLabel 8350 8600 2    60   Input ~ 0
brx.[n+0]
Text HLabel 8350 8700 2    60   Input ~ 0
brx.[n+1]
Text HLabel 8350 8800 2    60   Input ~ 0
brx.[n+2]
Text HLabel 7050 8600 0    60   Input ~ 0
arx.[n+0]
Wire Wire Line
	7050 8600 7150 8600
NoConn ~ 7150 8900
NoConn ~ 8350 8900
Connection ~ 5350 9300
$Comp
L MC10141 e10
U 1 1 57B72C2C
P 9650 8950
AR Path="/57B68864/57B6BA75/57B72C2C" Ref="e10"  Part="1" 
AR Path="/57B6D511/57B6BA75/57B72C2C" Ref="e10"  Part="1" 
F 0 "e10" H 9670 9550 60  0000 C CNN
F 1 "MC10141" H 9690 8350 60  0000 C CNN
F 2 "" H 9650 8950 60  0001 C CNN
F 3 "" H 9650 8950 60  0001 C CNN
	1    9650 8950
	1    0    0    -1  
$EndComp
Text HLabel 9050 9200 0    60   Input ~ 0
dp04-clk
Text HLabel 8950 8700 0    60   Input ~ 0
arx.[n+4]
Wire Wire Line
	9050 8700 8950 8700
Text HLabel 8950 8800 0    60   Input ~ 0
arx.[n+5]
Wire Wire Line
	8950 8800 9050 8800
NoConn ~ 9050 9000
NoConn ~ 9050 8500
Text HLabel 10250 8600 2    60   Input ~ 0
brx.[n+3]
Text HLabel 10250 8700 2    60   Input ~ 0
brx.[n+4]
Text HLabel 10250 8800 2    60   Input ~ 0
brx.[n+5]
Text HLabel 8950 8600 0    60   Input ~ 0
arx.[n+3]
Wire Wire Line
	8950 8600 9050 8600
NoConn ~ 9050 8900
NoConn ~ 10250 8900
Connection ~ 7150 9300
Wire Wire Line
	9050 9300 9050 9400
Text HLabel 5750 3900 1    60   Input ~ 0
fm.[n+0]
Text HLabel 7500 3900 1    60   Input ~ 0
fm.[n+1]
Text HLabel 9250 3900 1    60   Input ~ 0
fm.[n+2]
Text HLabel 11000 3900 1    60   Input ~ 0
fm.[n+3]
Text HLabel 12750 3900 1    60   Input ~ 0
fm.[n+4]
Text HLabel 14500 3900 1    60   Input ~ 0
fm.[n+5]
Text HLabel 14500 5700 3    60   Input ~ 0
ar.[n+5]
Text HLabel 12750 5700 3    60   Input ~ 0
ar.[n+4]
Text HLabel 11000 5700 3    60   Input ~ 0
ar.[n+3]
Text HLabel 7500 5700 3    60   Input ~ 0
ar.[n+1]
Text HLabel 9250 5700 3    60   Input ~ 0
ar.[n+2]
Text HLabel 5750 5700 3    60   Input ~ 0
ar.[n+0]
Text HLabel 1300 6600 0    60   Input ~ 0
dp04-clk
$EndSCHEMATC
