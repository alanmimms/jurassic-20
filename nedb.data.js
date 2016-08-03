'use strict';

const util = require('util');


class PartType {

  constructor(name, description, sections) {
    this.name = name;
    this.description = description;
    this.sections = sections;
  }

  inspect(depth, opts) {
    const nl = '\n' + '  '.repeat(depth+1);
    return `\nPartType{${this.name}: ${this.description} [${nl}` +
      this.sections.map(s => s.inspect(depth+1, opts)).join(',' + nl) +
  `}`;
  }
}


class PinType {

  // Either call this with one string parameter in the form
  // `in!#7:name` or pass the discrete components as three parameters.
  constructor(direction, name, number) {

    if (arguments.length === 1) {
      const s = direction;
      let input;
      [input, direction, number, name] = s.match(/((?:inout|in|out)!?)#(\d+):(\w+)/);
    }

    this.direction = direction.replace(/!/, '');
    this.flavor = (this.direction !== direction) ? 'Inverted' : 'Simple';
    this.name = name;
    this.number = number;
  }

  inspect(depth, opts) {
    return "PinType{" +
      this.direction +
      (this.flavor === 'Inverted' ? "!" : "") +
      '#' + this.number +
      ':' + this.name +
      "}";
  }
}


class PartSection {

  // Pass this an array of pins or a whitespace separated string of
  // pin specs of the form `in!#7:descr in#8:another ...`. Leading
  // whitespace and trailing whitespace are ignored.
  constructor(pins) {

    if (typeof pins === 'string') {
      pins = pins.trim().split(/\s+/).map(p => new PinType(p));
    }

    this.pins = pins;
  }

  inspect(depth, opts) {
    const nl = '\n' + '  '.repeat(depth+1);
    return `PartSection{${nl}` +
      this.pins.map(p => p.inspect(depth+1, opts)).join(',' + nl) +
      '}';
  }
}


class Part {

  constructor(type, ref, location, pins) {
    this.type = type;
    this.ref = ref;
    this.location = location;
    this.pins = pins;
  }
}


class Pin {

  constructor(type, part, location) {
    this.type = type;
    this.part = part;
    this.location = location;
  }
}


class Signal {

  constructor(wires) {
    this.wires = wires;
  }
}


class Wire {

  constructor(from, to, signal) {
    this.from = from;
    this.to = to;
    this.signal = signal;
  }
}


class Page {

  constructor(pdfPage, title, pageCode, revision, parts, wires, noteBlocks) {
    this.pdfPage = pdfPage;
    this.title = title;
    this.pageCode = pageCode;
    this.revision = revision;
    this.parts = parts;
    this.wires = wires;
    this.noteBlocks = noteBlocks;
  }
}


class Schematic {

