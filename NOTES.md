# Thoughts:

* It's better to transform AST into netlist structure at top level
    production of each parse (sub)tree.

* This decouples netlist structure from AST structure near where AST
    structure is defined.

* This decouples uses of netlist structure from AST structure.

# Data

## Data Needed

* Board level wiring: Interconnect nets with same local net name
  (`lNet`) on each chip on reach board. On the board `lNet` is the net
  name.

* CRAM bit naming per slot: Interconnect nets with same global net
  name (`gNet`) by backplane pins for CRM board slots. On the
  backplane, `gNet` is the net name.

* Backplane level wiring: Interconnect nets with same global net name
  (`gNet`) by backplane pin. On the backplane, `gNet` is the net name.
  This `gNet` is initialized from the board's `lNet` and then
  overridden by the CRAM global net name if there is one for this
  slot.


## Data Available



# TODO:

* Need dump of nets and their backplane slot/pin fullname and chip pin
  fullname.

* Show each slot attached to same net for multiply-instantiated
  modules like EDP and CRM.

* E.g., these two signals should be attached to three slots each:

     cram arxm sel 4 00 h:
       DP02.e60.4     edp.ff1[52]    PDF16

     cram arxm sel 4 06 h:
       DP02.e60.4     edp.ff1[52]    PDF16

* Signals that don't go to a backplane pin _must_ stay local to the
  module even if they have names that match global signal names. E.g.,
  `ad cry -02 h` is local to EDP and also global driven by `IRD.ca1` to
  `CRA.cf1`.

* Make board definitions instantiate a complete new data structure for
  each slot the board is in so we can add/change/specialize the data
  there for each slot (especially for signals for CRAM bits on
  backplane).

* Finish defining signals for CRAM bits on backplane.
