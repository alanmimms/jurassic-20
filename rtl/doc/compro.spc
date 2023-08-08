.nofill
.right margin 63

+---------------+
! d i g i t a l !   I N T E R O F F I C E  M E M O R A N D U M
+---------------+

TO: KL10 List
.title TO:  KL10 List

                                        DATE: 30 Apr 75

                                        FROM: R. McLean

                                        DEPT: KL Programming

                                        LOC:  MR1-2  EXT: 6113

                                        FILE: [DOC-FRO-END]
                                               COMPR4.SPC

                                        PDM#: 200-205-007-04

SUBJ: The -10/-11 Communication Area and Protocol
.subtitle SUBJ:  The -10/-11 Communication Area and Protocol
.fill



This is a revision of Paul Dunn's memo dated 27 June 74, and of R. 
Nelson's dated 8 October 74.

1.  INTRODUCTION

The function of the -10/-11 communication area and protocol is to
allow the Front End (PDP-11/40) and the KL10 to carry on the
business of timesharing, bootstrapping, diagnostics, etc.  in a
reasonably   consistent   and   efficient   manner  without  an
overwhelming  burden  on  core   space   or   processor   time.
Additionally,  it  is  desirable  to  protect,  as  much  as is
reasonable, one processor from mistakes of the other.

The -10/-11 communication area will be maintained in -10 memory
and  the  actual  communication  will be effected by use of the
DTE20 and the KL10  micro-code.   the  KL10  will  set  up  the
communication  areas  initially  and  each  processor  will  be
responsible for protecting itself from the other.

There  will  be  a  single  communication  region   which   all
processors in the system can access through protected examines.
Within this, there will be a communication area associated with
each   processor;   this  sub-area  will  be  "owned"  by  that
processor and it alone will have write access to this area.  A
processor's communication area will be used to reflect to other
processors what its hardware/software state is and  to  control
all communication between them and itself.

During time sharing, in the 20-series, most of  the  information
passing  between  the  KL10  and  the  PDP-11  will  be through
processing queues.  a to-11 queue will  be  maintained  in  -10
memory  by  the monitor.  The -11 will access this queue by use
of the byte-transfer mode of the DTE20.  The to-10  queue  will
be kept in -11 memory and accessed by the -10 in a like manner.
The processing queues will not be  part  of  the  communication
areas   and   should   be   accessed  only  through  the  DTE20
byte-transfer  capabilities.   This  will  protect  them   from
modification  by  any processor other than the one constructing
them.

In the 1080 queue processing will not be supported.  One  "CTY"
will be supported directly through the communications area.  In
addition, commands may be passed from either processor  to  the
other  in  the  communications  area.  This command protocol is
mutually exclusive with queue processing.

There is a secondary non-queued protocol, to be used in both the 
1080 and -20 series by the bootstrap and EDDT, so that the -10 can 
use the CTY without setting up or disturbing the Communications 
Region.  Communication will be directly via the EPT.  This 
secondary protocol may be used only by an unrestricted front end, 
and requires unprotected examines and deposits.


2.  GOALS


2.1 The protocol should minimize overhead.  The resources whose
overhead  was  to be minimized were considered in the following
order:
.nofill

        KL10 Processor          (most important) 
        PDP-11 Processor
        Micro-code
        EBUS                    (least important)
.fill


2.2 To as great an extent as possible, each processor (and  its
memory)  should  be  protected from all other processors.  This
protection should be extensive  enough  to  provide  sufficient
security to give us a highly reliable interface.


2.3 Turnaround through this protocol must  be  fast  enough  to
allow -10 code to do the echoing of teletype characters.


2.4 The protocol must be  extensible  in  the  sense  that  new
functions,  new  peripherals, and new capabilities can be added
with relative ease.


2.5 The  protocol  must  allow  a  very  simple  mechanism  for
communication with at least one terminal (CTY).


2.6 It should be possible to implement the protocol without any
major restructuring in either VIROS or TOPS10.


2.7 The protocol should be  designed  so  as  to  minimize  the
shuffling  of  data from one place in memory to another in both
the KL10 and the PDP-11.


2.8 The  communication  area  and  protocol  should  be  easily
expandable  in  a  compatible  way and both the -10 and the -11
should be able to recognize and be able to  work  with  (though
not necessarily fully) older versions.


2.9 The protocol should be able to recognize and  recover  from
hardware  and  software  errors related to the interface.  This
will  not  always  be  possible  since  some  errors  will   be
undetected and/or unrecoverable (without effect to the system).


2.10 The protocol should  match  the  terminal  performance  of
existing  -10 Front Ends (e.g.  DC76) in at least the following
areas:


2.10.1 Throughput - this will become critical with the  current
increase in the number of high speed terminals.


2.10.2 Control - the -10 should have at least all  the  control
it currently has of terminals.


2.10.3 Echo speed - under the current design, the  -10  may  be
required to handle echoing for a large number of terminals;  it
should be able to do this quickly enough to be satisfactory  to
the terminal user.


2.10.4 Processor time - the CPU time required  to  input/output
an  average  character.  This should be much better for output,
since the monitor typically will give the PDP-11  a  string  of
characters to be output on a particular terminal.


2.11 The -10 should be able to run  any  device  (but  not  all
devices  simultaneously)  at the maximum operation speed of the
device.


2.12 The protocol should be easily  extendable  to  allow  more
control functions for terminals (and other devices) to be moved
into the -11.  This would include echoing,  time  delays,  etc.
even  to  the point of moving all knowledge of terminals out of
the -10.  Other devices which could be controlled  in  the  -11
are sychronous lines and printers.


