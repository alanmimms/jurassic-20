# KLINIT and PARSER functions in RSX-20F (klinit.l20 and parser.lst)
  * Zero AC blocks 0 through 6
  * Load AC blocks with instructions and starts KL
  * Load CRAM and DRAM
  * Configures and sweeps the cache
  * Configures the memory
  * Starts the clock
  * Does resets
  * Reads and writes KL memory
  * Diagnostic read, write, execute functions
  * Set and clear the RUN flop
  * Set the CONTINUE "button"
  * Reset APR, PI, clear paging, user base
  * Enable CRAM, DRAM, FS, AR/ARX parity
  
## LCBDRM function ("process D-RAM record")

From `klx.no-formfeeds.listing`. Yep.
```
	; 2295	;	The J field is the starting location of the microroutine to
	; 2296	;	execute the instruction.  Note that the 40 and 20 bits must
	; 2297	;	always be zero.  Also, even-odd pairs of DRAM J fields may
	; 2298	;	differ only in the low order three bits.  (Someone thought he
	; 2299	;	was being very clever when he designed the machine this way.
	; 2300	;	It probably reduced our transfer cost by at least five dollars,
	; 2301	;	after all, and the microcode pain that occurred later didn't cost
	; 2302	;	anything, in theory.)
```

* From `klx.no-formfeeds.listing`:
```
    ; 9019	; BITS 10-12 OF INSTRUCTION GET MAPPED TO IR 7-9 FOR I/O INSTRUCTIONS
    ; 9020	; THE DEVICE ADDRESS IS BROKEN DOWN AS ONE OF THE FIRST 7, OR ALL OTHERS
```

* Note: DRAM address is 8 bits of IR opcode to address an even/odd
  pair in EBUS[0:8], plus a ninth bit derived from the LSB of the
  address in EBUS[12].
