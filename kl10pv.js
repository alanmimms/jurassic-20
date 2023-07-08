'use strict';

// Assemble a machine from *.board files in proper location and population.
//
// Module utilization for CPU bay is PDF10.
// 
// Option wire list is PDF555.
// * EMPTY 50Hz
// * EMPTY Cache avail
// * EMPTY Channel avail
// * ASSERT KL10-PV CPU
// * EMPTY? Master oscillator
// * ASSERT Serial number (12 bits) = 0o1234
//
// CRAM names PDF398.

const globalMacros = {a: 2, b: 1};
const hasCache = true;

const m =
`chc crc ccl ccw mb0 cac mbz mbx mbc csh cha chx ch0a ch0x pma pag pic
clk mtr apr con ctl vma edp crm shm scd`
      .split(/\s+/)
      .reduce((accum, key) => {
	accum[key] = parseFile(`board/${key}.board`);
	accum[key].id = key;
	return accum;
      }, {});

// EBOX/MBOX
const bp = [
  /* 0 */ null, // not used
  /* 1 */ null, // cables BC11A M919, BC20C M9006, BC20C M9006
  /* 2 */ null, // cables BC20C M9006, BC20C M9006, spare
  /* 3 */ null, // cables BC20C M9006, BC20C M9006, spare
  /* 4 */ null, // TR0 E&C BUS TRAN M8516
  /* 5 */ null, // TR0 E&C BUS TRAN M8516
  /* 6 */ null, // TR0 E&C BUS TRAN M8516
  /* 7 */ null, // TR0 S BUS TRAN M8519
  /* 8 */ null, // TR0 S BUS TRAN M8519

  /* 9 */ {board: m.chc, module: 'M8533', macros: {m: 0}},
  /*10 */ {board: m.crc, module: 'M8535'},
  /*11 */ {board: m.ccl, module: 'M8536', macros: {n: 0}},
  /*12 */ {board: m.ccw, module: 'M8534', macros: {n: 0}},

  /*13 */ null, // blank

  /*14 */ {board: m.mb0, module: 'M8517'},
  /*15 */ {board: m.mb0, module: 'M8517'},
  /*16 */ {board: m.mb0, module: 'M8517'},
  /*17 */ hasCache ? {board: m.cac, module: 'M8521'} : {board: m.ch0, module: 'M8549YH'},

  /*18 */ null, // blank

  /*19 */ hasCache ? {board: m.cac, module: 'M8521'} : {board: m.ch0, module: 'M8549YH'},
  /*20 */ {board: m.mbz, module: 'M8537'},
  /*21 */ {board: m.mbx, module: 'M8529YA', macros: {n: 30}},
  /*22 */ {board: m.mbc, module: 'M8531YA', macros: {n: 22}},
  /*23 */ {board: m.csh, module: 'M8513YA'},
  /*24 */ hasCache ? {board: m.cac, module: 'M8521'} : {board: m.ch0, module: 'M8549YH'},
  /*25 */ hasCache ? {board: m.cac, module: 'M8521'} : {board: m.ch0, module: 'M8549YH'},

  /*26 */ null, // blank

  /*27 */ hasCache ? {board: m.cha, module: 'M8514'} : {board: m.ch0a, module: 'M8549YE'},
  /*28 */ hasCache ? {board: m.chx, module: 'M8515', macros: {n: 0}} : {board: m.ch0x, module: 'M8549YF'},
  /*29 */ {board: m.pma, module: 'M8518YA'},
  /*30 */ {board: m.pag, module: 'M8520YA'},
  /*31 */ {board: m.pic, module: 'M8532'},
  /*32 */ {board: m.clk, module: 'M8526YA'},
  /*33 */ {board: m.mtr, module: 'M8538'},
  /*34 */ {board: m.apr, module: 'M8545'},
  /*35 */ {board: m.con, module: 'M8525'},
  /*36 */ {board: m.ctl, module: 'M8543'},

  /*37 */ null, // blank

  /*38 */ {board: m.vma, module: 'M8542'},
  /*39 */ {board: m.edp, module: 'M8512'},
  /*40 */ {board: m.crm, module: 'M8548'},
  /*41 */ {board: m.edp, module: 'M8512'},
  /*42 */ {board: m.crm, module: 'M8548'},
  /*43 */ {board: m.edp, module: 'M8512'},
  /*44 */ {board: m.crm, module: 'M8548'},
  /*45 */ {board: m.cra, module: 'M8541'},
  /*46 */ {board: m.shm, module: 'M8540'},
  /*47 */ {board: m.mcl, module: 'M8544'},
  /*48 */ {board: m.ird, module: 'M8522', macros: {n: 12}},
  /*49 */ {board: m.edp, module: 'M8512'},
  /*50 */ {board: m.crm, module: 'M8548'},
  /*51 */ {board: m.edp, module: 'M8512'},
  /*52 */ {board: m.crm, module: 'M8548'},
  /*53 */ {board: m.edp, module: 'M8512'},
  /*54 */ {board: m.scd, module: 'M8524'},
];

