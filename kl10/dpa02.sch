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
Sheet 4 6
Title "DATA PATH ARX & MQ Registers"
Date "10/21/1976"
Rev "A"
Comp "Digitized Equipment Corporation"
Comment1 "M8512-0-DP02"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MC10141 e25
U 1 1 57ACA2E8
P 5450 1500
AR Path="/57B68864/57B6B9B0/57ACA2E8" Ref="e25"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACA2E8" Ref="e25"  Part="1" 
F 0 "e25" H 5470 2100 60  0000 C CNN
F 1 "MC10141" H 5490 900 60  0000 C CNN
F 2 "" H 5450 1500 60  0000 C CNN
F 3 "" H 5450 1500 60  0000 C CNN
	1    5450 1500
	1    0    0    -1  
$EndComp
Text HLabel 4750 1250 0    60   Input ~ 0
arxm.[n+0]
Text HLabel 4750 1350 0    60   Input ~ 0
arxm.[n+1]
Text HLabel 4750 1450 0    60   Input ~ 0
arxm.[n+2]
Wire Wire Line
	4750 1250 4850 1250
Wire Wire Line
	4750 1350 4850 1350
Wire Wire Line
	4750 1450 4850 1450
Wire Wire Line
	4850 1250 4850 1150
NoConn ~ 4850 1050
NoConn ~ 4850 1550
Wire Wire Line
	4850 1850 4850 2200
Text HLabel 4800 1750 2    60   Input ~ 0
dp04-clk
Wire Wire Line
	4800 1750 4850 1750
$Comp
L MC10101 e24
U 3 1 57ACA62E
P 4100 2300
AR Path="/57B68864/57B6B9B0/57ACA62E" Ref="e24"  Part="3" 
AR Path="/57B6D511/57B6B9B0/57ACA62E" Ref="e24"  Part="3" 
F 0 "e24" H 4120 2550 60  0000 C CNN
F 1 "MC10101" H 4140 2050 60  0000 C CNN
F 2 "" H 4100 2300 60  0000 C CNN
F 3 "" H 4100 2300 60  0000 C CNN
	3    4100 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 2200 4700 2200
Connection ~ 4850 1950
Text HLabel 3450 2200 2    60   Input ~ 0
ctl-arx-load
Wire Wire Line
	3450 2200 3500 2200
Text HLabel 6100 1150 2    60   Input ~ 0
arx.[n+0]
Text HLabel 6100 1250 2    60   Input ~ 0
arx.[n+0]
Text HLabel 6100 1350 2    60   Input ~ 0
arx.[n+1]
Text HLabel 6100 1450 2    60   Input ~ 0
arx.[n+2]
Wire Wire Line
	6050 1150 6100 1150
Wire Wire Line
	6050 1250 6100 1250
Wire Wire Line
	6050 1350 6100 1350
Wire Wire Line
	6050 1450 6100 1450
$Comp
L MC10141 e32
U 1 1 57ACAB89
P 8650 1500
AR Path="/57B68864/57B6B9B0/57ACAB89" Ref="e32"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACAB89" Ref="e32"  Part="1" 
F 0 "e32" H 8670 2100 60  0000 C CNN
F 1 "MC10141" H 8690 900 60  0000 C CNN
F 2 "" H 8650 1500 60  0000 C CNN
F 3 "" H 8650 1500 60  0000 C CNN
	1    8650 1500
	1    0    0    -1  
$EndComp
Text HLabel 7950 1250 0    60   Input ~ 0
arxm.[n+3]
Text HLabel 7950 1350 0    60   Input ~ 0
arxm.[n+4]
Text HLabel 7950 1450 0    60   Input ~ 0
arxm.[n+5]
Wire Wire Line
	7950 1250 8050 1250
Wire Wire Line
	7950 1350 8050 1350
Wire Wire Line
	7950 1450 8050 1450
NoConn ~ 8050 1050
NoConn ~ 8050 1550
Wire Wire Line
	8050 1850 8050 2200
Text HLabel 8000 1750 2    60   Input ~ 0
dp04-clk
Wire Wire Line
	8000 1750 8050 1750