2.13  In the 20 series monitors the non-queue'd protocol will not be 
used.  This will permit the space to be reclaimed and put to better 
use since the queue'd protocol is much more efficient.

2.14  The -11's communication area will not be protected from the 
-10 due to core limitations.  The only way to provide a -10 region 
to which the -10 has both read and write access and an -11 region to 
which the -10 has only read access is to put these regions on 
different physical and resident pages.  The overhead to achieve this 
is very high.

The most efficient way to move large amounts  of  data  between
the  -10  and  the  -11  is the byte-transfer capability of the
DTE20.  Therefore the -10/-11 communication protocol  has  been
designed   to  do  most  of  its  data  transfers  using  DTE20
byte-transfer operations.  In the 1080, there will  be  smaller
amounts of data transferred, and the non-queued protocol can be
used.  Information to be passed from one processor  to  another
will  be  stored  in variable length queues by the constructing
processor, and accessed by  the  other  processor  through  the
DTE20  byte-transfer  mode.   The  DTE20  hardware  design  and
operation is such that a  byte-transfer  operation,  in  either
direction, requires the cooperation of both processors in order
to execute the transfer correctly.  For example, to  perform  a
byte-transfer  from  the -11 to the -10, the following setup is
necessary:

    a.  The -11 must set the DTE20 register TO10AD to  the  -11
        address of the information to be transferred.

    b.  The -11 must also specify how the data is stored in -11
        memory:  8 bit bytes or 16 bit words.

    c.  The -10 must set the EPT word EPTTBP to a byte  pointer
        pointing to where the data is to be stored.

    d.  The -10 must also set the DTE20 register TO10BC to  the
        number of bytes it wishes to transfer.

In order to facilitate  these  transfers,  Communication  Areas
will  be  set  up  in -10 memory to allow the two processors to
agree on what each is doing.

3.  COMMUNICATION AREAS

Associated with each DTE20 will  be  a  pair  of  communication
areas;   an  -11  owned communication area to which the -11 has
read/write access but to which the -10 ideally has only read access and
a  similar  -10  owned communication area.  The access to these
communication areas is controlled by a combination of convention  
and hardware.  The -11's  write  access  will  be
limited  by  the Deposit Protection/Relocation word in the EPT;
the -10's by being in a "read only" page.  (ref 10.2) The to-11
queue need not be in the -11's communication area, since access
to it will be through the byte-transfer  mechanism.   Also  the
-11 is fully protected from the -10 through the hardware;  with
the to-10  queue  in  -11  memory  -  accessible  only  through
byte-transfer.  (ref 10.3 & 10.7)

Each  processor  will  have   read   access   to   the   entire
communication  region.   Since  examines cannot be made through
the Deposit Protection/Relocation  word,  each  processor  must
have  a  way  to  locate  its  Deposit area with respect to its
Examine region and hence to identify itself.  This is  done  by
extending  each  processor's read access by N words at the base
of the communication region, where N is  the  processor  number
plus 1.  The first word in each processor's Examine region will
contain its processor number and the offset to its deposit area
from word 0 of the communication region.  Word -N of the 
communication region contains:

BITS            SYMBOL          FUNCTION

0-3             0               Must be 0

4-11            PRONUM          Processor number  (N-1)  of  this
                                processor

13-35           DEPAD           Offset   of   this    processor's
                                communications  area  relative to
                                word  0  of   the   communication
                                region

All pointers and addresses in the whole  communications  region
are given relative to word 0 of the communications region.

Note:  Although each DTE20 will have a  pair  of  communication
areas  associated  with  it,  a -10 owned area and an -11 owned
area, these areas may not be unique.  A  configuration  of  two
front ends with a single KL10 would have two DTE20s linking the
processors but only three communication areas -  one  for  each
processor.  (ref 10.4)

It seems desirable that each  processor  have  a  communication
area  associated  with  other  processors  to  which  it is not
directly connected through a DTE20.  This situation could occur
in  a  configuration  with  multiple front ends and/or multiple
KL10  processors.   This  possibility  will  not  be  discussed
further  at  this  time  but  it  is  believed we have reserved
sufficient hooks and space to allow future expansion to  larger
configurations.

The first sixteen words in a communication area are devoted  to
containing  identifying and status information of the processor
owning it.  Then, for every  processor  with  which  it  is  in
communication (initially only one), there will be an additional
sixteen  words  of  communication  status   information.    The
communication  area  for  a simple system, one -11 and one -10,
would be as follows:

Note:  The size and position of all fields as well as the  size
of  the communication area are subject to change prior to first
release  of  the   protocol   to   accommodate   implementation
decisions.

Each processor's communication area contains:

BITS            SYMBOL          FUNCTION

Word 0          PIDENT          processor identification word

0               TENIND          ten processor indicator - set  to
                                1 if this area belongs to a-10

1-3             COMVER          communication area version 
                                number

4-11            PROVER          communication  protocol   version
                                number

12-16           NUMPRO          number of processors  represented
                                in this area

17-19           COMASZ          size of this block  in  multiples
                                of 8

20-35           PRONAM          the  name  of  the  processor   -
                                possibly a serial #

Word 1          CHNPNT          a pointer  to  the  communication
                                area of the next processor - this
                                will be a circular list

Word 2

0               CYCLES          bit  is  a  one   (1)   if   this
                                processor   believes   the   line
                                frequency is 50 cycles

Note:  Words 3 and 4 are not used for queue'd protocol

Word 3          TOD             Time of Day in the following format

0                               Always 1

1-5                             Hours

6-11                            Minutes

12-19                           Seconds

20-35                           1/1000th of a second

