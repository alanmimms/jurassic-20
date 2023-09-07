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