Connection ~ 8050 1950
Text HLabel 9300 1150 2    60   Input ~ 0
arx.[n+1]
Text HLabel 9300 1250 2    60   Input ~ 0
arx.[n+3]
Text HLabel 9300 1350 2    60   Input ~ 0
arx.[n+4]
Text HLabel 9300 1450 2    60   Input ~ 0
arx.[n+5]
Wire Wire Line
	9250 1150 9300 1150
Wire Wire Line
	9250 1250 9300 1250
Wire Wire Line
	9250 1350 9300 1350
Wire Wire Line
	9250 1450 9300 1450
Connection ~ 4850 2200
Text HLabel 7950 1150 0    60   Input ~ 0
arxm.[n+1]
Wire Wire Line
	8050 1150 7950 1150
$Comp
L MC10164 e55
U 1 1 57ACAFFC
P 3650 4050
AR Path="/57B68864/57B6B9B0/57ACAFFC" Ref="e55"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACAFFC" Ref="e55"  Part="1" 
F 0 "e55" H 3670 4800 60  0000 C CNN
F 1 "MC10164" H 3690 3300 60  0000 C CNN
F 2 "" H 3650 4050 60  0000 C CNN
F 3 "" H 3650 4050 60  0000 C CNN
	1    3650 4050
	1    0    0    -1  
$EndComp
NoConn ~ 3050 3450
Text HLabel 3000 3550 0    60   Input ~ 0
cache-data.[n+0]
Text HLabel 3000 3650 0    60   Input ~ 0
ad.[n+0]
Text HLabel 3000 3750 0    60   Input ~ 0
mq.[n+0]
Text HLabel 3000 3850 0    60   Input ~ 0
sh.[n+0]
Text HLabel 3000 3950 0    60   Input ~ 0
adx.[n+1]
Text HLabel 3000 4050 0    60   Input ~ 0
adx.[n+0]
Wire Wire Line
	3000 3550 3050 3550
Wire Wire Line
	3000 3650 3050 3650
Wire Wire Line
	3000 3750 3050 3750
Wire Wire Line
	3000 3850 3050 3850
Wire Wire Line
	3000 3950 3050 3950
Wire Wire Line
	3000 4050 3050 4050
Wire Wire Line
	3000 4150 3050 4150
Text HLabel 3000 4150 0    60   Input ~ 0
[(n+199)/100,ad.34,adx.[n-2]]
Text HLabel 4300 3450 2    60   Input ~ 0
arxm.[n+0]
Wire Wire Line
	4250 3450 4300 3450
Text HLabel 3000 4350 0    60   Input ~ 0
[n/18+1,ctl-arxl-sel-1,ctl-arxr-sel-1]
Text HLabel 3000 4450 0    60   Input ~ 0
[n/18+1,ctl-arxl-sel-2,ctl-arxr-sel-2]
Text HLabel 3000 4550 0    60   Input ~ 0
cram-arxm-sel-4-[n/18+1,00,06]
Wire Wire Line
	3000 4450 5400 4450
Wire Wire Line
	3000 4550 5400 4550
NoConn ~ 3050 4650
$Comp
L MC10164 e56
U 1 1 57ACB70A
P 6000 4050
AR Path="/57B68864/57B6B9B0/57ACB70A" Ref="e56"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACB70A" Ref="e56"  Part="1" 
F 0 "e56" H 6020 4800 60  0000 C CNN
F 1 "MC10164" H 6040 3300 60  0000 C CNN
F 2 "" H 6000 4050 60  0000 C CNN
F 3 "" H 6000 4050 60  0000 C CNN
	1    6000 4050
	1    0    0    -1  
$EndComp
NoConn ~ 5400 3450
Text HLabel 5350 3550 0    60   Input ~ 0
cache-data.[n+1]
Text HLabel 5350 3650 0    60   Input ~ 0
ad.[n+1]
Text HLabel 5350 3750 0    60   Input ~ 0
mq.[n+1]
Text HLabel 5350 3850 0    60   Input ~ 0
sh.[n+1]
Text HLabel 5350 3950 0    60   Input ~ 0
adx.[n+2]
Text HLabel 5350 4050 0    60   Input ~ 0
adx.[n+1]
Wire Wire Line
	5350 3550 5400 3550