Word 4          DATE            Day since start of Smithsonian 
                                astrophysical time base (Nov 1, 
                                1858).  This is always provided by 
                                the -10.  The -11 will update it at 
                                midnight but will never pretend to 
                                understand it.


WORD            INFORMATION

5               keep  alive counter (bits 28-35).  Should be 
                incremented at least once per minute.

Words 6-17 Processor Status Words:  Contains status information 
concerning this processor.  This information has not been fully 
defined yet.  Presented is an example of what a -10 might put here:

Note:  The information stored here will be used by other processors 
in determining if this processor is running properly.  It is not 
meant to provide a means of monitoring the functioning of the owning 
processor.

6               PC + PC flags - possibly the  result  of  a  JSR
                used  to  enter  the  highest priority interrupt
                routine which is entered at least several  dozen
                times a second.

7               result of CONI PI,

10              result of CONI PAG,

11              result of DATAI PAG,

12              result of CONI APR,

13              result of DATAI APR,

14              Start Address of PDP-10 diagnostics

15              Start Address of EDDT

16              Start Address of 10-loader

17              Start Address of 10-monitor

BITS            SYMBOL          FUNCTION

Word 20         FORPRO          For Processor Identification Word
                                -  the  processor  with  which we
                                will   communicate   using    the
                                current block.

0               TENIND          Ten Processor Indicator - set  to
                                1  if  this block will be used to
                                communicate to a -10 processor.

1               DTEIND          DTE20 Connection Indicator -  set
                                to   1   if   there  is  a  DTE20
                                connection   between   the    two
                                processors  communicating through
                                this block of COMPSZ*8 words.

2-3             DTENUM          a DTE20 number if bit 1 is set

4-16                            Unassigned

17-19           COMPSZ          size of this communication  block
                                in multiples of 8

20-35           PRONUM          the  number  of  a  processor  to
                                which it will communicate through
                                the block

Word 21         PROPNT          a pointer  to  the  communication
                                area  of the processor associated
                                with this  block - currently  the
                                only   other   processor  in  the
                                system

Word 22         STATUS          Communication Status Word

0               POWERF          Power Fail Indicator - set  to  1
                                if this (the owning) processor is
                                losing power

1               LOAD11          Load -11 Code Indicator - if  set
                                to 1.  -11 wants to be reloaded.

2               RESCOM          used in non-queued protocol.  
                                Reserved for future use by queued 
                                protocol.

3               DTETST          used to check for valid examine -
                                must be one.  This bit is checked 
                                after every examine/deposit of the 
                                communications region.  If the -11 
                                finds it to be a 0 the -11 will 
                                revert to secondary protocol.  If 
                                the -10 finds this to be a 0 then 
                                it assmes the -10 has crashed.  The 
                                -10 clears thisbit by clearing the 
                                examine/deposit words in the EPT.  
                                This causes the DTE20 hardware to 
                                return all zeroes on all examines.

4               CTYIUF          CTY in use indicator - if set  to
                                1 (see bit 5)

5               CTYIUN          CTY in use number

6-11                            Reserved

12                              Reserved

13              QPIU            Queue'd protocol in use - set to 1 
                                if queue'd protocol is being used


14-18                           Reserved

19              TOIT            Processor is transferring queue 
                                entries if 1

20-27           TO10IC          TO-10 interrupt count - as follows:

                                A count of the doorbell interrupts 
                                sent to the 10.  This will be 
                                incremented once for each doorbell 
                                sent to the 10 to insure that the 10 
                                has not missed a doorbell and 
                                therefore failed to notice a status 
                                change in the -11

28-35           TO11IC          To-11  interrupt count - a count of 
                                the doorbell interrupts sent to the 
                                -11.  This will be incremented once 
                                for each doorbell sent to the -11 to 
                                insure that the -11 has not missed a 
                                doorbell and therefore failed to 
                                notice a status change in the -10.

Word 23         QSIZE           Queue Size Word

0-19                            not used - guaranteed to be 
                                zero

20-35                           number of 8 bit bytes written into the
                                current queue by the transmitting
                                processor    (PIDENT)    to    be
                                transmitted   to   the  receiving
                                processor (FORPRO)

Word 24         CTY0CW          CTY #0 Command Word

Note:  For queued protocol:  words 24-27 unassigned and this is the 
end of the region.

Note:  It is intended that any programs other than  EDDT  which
require use of the CTY facility will use CTY #0.

0-3             CTY0CN          Command Number

4-11                            unassigned - must be zero

12-19           CTY0CC          Command Code - as follows:


COMMAND                 SENDING PROCESSOR       ACCEPTABLE RESP
.nofill

0-Idling                        Either          0-Idling

1-Enable CTY                    10              1-I/O Done int.
  I/O done interrupt                             enable

2-Disable CTY                   10              2-I/O Done int.
  I/O Done Int.                                  disabled

3-Output a Character            10              3-Character
  Character in 20-35                             accepted

                                                4-Character not
                                                 accepted
                                                 (overflow)

4-Input a character and         10              5-here is
  time out if none rec'd                         character
                                                 (char. in 
                                                 20-35)

                                                6-Timeout

5-Test for input character      10              5-
  ready

                                                7-No data
                                                 available

6-Input done Interrupt          11              10-Input int.
  Character in 20-35                             rec'd -
                                                 character taken

                                                11-Input int. 
                                                 rec'd
                                                 character not
                                                 taken

7-Output done interrupt         11              12-Output int. 
                                                 rec'd.

                                                20-Command 
                                                 illegal
.fill

20-35           CTY0CD          command data (or zero)

Word 25         CTY0RW          CTY #0 Response Word