* R3 points to DRAM word from file.
* `DCBADR` address for DRAM word from file.
* `.DRSW` - if nonzero, verify.
* Flow
  * Read three words from `KLX.RAM` file to `DECADR`.
  * Call `$WDRAM` to write DRAM word pointed to by R1 to DRAM address in R0.
    * Does nothing for odd address
	* If even, writes both even and odd.
	* Call $ADRAM to set address in DRAM to write to (R0).

	* Based on PDF128, when INSTR 7XX H is high the DRAM address is
      {IR[00:02], IR[07:09] | ~{3{IR[3:6] == '0}}, IR[10:12]}.			(PDF128)
	* INSTR 7XX H is IR00 & IR01 & IR02 & IR EN I/O, JRST H				(PDF128)
	* IR EN I/O, JRST H is disabled by diag func 065 DISIOJ and
      enabled by diag func 067 ENIOJA.									(PDF130)
	  
```
			MOV	#DFDABF+2,R4
			MOV	#DFDABF,R3		;GET ADR OF EBUS DATA
			MOV	R0,R2			;Nine bits: adr[0:8]: DRAM ADR IN R2
			COM	R0				;READY TO TEST ADR BITS 0-2
			BIT	#700,R0			;TESTING!
			BEQ	10$				;BR IF ADR IS 7XX
			ASL	R2
			ASL	R2
			ASL	R2				;R2=adr[0:8]<<3: LEFT SHIFT 3 POSITIONS
			CLRB (R4)+			;R4=DFDABF+2: INCREMENT TO DFDABF+3									End: R4=DFDABF+3
			MOVB R2,(R4)+		;R4=DFDABF+3: DFDABF+3 <= adr[4:8]: MOVE ADR BITS 4-8 TO EBUS DATA	End: R4=DFDABF+4
			SWAB R2
			MOVB R2,@R4			;DFDABF+4 <= adr[0:3]: MOVE ADR BITS 0-3 TO EBUS DATA
			BR	40$

	10$:	ROR	R2				;7XX: R4=DFDABF+2: (test adr LSB) BIT1 TO C-BIT					End: R4=DFDABF+2
			BCS	20$				;7XX: R4=DFDABF+2: C BIT SET MEANS IR BIT 12 MUST BE 1			End: R4=DFDABF+2

			CLRB (R4)+			;7XX: R4=DFDABF+2: NO C-BIT MEANS IR BIT 12 MUST BE 0			End: R4=DFDABF+3
			BR 30$				;7XX: R4=DFDABF+3: MOVE ADR TO EBUS DATA						End: R4=DFDABF+3

	20$:	MOVB #200,(R4)+		;7XX: R4=DFDABF+3: SET IR BIT 12=1								End: R4=DFDABF+3

	30$:	BIC	#340,R2			;7XX: R2=(adr>>1)&037		ZZZ3.4567							End: R4=DFDABF+3
			MOVB R2,(R4)+		;7XX: DFDABF+3 <= adr[3:7]: MOVE D-RAM ADR TO EBUS BIT POSITION 7-11	End: R4=DFDABF+4
			MOVB #16,@R4		;7XX: DFDABF+4 <= 016: SET THE 7 FROM 7XX IN EBUS DATA			End: R4=DFDABF+4

	40$:	CALL $KLSR			;DO A SOFT RESET
			BCS	50$

			MOV	#DFDABF,R1		;EBUS DATA ADR
			MOV	#.LDAR,R0		;LOAD THE AR FROM EBUS 0-35
			CALL $DFWR			;DO THE ACTUAL WRITE
			BCS	50$

			MOV	#.IRLTC,R0		;UNLATCH IR AND LOAD IT FROM AD
			CALLR $DFXC			;EXECUTE IT

	50$:	RETURN
```

## DRAM mapping analysis from `klx.no-formfeeds.listing`

	klx.ram record (lowercase is even, uppercase is odd, C is common J):
               j     J
	D 000: 10002 11005 00010
	D 000: 10002 11005 00010
	D 002: 10405 10045 00010
	D 004: 11006 13045 00010
	D 006: 12445 12005 00010
	D 010: 10450 12050 00010
	D 012: 10411 10051 00010
	D 014: 10412 10052 00010
	D 016: 11012 11452 00010

	D 240: 00054 00015 00014
	D 242: 00052 00013 00014
	D 244: 00016 00057 00014
	D 246: 00044 10002 00010

or in binary (for 000):
              j08 j09 j10               J08 J09 J10     x C00 C01 C02 C03 C04
       1   0   0   0   2         1   1   0   0   5      0  0   0   0   1   0
    0.001.000.000.000.010     0.001.001.000.000.101     0.000.000.000.001.000

	klx.ram listing for these two words:
        ABxx JJJJ
```
D 0000, 2000,1002				; 4916	000:	EA,		J/UUO
D 0001, 2200,1005				; 8117	001:	EA,	SJCL,	J/L-CMS		;CMSX HIDDEN BENEATH LUUO
D 0002, 2100,1005				; 8118			EA,	SJCE,	J/L-CMS
D 0003, 2001,1005				; 8119			EA,	SJCLE,	J/L-CMS
								; 8120	
D 0004, 2200,1006				; 8121	004:	EA,	B/2,	J/L-EDIT	;EDIT
D 0005, 2601,1005				; 8122			EA,	SJCGE,	J/L-CMS
D 0006, 2501,1005				; 8123			EA,	SJCN,	J/L-CMS
D 0007, 2400,1005				; 8124			EA,	SJCG,	J/L-CMS
								; 8125	
D 0010, 2101,1010				; 8126	010:	EA,	B/1,	J/L-DBIN	;CVTDBO
D 0011, 2401,1010				; 8127			EA,	B/4,	J/L-DBIN	;CVTDBT
D 0012, 2100,1011				; 8128			EA,	B/1,	J/L-BDEC	;CVTBDO
D 0013, 2001,1011				; 8129			EA,	B/0,	J/L-BDEC	;CVTBDT
								; 8130	
D 0014, 2100,1012				; 8131	014:	EA,	B/1,	J/L-MVS		;MOVSO
D 0015, 2001,1012				; 8132			EA,	B/0,	J/L-MVS		;MOVST
D 0016, 2200,1012				; 8133			EA,	B/2,	J/L-MVS		;MOVSLJ
D 0017, 2301,1012				; 8134			EA,	B/3,	J/L-MVS		;MOVSRJ


D 0240, 0001,1414				; 5155	240:	I,		J/ASH		;ASH [423]
D 0241, 0000,1415				; 5156			I,		J/ROT		;ROT
D 0242, 0001,1412				; 5157			I,		J/LSH		;LSH
D 0243, 0000,1413				; 5158			I,		J/JFFO		;JFFO
D 0244, 0000,1416				; 5159			I,		J/ASHC		;ASHC [423]
D 0245, 0001,1417				; 5160			I,		J/ROTC		;ROTC
D 0246, 0001,1004				; 5161			I,		J/LSHC		;LSHC--Adjoins UUO (247)
```


# EBUS
  * The front end can read/write DS00-06 any time.
    * See EK-DTE20-UD-003 p. 18.
  * `DIAG_STROBE` indicates DS00-06 lines are stable.
  * DFUNC ("remove status") assertion
    * KL relenquishes control of EBUS DS lines
    * Puts EBUS translator for DS lines under DB00/DB01 control.


# Documentation Pointers

* The KLX.RAM file is ASCII formatted according to the description in
  `doc/convert.txt` sections 3.0 and 6.0.

* DTE20 is where the 10/11 interface lives
  * Documented in `EK-DTE20-UD-003_Oct76.pdf`.
  * Also from SAIL in ETHDES.txt.

* EBOX/MBUS interface is shown in
  * `EK-OKL10-TM_KL10_TechRef_Aug84_text.pdf` starting on p.48

* EBUS in `EK-OKL10-TM_KL10_TechRef_Aug84_text.pdf` starting on p.81

* RP07 registers `EK-OKL10-MG-004_KL10_Maintenance_Guide_Update_Jun86_text.pdf` p.98

* Diagnostic commands p. 71
  `EK-OKL10-MG-003_KL10_Maintenance_Guide_Volume_1_Rev_3_Apr85_text.pdf`
  * KL10PV diagnostic read commands numerically p.98, alphabetically p.108

* KL CPU module utilitization charts p.383
  `EK-OKL10-MG-003_KL10_Maintenance_Guide_Volume_1_Rev_3_Apr85_text.pdf`

* Module B compatibility and versions p.306 `LCG_GoodStuffNewsletters-OCR.pdf`

* KLAD20 for KL10-PV is tape BB-F287M-D1.
  * Superseded July'81 by BB-E543Q-DD@1600, AP-E542Q-DD@800.
    
* CONVRT.EXE is documented p.353 `LCG_GoodStuffNewsletters-OCR.pdf`

* TOPS20 V7 documents at http://bitsavers.trailing-edge.com/pdf/dec/pdp10/TOPS20/V7/

# Memory transaction timing
* Can be found in LCG_GoodStuffNewsletters-OCD.pdf p.520
* Barely legible

# Clock timing
* From LCG_GoodStuffNewsletters.pdf p.42

    |                            KL10-PV                                |
    | ================================================================  |
    | MBOX     | 33.3ns | MB00 H, MB06 H, MB12 H, MBZ H, MBX H, MBC H,  |
    |          |        | CSH H, PMA H, PI H, CLK H, MTR H              |
    | CHANNELS | 33.3ns | CHC H, CRC H, CCL H, CCW H                    |
    | CACHE    | 33.3ns | CHX H                                         |
    | EBOX     | 66.6ns to 166.5ns (_TIME field) | APR H, CON H, VMA H, |
    |          |                                 | EDP {00,06,12,18,24,30} H |
    |          |                                 | CRM {00,04,08,12,16} H |
    |          |                                 | MCL H, IR H, SCD H   |
    | DTE      | 66.6ns  | EBUS 10/11 CLK {08,09,10,11} L               |
    | EBUS     | 133.2ns | CLK 0[0-7] L, CLK 15L |
    | SBUS     | 133.2ns | CLK INT L, CLK EXT L  |