Wire Wire Line
	5350 3650 5400 3650
Wire Wire Line
	5350 3750 5400 3750
Wire Wire Line
	5350 3850 5400 3850
Wire Wire Line
	5350 3950 5400 3950
Wire Wire Line
	5350 4050 5400 4050
Wire Wire Line
	5350 4150 5400 4150
Text HLabel 5350 4150 0    60   Input ~ 0
[(n+199)/100,ad.35,adx.[n-1]]
Text HLabel 6650 3450 2    60   Input ~ 0
arxm.[n+1]
Wire Wire Line
	6600 3450 6650 3450
NoConn ~ 5400 4650
Connection ~ 3050 4350
Connection ~ 3050 4450
Connection ~ 3050 4550
Wire Wire Line
	3000 4350 7700 4350
Wire Wire Line
	4900 4450 7700 4450
Wire Wire Line
	4900 4550 7700 4550
$Comp
L MC10164 e49
U 1 1 57ACBC44
P 8300 4050
AR Path="/57B68864/57B6B9B0/57ACBC44" Ref="e49"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACBC44" Ref="e49"  Part="1" 
F 0 "e49" H 8320 4800 60  0000 C CNN
F 1 "MC10164" H 8340 3300 60  0000 C CNN
F 2 "" H 8300 4050 60  0000 C CNN
F 3 "" H 8300 4050 60  0000 C CNN
	1    8300 4050
	1    0    0    -1  
$EndComp
NoConn ~ 7700 3450
Text HLabel 7650 3550 0    60   Input ~ 0
cache-data.[n+2]
Text HLabel 7650 3650 0    60   Input ~ 0
ad.[n+2]
Text HLabel 7650 3750 0    60   Input ~ 0
mq.[n+2]
Text HLabel 7650 3850 0    60   Input ~ 0
sh.[n+2]
Text HLabel 7650 3950 0    60   Input ~ 0
adx.[n+3]
Text HLabel 7650 4050 0    60   Input ~ 0
adx.[n+2]
Wire Wire Line
	7650 3550 7700 3550
Wire Wire Line
	7650 3650 7700 3650
Wire Wire Line
	7650 3750 7700 3750
Wire Wire Line
	7650 3850 7700 3850
Wire Wire Line
	7650 3950 7700 3950
Wire Wire Line
	7650 4050 7700 4050
Text HLabel 8950 3450 2    60   Input ~ 0
arxm.[n+2]
Wire Wire Line
	8900 3450 8950 3450
NoConn ~ 7700 4650
Text HLabel 7650 4150 0    60   Input ~ 0
adx.[n+0]
Wire Wire Line
	7650 4150 7700 4150
Wire Wire Line
	7050 4350 9850 4350
Wire Wire Line
	7050 4450 9850 4450
Wire Wire Line
	7050 4550 9850 4550
$Comp
L MC10164 e42
U 1 1 57ACC128
P 10450 4050
AR Path="/57B68864/57B6B9B0/57ACC128" Ref="e42"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACC128" Ref="e42"  Part="1" 
F 0 "e42" H 10470 4800 60  0000 C CNN
F 1 "MC10164" H 10490 3300 60  0000 C CNN
F 2 "" H 10450 4050 60  0000 C CNN
F 3 "" H 10450 4050 60  0000 C CNN
	1    10450 4050
	1    0    0    -1  
$EndComp
NoConn ~ 9850 3450
Text HLabel 9800 3550 0    60   Input ~ 0
cache-data.[n+3]
Text HLabel 9800 3650 0    60   Input ~ 0
ad.[n+3]
Text HLabel 9800 3750 0    60   Input ~ 0
mq.[n+3]
Text HLabel 9800 3850 0    60   Input ~ 0
sh.[n+3]
Text HLabel 9800 3950 0    60   Input ~ 0
adx.[n+4]
Text HLabel 9800 4050 0    60   Input ~ 0
adx.[n+3]
Wire Wire Line
	9800 3550 9850 3550