0-3             CTY0RN          Response number (as obtained from
                                CTY0CN)

4-11                            unassigned - must be zero

12-19           CTY0RC          Response Code - see command codes
                                for values

20-35           CTY0RD          response data (or zero)

Words 26 and 27 -       Reserved

Word 30         MISCW           Miscellaneous Command Word for
                                non-queue protocol

0-3             MISCN           Command Number

4-11                            unassigned-must be zero

12-19           MISCC           Command Code - as follows:

.nofill

COMMAND         SENDING PROCESSOR       ACCEPTABLE RESPONSE

0 Idling              Either            0  Idling

3 Initialize Time of Day 10             3 TOD initialized

                                        4 TOD invalid in
                                         -10's Com. region

4  Request Time of Day   Either         5 TOD correct in
   and Date                              responding processor's
                                         comm. area.

                                        12 TOD Unavailable

                                        20 illegal command
.fill

Word 31         MISRW           Miscellaneous Response Word

0-3             MISRN           Response Number (as obtained from
                                MISCN)

4-11                            unassigned - must be 0

12-19           MISRC           Response Code - see command codes
                                for values

20-35           MISRD           Response Data or 0

Word 32         DATCW           36 bits of  data  sent  to  other
                                processor  as  part of non-queued
                                miscellaneous command.

Word 33         DATRW           36 bits of data sent as  part  of
                                misc.  response


.fill
4.  INITIALIZATION

During the bootstrap process, after  the  -11  has  loaded  the
bootstrap  code into -10 memory and started it running, the -11
will wait for the -10 to start communicating.  (If the -10  had
decided  to  re-boot  itself,  it would first reset the -10/-11
communication which would bring us to the same point.) 

Initial communication is via a "secondary protocol" which is 
independent of the Communications Region.  This secondary protocol 
will be used for booting the system and also will come into use any 
time the -10 clears its Examine Relocation and Protection words.  
All commands, data, and responses are via the EPT.  Unprotected 
examines and deposits must be done by the -11; hence, only a 
privileged Front End may use this protocol.

More specifically we have the following setup:


4.1 EPT

    1.  To-10 byte pointer:  EPTTBP = buffer area.  

        The -10 will later set the to-10 byte  count  -  (DATAO
        DTEX,  TO10BC)  which  will  cause part of -11 resident
        To-10 queue to be moved into the buffer area.

    2.  To-11 byte pointer:  EPTEBP = to-11 
        queue.

        Once the -10 has set this, the  -11  will  be  able  to
        successfully read the To-11 queue.

    3.  DTE20 interrupt instruction - 
        EPTDII

        This must be an instruction which transfers control  to
        the DTE20 interrupt routine.

    4.  Deposit protection and relocation words - EPTDPW and EPTDRW
        = the -11 communication area.

        This will allow the -11  to  access  its  communication
        area through protected deposits.

    5.  Examine Protection and Relocation words  -  EPTEPW  and
        EPTERW.   These  will  allow the -11 to identify itself
        and to access the entire communication region.

    6.  Secondary Protocol Words - Transmit Commands from the -10 to 
        the -11 and acknowledgements and I/O status from the -11 to 
        the -10.
.nofill

        DTEFLG=444              ;OPERATION COMPLETE FLAG
                                ; SET ON COMMAND COMPLETE

        DTEF11=450              ;CHARACTER FROM CTY TO 10

        DTECMD=451              ;PDP-10 to PDP-11 COMMAND WORD
                                ; PDP-10 RINGS PDP-11 DOORBELL

        DTEMTD=455              ;CTY OUTPUT COMPLETE FLAG
                                ; PDP-11 RINGS PDP-10 DOORBELL

        DTEMTI=456              ;CTY INPUT FLAG PDP-11 RINGS
                                ; PDP-10 DOORGELL
.fill

Command Codes used in DTECMD:

Command Word Format: Command Code (4 bits), TTY output byte (8 bits) 
right justified IN PDP-10 word

Command Code 10 - CTY output, low byte is ASCII char

Command Code 11 - Monitor Mode control on (use secondary protocol)

Command Code 12 - Monitor Mode Control off (use primary protocol)


4.2 The Communication Areas

    1.  The areas must be set up as described in  the  previous
        section and linked together.

    2.  The -11 should be set initially in an idling state with
        an empty queue, no CTY running, etc.


4.3 Page Maps

The -10 must assure that the memory used for the  communication
areas  is permanently dedicated to that function.  It must also
assure that while a queue is in use it cannot  be  swapped  out
(i.e.   that  the memory be dedicated at least for the duration
of the life of that queue).  All the Communications Areas,  the
To-11  queue, and the buffer into which the To-10 queue will be
read, must all be mapped in exec virtual  address  space.   The
page  map should be set up so that -10's communication area and
the To-11 queue and the buffer into which the To-10 queue  will
be  read  are all writable by -10 monitor.  After having set up
the -11's communication area as described above, the  page  map
should  be  modified  so  that  the  page  containing the -11's
communication area is a read-only page.

4.4 Initial State

Before the -10 has set up the Communications Region, it can 
communicate with the -11 by means of the secondary protocol.

The sole flag for which protocol is in use will be the examine 
relocation/protection word in the 10's EPT.  When this is cleared, 
the secondary protocol is used.  The -11 can ascertain the state of 
this flag without using unprotected examines by examining the DTETST 
word and making sure the valid examine bit is 1.  If this bit is 
zero, either the examine EPT word is not set up or the 
Communications Region is not set up correctly.  In either case, it 
is desirable to switch to the secondary protocol.  It is the -10's 
responsbility tio clear the examine EPT word and ring the -11's 
doorbell if it wishes to use the secondary protocol.