//  addOptionWire(43, 'em2', 44, 'de1', 'option50Hz');
    addOptionWire(43, 'ea1', 44, 'de1', 'optionCacheAvailable');
    addOptionWire(43, 'ee1', 44, 'de1', 'optionInternalChannels');
    addOptionWire(43, 'dd2', 44, 'de1', 'optionExtendedKL');
//  addOptionWire(43, 'de1', 44, 'de1', 'optionMasterOscillator');
    addOptionWire(41, 'em2', 42, 'de1', 'serial2048');
    addOptionWire(41, 'ea1', 42, 'de1', 'serial1024');
    addOptionWire(41, 'ee1', 42, 'de1', 'serial512');
    addOptionWire(41, 'dd2', 42, 'de1', 'serial256');
//  addOptionWire(41, 'de1', 42, 'de1', 'serial128');
//  addOptionWire(41, 'ef2', 42, 'de1', 'serial64');
//  addOptionWire(39, 'em2', 40, 'de1', 'serial32');
//  addOptionWire(39, 'ea1', 40, 'de1', 'serial16');
//  addOptionWire(39, 'ee1', 40, 'de1', 'serial8');
//  addOptionWire(39, 'dd2', 40, 'de1', 'serial4');
//  addOptionWire(39, 'de1', 40, 'de1', 'serial2');
//  addOptionWire(39, 'ef2', 40, 'de1', 'serial1');


////////////////////////////////////////////////////////////////
// Bay 1 module chart PDF488
// Backplane: BAY1
// Slot 1: ignore cables BC20C M9006, BC20C M9006, spare
// Slot 2: dmc M8563
// Slot 3: M8760
// Slot 4: ma0 M8558
// Slot 5: ma0 M8558
// Slot 6: ma0 M8558
// Slot 7: ma0 M8558
// Slot 8: ma0 M8558
// Slot 9: ma0 M8558
// Slot 10: ma0 M8558
// Slot 11: ma0 M8558
// Slot 12: ignore spare
// Slot 13: M8550
// Slot 14: M8550
// Slot 15: M8551
// Slot 16: ignore cables BC11A M929, BC11A M929, spare

////////////////////////////////////////////////////////////////
// DTE20
// Module utilization PDF403
// Backplane: DTE20
// Slot 1: ignore M920
// Slot 2: M8559
// Slot 3: M8554
// Slot 4: M8553
// Slot 5: M8552
// Slot 6: ignore spare
// Slot 7: ignore spare
// Slot 8: ignore spare
// Slot 9: ignore spare
// Slot 10: ignore cables BC11A (M929), BC20C (M9006), BC20C (M9006)

////////////////////////////////////////////////////////////////
// RH20
// Module utilization PDF404.
// Backplane: RH20
// Slot 1: ignore cables IOC3 (M920), IOC4 (M902), INT M8554 // for DTE20#1

// DTE20#1 Slot 2-3
// Slot 2: cnt M8553
// Slot 3: dps M8552

// DTE20#2 Slot 4-5
// Slot 4: cnt M8553
// Slot 5: dps M8552

// Slot 6: int M8554 // three instances for DTE20#2, #3, and #4

// DTE20#3 Slot 6-7
// Slot 7: cnt M8553
// Slot 8: dps M8552

// DTE20#4 Slot 9-10
// Slot 9: cnt M8553
// Slot 10: dps M8552

// Slot 11: ignore blank
// Slot 12: cds M8559

// RH7
// Slot 13: ebi M8555
// Slot 14: mss M8557
// Slot 15: dp M8556

// RH6
// Slot 16: ebi M8555
// Slot 17: mss M8557
// Slot 18: dp M8556

// RH5
// Slot 19: ebi M8555
// Slot 20: mss M8557
// Slot 21: dp M8556

// RH4
// Slot 22: ebi M8555
// Slot 23: mss M8557
// Slot 24: dp M8556

// RH3
// Slot 25: ebi M8555
// Slot 26: mss M8557
// Slot 27: dp M8556

// RH2
// Slot 28: ebi M8555
// Slot 29: mss M8557
// Slot 30: dp M8556

// RH1
// Slot 331: ebi M8555
// Slot 32: mss M8557
// Slot 33: dp M8556

// RH0
// Slot 34: ebi M8555
// Slot 35: mss M8557
// Slot 36: dp M8556

// Slot 37: ignore cables IOC1 BC11A (M929), IOC2 BC202C (M9006), IOC2 B20C (M9006)


function parseFile(f) {
  console.log(f);
  return {};
}


function addOptionWire(srcSlot, srcPin, dstSlot, dstPin, name) {
  console.log(`Option ${srcPin}[$srcSlot} = ${dstPin}[$dstSlot} ${name}`);
}