Wire Wire Line
	9800 3650 9850 3650
Wire Wire Line
	9800 3750 9850 3750
Wire Wire Line
	9800 3850 9850 3850
Wire Wire Line
	9800 3950 9850 3950
Wire Wire Line
	9800 4050 9850 4050
Text HLabel 11100 3450 2    60   Input ~ 0
arxm.[n+3]
Wire Wire Line
	11050 3450 11100 3450
NoConn ~ 9850 4650
Text HLabel 9800 4150 0    60   Input ~ 0
adx.[n+1]
Wire Wire Line
	9800 4150 9850 4150
Wire Wire Line
	4900 4350 5400 4350
Connection ~ 4900 4350
Connection ~ 4900 4450
Connection ~ 4900 4550
Connection ~ 7050 4350
Connection ~ 7050 4450
Connection ~ 7050 4550
Wire Wire Line
	9300 4350 12100 4350
Wire Wire Line
	9300 4450 12100 4450
Wire Wire Line
	9300 4550 12100 4550
$Comp
L MC10164 e31
U 1 1 57ACCDCD
P 12700 4050
AR Path="/57B68864/57B6B9B0/57ACCDCD" Ref="e31"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACCDCD" Ref="e31"  Part="1" 
F 0 "e31" H 12720 4800 60  0000 C CNN
F 1 "MC10164" H 12740 3300 60  0000 C CNN
F 2 "" H 12700 4050 60  0000 C CNN
F 3 "" H 12700 4050 60  0000 C CNN
	1    12700 4050
	1    0    0    -1  
$EndComp
NoConn ~ 12100 3450
Text HLabel 12050 3550 0    60   Input ~ 0
cache-data.[n+4]
Text HLabel 12050 3650 0    60   Input ~ 0
ad.[n+4]
Text HLabel 12050 3750 0    60   Input ~ 0
mq.[n+4]
Text HLabel 12050 3850 0    60   Input ~ 0
sh.[n+4]
Text HLabel 12050 3950 0    60   Input ~ 0
adx.[n+5]
Text HLabel 12050 4050 0    60   Input ~ 0
adx.[n+4]
Wire Wire Line
	12050 3550 12100 3550
Wire Wire Line
	12050 3650 12100 3650
Wire Wire Line
	12050 3750 12100 3750
Wire Wire Line
	12050 3850 12100 3850
Wire Wire Line
	12050 3950 12100 3950
Wire Wire Line
	12050 4050 12100 4050
Text HLabel 13350 3450 2    60   Input ~ 0
arxm.[n+4]
Wire Wire Line
	13300 3450 13350 3450
NoConn ~ 12100 4650
Text HLabel 12050 4150 0    60   Input ~ 0
adx.[n+2]
Wire Wire Line
	12050 4150 12100 4150
Connection ~ 9300 4350
Connection ~ 9300 4450
Connection ~ 9300 4550
Wire Wire Line
	11550 4350 14350 4350
Wire Wire Line
	11550 4450 14350 4450
Wire Wire Line
	11550 4550 14350 4550
$Comp
L MC10164 e30
U 1 1 57ACD533
P 14950 4050
AR Path="/57B68864/57B6B9B0/57ACD533" Ref="e30"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACD533" Ref="e30"  Part="1" 
F 0 "e30" H 14970 4800 60  0000 C CNN
F 1 "MC10164" H 14990 3300 60  0000 C CNN
F 2 "" H 14950 4050 60  0000 C CNN
F 3 "" H 14950 4050 60  0000 C CNN
	1    14950 4050
	1    0    0    -1  
$EndComp
NoConn ~ 14350 3450
Text HLabel 14300 3550 0    60   Input ~ 0
cache-data.[n+5]
Text HLabel 14300 3650 0    60   Input ~ 0
ad.[n+5]
Text HLabel 14300 3750 0    60   Input ~ 0
mq.[n+5]
Text HLabel 14300 3850 0    60   Input ~ 0
sh.[n+5]
Text HLabel 14300 4050 0    60   Input ~ 0
adx.[n+5]
Wire Wire Line
	14300 3550 14350 3550