When the -10 is ready to start normal processing then:

    1.  The -10 must set up its communication  area  for
        the  desired initial state (this will be described more
        fully in the next section)  -  
        queue  processing  in  the  20 series, CTY usage in the
        1080.

    2.  Change the Examine Relocation Word to point to the 
        Communication Region.

    3.  Ring the -11's doorbell.

    4.  Start using the primary protocol.


5.  COMMUNICATION STATE CHANGES

While the -11 is processing the To-11 queue,  it  is  accessing
sequential -10 memory locations.  This is a result of access by
byte-transfer.  Eventually it will reach the end of  the  queue
and  will  request  that  the  -10  set the To-11 byte pointer,
EPTEBP, to the next queue location to be  processed.   It  must
guarantee  that  the -10 has completed this before it continues
queue processing.  The -10 has a similar problem because access
to  the To-10 queue is through TO10AD in the DTE20 which is set
by the -11.

    1.  The -11 is waiting  for  the  monitor  to  start
        communicating.  It seems reasonable that it is also:

        a.  Checking that the -10 is still
            running

        b.  doing whatever it can for users who  are  trying
            to come in

        c.  timing the bootstrap run time to make sure it is
            not too long, etc.

    2.  Meanwhile the -10 is  setting  up  the  EPT  and
        mapping the communication areas to look like this:

-11 Communication Area  -  pointed  to  and  protected  by  the
DEPOSIT  Protection AND Relocation word in the EPT:  EPTDRW AND
EPTDPW


WORD    SYMBOL  VALUE

0       PIDENT  TENIND = 0, COMVER = 0, PROVER = 0, NUMPRO = 1, 
                COMASZ = 2, PRONAM = 0