  constructor(title, moduleName, revision, pages) {
    this.title = title;
    this.moduleName = moduleName;
    this.revision = revision;
    this.pages = pages;
  }
}


const parts = [
  new PartType('10101', '4 or/nor', [
    new PartSection(`in#4:a1 in#12:abcd2 out!#2:nqa out#5:qa`),
    new PartSection(`in#7:b1 in#12:abcd2 out!#3:nqb out#6:qb`),
    new PartSection(`in#10:c1 in#12:abcd2 out!#14:nqc out#11:qc`),
    new PartSection(`in#13:d1 in#12:abcd2 out!#15:nqd out#9:qd`),
  ]),

  new PartType('10103', '4 xor', [
    new PartSection(`in#4:a1 in#5:a2 out#2:qa`),
    new PartSection(`in#6:b1 in#7:b2 out#3:qb`),
    new PartSection(`in#12:c1 in#13:c2 out!#15:nqc out#9:qc`),
    new PartSection(`in#10:d1 in#11:d2 out#14:qd`),
  ]),

  new PartType('10104', '4 and', [
    new PartSection(`in#4:a1 in#5:a2 out#2:qa`),
    new PartSection(`in#6:b1 in#7:b2 out#3:qb`),
    new PartSection(`in#10:c1 in#11:c2 out#14:qc`),
    new PartSection(`in#12:d1 in#13:d2 out!#9:nqd out#15:qd`),
  ]),

  new PartType('10105', '2/3/2 or/nor', [
    new PartSection(`in#4:a1 in#5:a2 out!#3:nqa out#2:qa`),
    new PartSection(`in#9:b1 in#10:b2 in#11:b3 out!#6:nqb out#7:qb`),
    new PartSection(`in#13:c1 in#12:c2 out!#14:nqc out#15:qc`),
  ]),

  new PartType('10107', '3 xor/xnor', [
    new PartSection(`in#4:a1 in#5:a2 out!#2:nqa out#3:qa`),
    new PartSection(`in#9:b1 in#7:b2 out!#11:nqb out#10:qb`),
    new PartSection(`in#14:c1 in#15:c2 out!#12:nqc out#13:qc`),
  ]),

  new PartType('10109', '4/5 or/nor', [
    new PartSection(`in#4:a1 in#5:a2 in#6:a3 in#7:ina4 out!#3:nqa out#2:qa`),
    new PartSection(`in#9:b1 in#10:b2 in#11:b3 in#12:b4 in#13:b5 out!#14:nqb out#15:qb`),
  ]),

  new PartType('10110', '2 or buffer', [
    new PartSection(`in#5:a1  in#6:a2  in#7:a3  out#2:qa1  out#3:qa2  out#4:qa3`),
    new PartSection(`in#9:b1 in#10:b2 in#11:b3 out#12:qb1 out#13:qb2 out#14:qb3`),
  ]),

  new PartType('10113', '4 xor w/enable', [
    new PartSection(`in#4:a1 in#5:a2 in!#9:ne out#2:qa`),
    new PartSection(`in#6:b1 in#7:b2 in!#9:ne out#3:qb`),
    new PartSection(`in#10:c1 in#11:c2 in!#9:ne out#14:qc`),
    new PartSection(`in#12:d1 in#13:d2 in!#9:ne out#15:qd`),
  ]),

  new PartType('10117', '2 2/3 or-and', [
    new PartSection(`in#4:a1 in#5:a2 in#6:b1 in#7:b2 in#9:bc3 out!#3:nqab out#2:qab`),
    new PartSection(`in#10:c1 in#11:c2 in#9:bc3 in#12:d1 in#13:d2 out!#14:nqcd out#15:qcd`),
  ]),

  new PartType('10118', '2 3-2 or-and', [
    new PartSection(`in#3:a1 in#4:a2 in#5:a3 out#2:qab`),
    new PartSection(`in#6:b1 in#7:b2 in#9:bc3 out#2:qab`),
    new PartSection(`in#10:c1 in#11:c2 in#9:bc3 out#15:qcd`),
    new PartSection(`in#12:d1 in#13:d2 in#14:d3 out#15:qcd`),
  ]),

  new PartType('10121', '2 3/4 or-and/nand', [
    new PartSection(`in#4:a1 in#5:a2 in#6:a3 in#7:b1 in#9:b2 in#10:bc3 
				out!#3:nqabcd out#2:qabcd`),
    new PartSection(`in#11:c1 in#12:c2 in#10:bc3 in#13:d1 in#14:d2 in#15:d3 
				out!#3:nqabcd out#2:qabcd`),
  ]),

  new PartType('10141', '4-bit universal shift register', [
    new PartSection(`in!#10:sel1 in!#7:sel2 in#4:clk
in#12:d0 in#11:d1 in#9:d2 in#6:d3
out!#14:nq0  out!#15:nq1  out!#2:nq2  out!#3:nq3`),
  ]),

  new PartType('10144', '256b RAM', [
    new PartSection(`in!#14:rw in!#5:ne1 in!#6:ne2 in!#7:ne3 in#13:d
in#1:a0 in#2:a1 in#3:a2 in#4:a3 in#9:a4 in#10:a5 in#11:a6 in#12:a7
out#15:q`),
  ]),

  new PartType('10147', '128b RAM', [
    new PartSection(`in!#14:nce1 in!#13:nce2 in!#12:nwe in#11:d
in#4:a0 in#3:a1 in#2:a2 in#5:a3 in#6:a4 in#7:a5 in#10:a6 out#15:q`),
  ]),

  new PartType('10158', '4 2-mux', [
    new PartSection(`
in#6:d00 in#5:d01 in#4:d10 in#3:d11 in#13:d20 in#12:d21 in#11:d30 in#10:d31
in#9:sel out#1:q0 out#2:q1 out#15:q2 out#14:q3`),
  ]),

  new PartType('10160', '12-bit parity', [
    new PartSection(`
in#3:in1 in#4:in2 in#5:in3 in#6:in4 in#7:in5 in#9:in6
in#10:in7 in#11:in8 in#11:in9 in#11:in10 in#11:in11 in#11:in12
out#2:out`),
  ]),

  new PartType('10161', 'decoder active low', [
    new PartSection(`
in#7:sel1 in#9:sel2 in#14:sel4
in!#15:en1 in!#2:en2
out!#6:nq0  out!#5:nq1  out!#4:nq2  out!#3:nq3
out!#13:nq4 out!#12:nq5 out!#11:nq6 out!#10:nq7`),
  ]),

  new PartType('10162', 'decoder', [
    new PartSection(`
in#7:sel1 in#9:sel2 in#14:sel4
in!#15:en1 in!#2:en2
out#6:q0  out#5:q1  out#4:q2  out#3:q3
out#13:q4 out#12:q5 out#11:q6 out#10:q7`),
  ]),

  new PartType('10164', '8-mix', [
    new PartSection(`
in#7:sel1 in#9:sel2 in#10:sel4 in!#2:en
in#6:in0 in#5:in1 in#4:in2 in#3:in3 in#11:in4 in#12:in5 in#13:in6 in#14:in7
out#15:out`),
  ]),

  new PartType('10165', '8-bit priority encoder', [
    new PartSection(`
in#5:d0 in#7:d1 in#13:d2 in#10:d3 in#11:d4 in#12:d5 in#9:d6 in#6:d6
out#3:q0 out#2:q1 out#15:q2`),
  ]),

  new PartType('10173', '4 2-mux/latch', [
    new PartSection(`in!#9:sel in!#7:clk
in#6:d00 in#5:d01 in#4:d10 in#3:d11 in#13:d20 in#12:d21 in#11:d30 in#10:d31
out#1:q0 out#2:q1 out#15:q2 out#14:q3`),
  ]),

  new PartType('10174', '2 4-mux', [
    new PartSection(`in!#7:sel1 in!#9:sel2 in!#14:en
in#3:d00 in#5:d01 in#4:d02 in#6:d03 in#13:d10 in#11:d11 in#12:d12 in#10:d13
out#2:q0 out#15:q1`),
  ]),

  new PartType('10176', '6 d-flipflop', [
    new PartSection(`in#9:clk in#5:d0 out#2:q0`),
    new PartSection(`in#9:clk in#6:d1 out#3:q1`),
    new PartSection(`in#9:clk in#7:d2 out#4:q2`),
    new PartSection(`in#9:clk in#10:d3 out#13:q3`),
    new PartSection(`in#9:clk in#11:d4 out#14:q4`),
    new PartSection(`in#9:clk in#12:d5 out#15:q5`),
  ]),

  new PartType('10179', 'carry', [
    new PartSection(`in#11:cn in#14:p0 in#10:p1 in#12:p2 in#13:p3
in#4:g0 in#7:g1 in#9:g2 in#3:g3 out#6:co2 out#3:co4 out#15:pg out#2:gg`),
  ]),

  new PartType('10181', '4-bit alu', [
    new PartSection(`in#14:s0 in#17:s1 in#15:s2 in#13:s3 in#23:m in#22:cn
in#21:a0 in#18:a1 in#16:a2 in#10:a3
in#20:b0 in#19:b1 in#11:b2 in#9:b3
out#2:f0 out#3:f1 out#7:f2 out#6:f3 out#4:gg out#8:pg out#5:co`),
  ]),

  new PartType('10210', '2 3-or buffer', [
    new PartSection(`in#5:a1 in#6:a2 in#7:a3 out#2:qa1 out#3:qa2 out#4:qa3
in#9:b1 in#10:b2 in#11:b3 out#12:qb1 out#13:qb2 out#14:qb3`),
  ]),
];

console.log('parts:', util.inspect(parts, {depth: null}));