Wire Wire Line
	14300 3650 14350 3650
Wire Wire Line
	14300 3750 14350 3750
Wire Wire Line
	14300 3850 14350 3850
Wire Wire Line
	14250 3950 14350 3950
Wire Wire Line
	14300 4050 14350 4050
Text HLabel 15600 3450 2    60   Input ~ 0
arxm.[n+5]
Wire Wire Line
	15550 3450 15600 3450
NoConn ~ 14350 4650
Text HLabel 14300 4150 0    60   Input ~ 0
adx.[n+3]
Wire Wire Line
	14300 4150 14350 4150
Connection ~ 11550 4350
Connection ~ 11550 4450
Connection ~ 11550 4550
Text HLabel 14250 3950 0    60   Input ~ 0
[n/30+1,adx.[n+6] h,mq.0]
$Comp
L MC10174 e45
U 1 1 57ACDEF5
P 3700 6300
AR Path="/57B68864/57B6B9B0/57ACDEF5" Ref="e45"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACDEF5" Ref="e45"  Part="1" 
F 0 "e45" H 3720 6950 60  0000 C CNN
F 1 "MC10174" H 3740 5650 60  0000 C CNN
F 2 "" H 3700 6300 60  0000 C CNN
F 3 "" H 3700 6300 60  0000 C CNN
	1    3700 6300
	1    0    0    -1  
$EndComp
$Comp
L MC10101 e38
U 4 1 57ACDF63
P 2200 7150
AR Path="/57B68864/57B6B9B0/57ACDF63" Ref="e38"  Part="4" 
AR Path="/57B6D511/57B6B9B0/57ACDF63" Ref="e38"  Part="4" 
F 0 "e38" H 2220 7400 60  0000 C CNN
F 1 "MC10101" H 2240 6900 60  0000 C CNN
F 2 "" H 2200 7150 60  0000 C CNN
F 3 "" H 2200 7150 60  0000 C CNN
	4    2200 7150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 7050 2800 6800
Wire Wire Line
	2800 6800 5650 6800
Wire Wire Line
	3050 7250 2800 7250
Wire Wire Line
	3050 6100 3050 7250
Wire Wire Line
	3050 6100 5650 6100
Text HLabel 1550 7050 0    60   Input ~ 0
ctl-mqm-en
Wire Wire Line
	1550 7050 1600 7050
NoConn ~ 1600 7250
Text HLabel 2950 6700 0    60   Input ~ 0
ctl-mqm-sel-2
Text HLabel 2950 6600 0    60   Input ~ 0
ctl-mqm-sel-1
Wire Wire Line
	2950 6700 5650 6700
Wire Wire Line
	2950 6600 5650 6600
Text HLabel 2950 6200 0    60   Input ~ 0
[(n+199)/100,adx.35,mq.[n-1]]
Text HLabel 2950 5800 0    60   Input ~ 0
[(n+199)/100,adx.34,mq.[n-2]]
Wire Wire Line
	2950 5800 3100 5800
Text HLabel 2950 5900 0    60   Input ~ 0
sh.[n+0]
Wire Wire Line
	2950 5900 3100 5900
Text HLabel 2950 6000 0    60   Input ~ 0
ad.[n+0]
Wire Wire Line
	2950 6000 3100 6000
Wire Wire Line
	2950 6200 3100 6200
Text HLabel 2950 6400 0    60   Input ~ 0
ad.[n+1]
Text HLabel 2950 6300 0    60   Input ~ 0
sh.[n+1]
Wire Wire Line
	2950 6300 3100 6300
Wire Wire Line
	2950 6400 3100 6400
Wire Wire Line
	3050 6500 5650 6500
Connection ~ 3050 6500
Text HLabel 4350 5800 2    60   Input ~ 0
mqm.[n+0]
Text HLabel 4350 6200 2    60   Input ~ 0
mqm.[n+1]
Wire Wire Line
	4300 5800 4350 5800
Wire Wire Line
	4300 6200 4350 6200