1       CHNPNT  ?  (= -10 communication area

2-17            0:   this  will  contain   status information about
                the -11

20      FORPRO  TENIND = 1, DTEIND = 1, DTENUM = 0, COMPSZ = 1, 
                PRONAM = 1

21      PROPNT  ?  (= -10 communication area)

22      STATUS  DTETST = 1:  idling

23-27           0  there  is   no   communication currently in
                progress, i.e.  the two processors are idling

-10 communication area - pointed to by word 1 of the -11 area

WORD    SYMBOL  VALUE

0       PIDENT  TENIND = 1, COMVER = 0, PROVER = 0, NUMPR0 = 1,
                COMASZ = 2, PRONAM = 1

1       CHNPNT  ?  (= -11 communication area)

2       CYCLES  should be set to indicate the  line  frequency
                as determined by the -10.

3-12            0:  the -10 will  put  its  status  information
                here as it runs

14-17           Starting addresses of  monitor,  loader,  EDDT,
                diagnostics, 

20      FORPRO  TENIND = 0, DTEIND = 1, DTENUM = 0, COMPSZ = 1,
                PRONAM = 0.

21      PROPNT  ?  (= -11 communication area)

22      STATUS  DTETST = 1:  idling

23-27           0:  there  is  no  communication  currently  in
                progress

    3.  Having  set  up  the  communication   areas   the   -10
        (20-Series)  is  now  ready to start processing.  it 
        proceeds as follows:
        proceed as follows:

        a.  Load to-11 queue

        b.  Increment to-11IC

        c.  ring the -11's 
            doorbell

    4.  The -11, upon receiving the doorbell  interrupt,  would:

        a.  Increment to-10IC and check validity

        b.  Clear doorbell

        c.  Set up the TO10AD  register  of  the  DTE20  to
            point to the To-10 queue (in PDP-11 memory)

        d.  Set up the TO11AD  register  of  the  DTE20  to
            point to some buffer area

        e.  Increment to10IC

        f.  Ring the -10's
             doorbell

    5.  The -10 will now receive  the  -11  initiated  doorbell
        and:

        a.  Verify that the -11's TO10IC is one greater than to its
            own  TO10IC.   

        b.  Set EPTEBP = To-11 

        c.  Increment its TO10IC

        d.  Clear doorbell

        e.  When there are To-10 queue entries to read, the
            -10 would set EPTTBP = some buffer area and set
            the byte count  in  the  DTE20  to  initiate  a
            transfer to -10 memory.

Generally speaking, state changes in the  communication  status
are  initiated  by  the  processor  receiving the queue and are
responded to by the processor owning the queue.  These  changes
may  go  on  independently  for each queue since the queues are
entirely separate.



7.  QUEUE ENTRY FORMATS

The following is a list of possible  queue  entries  and  their
formats.  Communication is the same in both directions although
some entries may be considered  illegal  or  meaningless  in  a
given direction.


7.1 Entries placed in either  the  To-10  or  To-11  queue  are
placed there in consecutive 8-bit bytes in the format:

        first:  a byte count - a count of all the bytes in  the
                entry  including  the  byte count.  Byte counts
                are in the range 1 to 376 (octal).

        second: a function code - a code for the function to be
                performed.  If not present, the entry is null.

        third:  a connection number - if relevant

        others: parameters for the function to be performed

A queue entry may not wrap around the queue or be split between
queues.


7.2 All  devices  will  be  referenced  by  connection  number.
Connection  numbers  for all devices will be agreed upon by the
-10 and the -11 at startup.  Thus  each  asynchronous  line  on
each  DH-11  as  well  as  each DH-11 itself will have a unique
connection  number.   Also  each  line  printer,  card  reader,
synchronous  line,  etc.   will have a unique connection number
used for communication through the  queue.   Connection  number
377 (octal) will be reserved for "all connections".


7.3 Function Codes


7.3.1 Connection Assignments 

    ASSIGN DEVICE d/UNIT m WITH PROPERTIES p(i) TO CONNECTION l

        format:  n+5,1,l,d,m,p(1), ..., p(n)

This code would be used  at  startup  to  do  all  the  initial
connection assignments.  This would probably be done by the -11
to inform the -10 what -11 peripherals existed.

.nofill
Example:        byte count              = 6
                function code           = 1
                connection number       = 103
                device                  = 4
                unit                    = 3
                properties              = 1
.fill

might be used to -

        "assign DH11 #4/line #3 with DM11-BB modem  control  to
         connection #103"


7.3.2 Data Flow

        ONE CHARACTER, c, FOR CONNECTION l

                format:  4,2,l,c

certainly used for terminal input and echoing.

        n CHARACTERS, c(i), FOR CONNECTION 1

                format:  (n+3),3,l,c(1),...,c(n)

Used for most large scale I/O  -  terminal  output,  small  LPT
outputs, synchronous line inputs, etc.

        BLOCK b CONTAINS n CHARACTERS FOR CONNECTION l 

                format:  6,4,l,b,n[2 bytes]

Used for large amounts of I/O - LPT,  CDR,  synchronous  lines,
9600  baud asynchronous lines, etc.  (The block number, b, must
be in the range 0 to 77 octal as specified in the  STATUS  word
in the communication area.)


7.3.3 Data Flow Control

        SET ALLOCATION FOR CONNECTION l TO n CHARACTERS

                format:  5,5,l,n[2 bytes]

Used  at  startup,  and  possibly  later,  to  set  the  buffer
allocation  for  a  connection  to  a known value.  This is the
number of characters a processor can  send  over  a  connection
without being told that it can send more.

        INCREMENT ALLOCATION FOR CONNECTION l BY n CHARACTERS

                format:  5,6,l,n[2 bytes]

This will be used to respond to previous transfers on a line to
keep  the allocation from going to zero.  Each transfer will be
responded to separately.

        PROBE i FOR CONNECTION l

                format:  5,7,l,i,0

Used for a variety of purposes - e.g.  sent after a  series  of
transfers,  it  would  result  in a response when all transfers
before it were completed;  e.g.  used to  check  for  an  empty
output buffer.

        RESPONSE i FOR CONNECTION l

                format:  5,10,l,i,0

The PROBE response.

        CLEAR CONNECTION l

                format:  3,11,l

Used to clear a line of all current  (in  progress)  transfers,
e.g.  "CTRL O".


7.3.4 Connection Control

        PROBE STATUS i FOR CONNECTION l

                format:  4,12,l,i

        SET STATUS i TO s FOR CONNECTION l

                format:  5,13,l,i,s

        VALUE OF STATUS i IS s ON CONNECTION l

                format:  5,14,l,i,s

        CHANGE OF STATUS i TO s ON CONNECTION l

                format:  5,15,l,i,s

Codes #12 & 13 are used to query and set the status of a  line,
while  code  #14  is  used  to respond to both.  Code #15 is an
unsolicited statement of a status change.

A partial list of statuses which may be probed and set are:

        0 - all (probe only)

        1 - auto-baud rate detection - on/off

        2 - input baud rate

        3 - output baud rate

        4 - line/modem status

        5 - answer/shut status (are new users allowed on
            this line?)

        6 - connect/disconnect (on/off line) status

        7 - diagnostic mode

        10 - message mode - messages may be typed on this line


7.3.5 Connection Errors

        ERROR i ON CONNECTION l (DATA d FOLLOWS)

                format:  (n+4),16,l,i,d(1),...,d(n)

Used to indicate an error or unusual condition on a line.   The
data  represents  everything the sender knows about the problem
and the error code, i, contains the error type and severity.


7.3.6 Time-of-Day/Date

        TIME OF DAY/DATE REQUEST

                format:  2,17

Used when one processor comes up to obtain the time-of-day/date
information.   It  is  assumed  that if the -10 receives such a
request and does  not  have  up-to-date  information,  it  will
request it from the operator or from another -11.

        TIME OF DAY/DATE NOT KNOWN

                format:  2,20

Probably only used by the -11.

        SET DATE

                format:  5,21,d(1),d(2),d(3)

        SET TIME OF DAY

                format:  6,22,h,m,s(1),s(2)

Used both as a response and as an unsolicitated  request.   The
date  d(1),  d(2),  d(3) is maintained, by the -11, as a 24 bit
integer.  Time is maintained as:

    h = Hours - 1 byte, overflows at 24 to increment the Date.

    m = Minutes - 1 byte, overflows at 60 to increment Hours.

    s(1), s(2) = 300ths of a second - 2 bytes, overflows at
    18000 into Minutes


7.3.7 On-Line Diagnostics

        DIAGNOSTIC MESSAGE FOR CONNECTION l

                format:  (n+3),23,l,m(1),...,m(n)

Used to communicate between -10 based and -11 based  diagnostic
code.

    BLOCK b CONTAINS n BYTES OF DIAGNOSTICS FOR CONNECTION l

                format:  6,24,l,b,n[2 bytes]

Handled similarly to a block character transfer.  Used to  load
-11 base diagnostic code if not already resident and diagnostic
buffers.


7.3.8 Statistics

        STATISTIC REQUEST i ON CONNECTION l

                format:  4,25,l,i

Used  to  request  that  the  -11  start  sending  a  group  of
statistics.

        BLOCK b CONTAINS n BYTES OF STATISTICS FOR CONNECTION l

                format:  6,26,l,b,n[2 bytes]

Used by the -11 to send statistics to -10 based code


7.3.9 System Errors

        REPORT TO ERROR FILE FOR CONNECTION l

                format:  (n+4),27,l,i,d(1),...,d(n)

Used to make entries in the error file.  The byte i contains an
error  type  and  severity  and d the available error data.  If
relevant, l  represents  the  connection  on  which  the  error
occurred.


7.3.10 Queue Miscellany

        END OF QUEUE

                format:  2,30

Used to indicate logical end-of-queue:  prepare for new queue.

        NULL QUEUE ENTRY

                format:  1

Could be used for queue padding or as a  place  holder  in  the
queue.

        DISCARD BLOCK b FOR CONNECTION l FOR REASON i

                format:  5,31,l,b,i

Used to pass over block character transfers.

        INVALID QUEUE ENTRY TYPE i RECEIVED

                format:  (n+3),32,i,q(1),...q(n)

Used to return invalid queue entries found in the queue.


7.3.11 User Messages

        TYPE i MESSAGE m FOR CONNECTION CLASS j

                format:  (n+4),33,i,j,m(1),...,m(n)

Connection classes might be:

        0 - all terminal

        1 - remote terminals

        2 - all lines in message mode

        3 - all SHUT lines

        4 - all non-CTY terminals

Message types might be:

        0 - now

        1 - only if the -10 crashes

        2 - on receiving a control C

        3 - on receiving any (non-null) character


7.3.12 Special Devices and Other Miscellany

        BLOCK b CONTAINS n BYTES FOR THE PRINTER RAM

                format:  6,34,l,b,n[2 bytes]

        CDR REQUEST TYPE i FOR n CARDS ON CONNECTION l

                format:  5,35,l,i,n

Used by the -10 to request cards from  the  -11.   The  request
type,  i,  might  be used to specify what type of buffering the
-11 should do (if at all), whether it should wait  for  another
request  before reading again, whether it should inform the -10
immediately of an error or wait till  the  buffers  are  empty,
etc.

        CLOCK INTERRUPT

                format:  4,36,s(1),s(2)

s(1),s(2) is a 16 bit binary integer, in the  range  [0,18000),
giving the number of 300ths of a second since the last minute.


8.  CTY

Two separate accesses to a "CTY" have been provided through the
communication  area.   CTY  processing  is independent of queue
processing.  Only one CTY may be in use  at  a  time  and  both
processors  must  agree  on which is in use.  Use of a CTY by a
-10 program is accomplished as follows (for  a  description  of
how EDDT might save and restore the current state, see the next
section).

Note:  CTY #0 is assumed here since it is intended that all CTY
users will use CTY #0 .  EDDT will communicate with the -11 by means 
of the secondary protocol.


8.1 The -10 would initiate CTY use as follows:

    1.  Set the words CTY0CW and CTY0RW  in  the  communication
        area to zero

    2.  Set the bits CTYIUF = 1, CTYIUN = 0 in the STATUS word

    3.  Ring the -11's doorbell

The -11 will respond by:

    4.  Setting the words CTY0CW and CTY0RW = 0, and  CTYIUF  =
        1, CTYIUN = 0 in STATUS

    5.  Ringing the -10's doorbell

The -10 may now start making requests of the -11.  For example,
suppose it wishes to output a character, it would:

    6.  Place the character in CTY0CD

    7.  Set CTY0CC = 3

    8.  Increment CTY0CN (by 1 mod 16, with 0 not  used  except
        for errors)

    9.  Ring the -11's doorbell

The -11 will notice the new command number, execute the command
and:

   10.  Set its CTY0RC = an appropriate response

   11.  Move the -10's CTY0CN to its CTY0RN

   12.  Ring the -10's doorbell

thus completing the request.


8.2 It  was  my  intention  that  the  CTY  capability  of  the
communication  area  have a mode of operation which is as close
to a hardware CTY as possible.  That was the purpose of  having
the  CTY  commands  "Enable/Disable  CTY  I/O done interrupts".
Enabling the interrupts would allow the front end  to  interrupt
the  -10, through the communication area, whenever it received a
character or had finished transmitting one.   


9.  NON-QUEUED COMMANDS

Queue processing will not be implemented in the  1080  and  may
not   be   used   in   the  20-series  for  communication  with
diagnostics,  etc.   When  the  queue  is  not  in   use,   the
communication  region  may  be  used  for  direct  commands and
responses.


9.1 The -10 Would Initiate a Command as Follows:

    1.  Set the word MISCW to the  desired  command,  and  set
        DATCW if required

    2.  Set TO11CS = CSNONQ in the Status Word

    3.  Ring the -11's doorbell

The -11 would respond by noticing the command, executing it and
then would

    1.  Set it MISRC = an appropriate response.  Set its DATRW
        if required.

    2.  Move the -10's MISCN to its MISRN

    3.  Ring the -10's doorbell, thus completing the response.


10.  MOTIVATION


10.0 This section contains notes on design motivation, to which
references are made in the earlier sections of the document.


10.1 General or overall  motivation  for  using  this  type  of
protocol.   The reasons given here are based on studies made by
others and on Paul Dunn's experience  working  on/with  several
similar systems.


10.1.1 This type of protocol has worked in the past.


10.1.2 Experience has shown it to  be  easily  modified  in  an
upward compatible manner.


10.1.3 It is  easily  expanded  to  handle  new  functions  and
consequently new devices.


10.1.4 It provides a minimal interface surface resulting  in  a
more error free and reliable interface.


10.1.5 It makes it difficult for one processor  to  damage  the
other solely through the interface.


10.1.6 It makes it possible for drivers to exist, on both sides
of  the  interface,  which  are  unaware of what information is
being passed across the interface as  long  as  the  format  is
correct (a very simple format).


10.1.7 The amount of  overhead  in  passing  data  through  the
interface, though not minimal, is fixed and predictable.


10.2 Since the communication  area  belonging  to  a  processor
essentially  represents  the  hardware/software  status of that
processor, it is undesirable that  anyone  but  that  processor
change its contents.


10.3 On the theory that a processor should not  have  any  more
write  access  than  it  needs and to simplify the interlocking
required on the queue processing.


10.4  This  is  to  avoid  having  to  duplicate   the   status
(hardware/software  communication  status)  for  a processor in
more than one place.


10.5  The  reasons  for  this  will  become  clear   when   one
understands  the  queue mechanism.  Essentially, the advantages
of using these capabilities, if any, do not  make  up  for  the
added complexity in the DTE20 interrupt service routine and the
restrictions which would have to  be  placed  on  the  protocol
(mainly   in   state  changing)  to  utilize  the  capabilities
efficiently.


10.6 There may be some  problems  with  the  -11  having  write
access  to an EXEC page through the EPT word EPTDRW and the -10
only having read access to the same page.  However  I  consider
it desirable that there be hardware protection so that only the
one  "owning"  processor  may  write  in  any   word   in   the
communication area.
APPENDIX

This describes procedures for each of the processors to handle and 
to generate DTE20 doorbell interrupts to any other processor.  The 
procedure is designed to avoid races and to provide some reasonable 
confidence of detecting hardware malfunctions which are prohibiting 
inter-processor communication.  The description will address:

    1.  To -10 doorbells which both the receiving -10 and 
        transmitting -11 wish to monitor.

    2.  To -11 doorbells which both the receiving -11 and the 
        transmitting -10 wish to monitor.

To -10 Doorbells:

The KL10 upon receiving a doorbell interrupt from an -11 must:

    1.  Check to see if the doorbell is announcing an anamalous or 
        crash condition (e.g., power fail).  If so, clear the 
        doorbell and take appropriate action.

    2.  See if the To-10 transmit count (TO10IC) in the connected 
        -11's communication region has been incremented.  If not, 
        then this is a surious interrupt.  It should be dismissed 
        and the error logged in the error file.

    3.  If the connected -11's TO10IC count has been incremented 
        then the -11 wishes to transmit a queue to the KL10.  The 
        -10 should set the to-10 in transit bit (TOIT) to one to 
        indicate that it is actively copying a queue and the -10 
        should increment its T10IC count for this -11 and then clear 
        the doorbell in the DTE20.  At this point it may begin queue 
        processing.  Also at this point, the to-10 doorbell in the 
        DTE20 should be low and the -10's TO10IC should equal the 
        connected -11'S TO10IC.

    4.  Upon receiving a queue termination interrupt from the DTE20, 
        the -10 should clear the TOIT bit to indicate that it is no 
        longer copying a queue.  This sbit should be used by the 
        sending processor to determine if it has lost its queue 
        terminated interrupt.

An -11 receiving a doorbell should follow the same procedure as 
described above except it should use its TO11IC and the connected 
-10's TO11IC for the comparison.

IF EITHER PROCESSOR WISHES TO SEND A DOORBELL TO THE OTHER IT SHOULD 
(this will be described as if a -10 is sending to an -11).

    1.  The -10 must first insure that the previous doorbell hasbeen 
        answered and the requested transaction is completed.  Since 
        the -10 will receive a DTE20 initiated interrupt when the 
        -11 has exhausted a queue, no attempt should be made to 
        change the communication region, the EPT, or any DTE20 
        registers related to queue processing until this interrupt 
        has been received.  If it has received the queue termination 
        interrupt and the to-11 doorsbell is high, then the -11's 
        doorbell is stuck high.  Should the -10's lost interrupt 
        detector find that the -10's TO11IC and the -11's TO11IC 
        agree and the -11's TOIT bit is one, then it may conclude 
        that the -10's queue terminated interrupt has been lost and 
        it should simulate a queue exhausted interrupt being 
        received (including checking for the -11's doorbell being 
        stuck high).

    2.  Once the -10 has determined that the -11 is finished with 
        the previous queue either by receiving a queue exhausted 
        interrupt or by determining that the interrupt was lost, it 
        may send another doorbell to the -11.  First, it must set up 
        EPTEBP in its EPT and set the queue size in its own 
        communication region as well as incrementing its TO11IC to 
        announce it is sending the -11 a queue.  Then, it rings the 
        -11's doorbell.

The previous descriptions have mentioned on and off the detection of 
lost interrupts by the -10.  This is a complete description of such 
processing:

    1.  If the lost interrupt poller finds that the state of a given 
        DTE20 (internal KL10 kept device state) is "sending queue to 
        -11" and if the -10's TO11IC equals the -11's TO11IC and if 
        the -11'S TOIT BIT IS ONE>  Then the -10 has lost the queue 
        terminated interrupt.

    2.  If the state of the DTE20 is "sending queue to -11" and the 
        -11's doorbell is low but the -10's TO11IC is greater than 
        the -11's TO11IC, then the -11 did not receive the doorbell 
        and presumably the dorbell is stuck low.  This conclusion is 
        subject to repeated attempts to ring the -11's doorbell 
        successfully.

    3.  Since the -10 cannot access any of the byte count fields in 
        the DTE20, it cannot detect if it has lost a queue 
        termination interrupt generated by its byte count becoming 
        exhausted.  the -11 poller must be responsible for this 
        facet of error detection.

[End of COMPRO.SPC]