$Comp
L MC10174 e48
U 1 1 57ACF507
P 6250 6300
AR Path="/57B68864/57B6B9B0/57ACF507" Ref="e48"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57ACF507" Ref="e48"  Part="1" 
F 0 "e48" H 6270 6950 60  0000 C CNN
F 1 "MC10174" H 6290 5650 60  0000 C CNN
F 2 "" H 6250 6300 60  0000 C CNN
F 3 "" H 6250 6300 60  0000 C CNN
	1    6250 6300
	1    0    0    -1  
$EndComp
Text HLabel 5500 5900 0    60   Input ~ 0
sh.[n+2]
Wire Wire Line
	5500 5900 5650 5900
Text HLabel 5500 6000 0    60   Input ~ 0
ad.[n+2]
Wire Wire Line
	5500 6000 5650 6000
Text HLabel 5500 6400 0    60   Input ~ 0
ad.[n+3]
Text HLabel 5500 6300 0    60   Input ~ 0
sh.[n+3]
Wire Wire Line
	5500 6300 5650 6300
Wire Wire Line
	5500 6400 5650 6400
Text HLabel 6900 5800 2    60   Input ~ 0
mqm.[n+2]
Text HLabel 6900 6200 2    60   Input ~ 0
mqm.[n+3]
Wire Wire Line
	6850 5800 6900 5800
Wire Wire Line
	6850 6200 6900 6200
Connection ~ 3100 6800
Connection ~ 3100 6600
Connection ~ 3100 6700
Connection ~ 3100 6500
Connection ~ 3100 6100
Text HLabel 5500 5800 0    60   Input ~ 0
mq.[n+0]
Text HLabel 5500 6200 0    60   Input ~ 0
mq.[n+1]
Wire Wire Line
	5500 5800 5650 5800
Wire Wire Line
	5500 6200 5650 6200
Wire Wire Line
	4950 6800 7800 6800
Wire Wire Line
	5200 6100 7800 6100
Wire Wire Line
	5100 6700 7800 6700
Wire Wire Line
	5100 6600 7800 6600
Wire Wire Line
	5200 6500 7800 6500
$Comp
L MC10174 e35
U 1 1 57AD0630
P 8400 6300
AR Path="/57B68864/57B6B9B0/57AD0630" Ref="e35"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57AD0630" Ref="e35"  Part="1" 
F 0 "e35" H 8420 6950 60  0000 C CNN
F 1 "MC10174" H 8440 5650 60  0000 C CNN
F 2 "" H 8400 6300 60  0000 C CNN
F 3 "" H 8400 6300 60  0000 C CNN
	1    8400 6300
	1    0    0    -1  
$EndComp
Text HLabel 7650 5900 0    60   Input ~ 0
sh.[n+4]
Wire Wire Line
	7650 5900 7800 5900
Text HLabel 7650 6000 0    60   Input ~ 0
ad.[n+4]
Wire Wire Line
	7650 6000 7800 6000
Text HLabel 7650 6400 0    60   Input ~ 0
ad.[n+3]
Text HLabel 7650 6300 0    60   Input ~ 0
ad.[n+5]
Wire Wire Line
	7650 6300 7800 6300
Wire Wire Line
	7650 6400 7800 6400
Text HLabel 9050 5800 2    60   Input ~ 0
mqm.[n+4]
Text HLabel 9050 6200 2    60   Input ~ 0
mqm.[n+5]
Wire Wire Line
	9000 5800 9050 5800
Wire Wire Line
	9000 6200 9050 6200
Text HLabel 7650 5800 0    60   Input ~ 0
mq.[n+2]
Text HLabel 7650 6200 0    60   Input ~ 0
mq.[n+3]
Wire Wire Line
	7650 5800 7800 5800
Wire Wire Line
	7650 6200 7800 6200
$Comp
L MC10141 e13
U 1 1 57AD0A4E
P 10750 6250
AR Path="/57B68864/57B6B9B0/57AD0A4E" Ref="e13"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57AD0A4E" Ref="e13"  Part="1" 
F 0 "e13" H 10770 6850 60  0000 C CNN
F 1 "MC10141" H 10790 5650 60  0000 C CNN
F 2 "" H 10750 6250 60  0000 C CNN
F 3 "" H 10750 6250 60  0000 C CNN
	1    10750 6250
	1    0    0    -1  
$EndComp
Text HLabel 11450 5900 2    60   Input ~ 0
mq.[n+0]
Text HLabel 11450 6000 2    60   Input ~ 0
mq.[n+1]
Text HLabel 11450 6100 2    60   Input ~ 0
mq.[n+2]
Wire Wire Line
	11350 5900 11450 5900
Wire Wire Line
	11350 6000 11450 6000
Wire Wire Line
	11350 6100 11450 6100
NoConn ~ 11350 6200
Text HLabel 10050 5800 0    60   Input ~ 0
mqm.[n+1]
Wire Wire Line
	10050 5800 10150 5800
Text HLabel 10050 5900 0    60   Input ~ 0
mqm.[n+0]
Text HLabel 10050 6000 0    60   Input ~ 0
mqm.[n+1]
Text HLabel 10050 6100 0    60   Input ~ 0
mqm.[n+2]
Text HLabel 10050 6200 0    60   Input ~ 0
mqm.[n+3]
Text HLabel 10050 6300 0    60   Input ~ 0
mq.[n+4]
Text HLabel 10100 6500 0    60   Input ~ 0
dp04-clk
Wire Wire Line
	10050 5900 10150 5900
Wire Wire Line
	10050 6000 10150 6000
Wire Wire Line
	10050 6100 10150 6100
Wire Wire Line
	10050 6200 10150 6200
Wire Wire Line
	10050 6300 10150 6300
Wire Wire Line
	10100 6500 12300 6500
Text HLabel 10100 6600 0    60   Input ~ 0
ctl-mq-sel-1
Text HLabel 10100 6700 0    60   Input ~ 0
ctl-mq-sel-2
Wire Wire Line
	10100 6600 12300 6600
Wire Wire Line
	10100 6700 12300 6700
$Comp
L MC10141 e15
U 1 1 57AD1768
P 12900 6250
AR Path="/57B68864/57B6B9B0/57AD1768" Ref="e15"  Part="1" 
AR Path="/57B6D511/57B6B9B0/57AD1768" Ref="e?"  Part="1" 
F 0 "e15" H 12920 6850 60  0000 C CNN
F 1 "MC10141" H 12940 5650 60  0000 C CNN
F 2 "" H 12900 6250 60  0000 C CNN
F 3 "" H 12900 6250 60  0000 C CNN
	1    12900 6250
	1    0    0    -1  
$EndComp
Text HLabel 13600 6000 2    60   Input ~ 0
mq.[n+3]
Text HLabel 13600 6100 2    60   Input ~ 0
mq.[n+4]
Wire Wire Line
	13500 6000 13600 6000
Wire Wire Line
	13500 6100 13600 6100
Text HLabel 12200 5800 0    60   Input ~ 0
mqm.[n+3]
Wire Wire Line
	12200 5800 12300 5800
Text HLabel 12200 5900 0    60   Input ~ 0
mqm.[n+2]
Text HLabel 12200 6000 0    60   Input ~ 0
mqm.[n+3]
Text HLabel 12200 6100 0    60   Input ~ 0
mqm.[n+4]
Text HLabel 12200 6200 0    60   Input ~ 0
mqm.[n+5]
Wire Wire Line
	12200 5900 12300 5900
Wire Wire Line
	12200 6000 12300 6000
Wire Wire Line
	12200 6100 12300 6100
Wire Wire Line
	12200 6200 12300 6200
Connection ~ 10150 6500
Connection ~ 10150 6600
Connection ~ 10150 6700
NoConn ~ 13500 5900
Text HLabel 13600 6200 2    60   Input ~ 0
mq.[n+5]
Wire Wire Line
	13500 6200 13600 6200
Text HLabel 12200 6300 0    60   Input ~ 0
[n/30+1,mq.[n+6],ad-cry-02]
Wire Wire Line
	12200 6300 12300 6300
$EndSCHEMATC
