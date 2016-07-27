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

  constructor(direction, name, number) {
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

  constructor(pins) {
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


const db = [
  // '10161': dev('decoder active low', 'sel@3, nen#1/2', 'nq/8'),
  new PartType('10161', 'decoder active low', [
      new PartSection([
	  new PinType('in', 'SEL1', 7),
	  new PinType('in', 'SEL2', 9),
	  new PinType('in', 'SEL4', 14),
	  new PinType('in!', 'EN1', 15),
	  new PinType('in!', 'EN2', 2),
	  new PinType('out', 'Q0', 6),
	  new PinType('out', 'Q1', 5),
	  new PinType('out', 'Q2', 4),
	  new PinType('out', 'Q3', 3),
	  new PinType('out', 'Q4', 13),
	  new PinType('out', 'Q5', 12),
	  new PinType('out', 'Q6', 11),
	  new PinType('out', 'Q7', 10),
	]),
  ]),
];

console.log('db:', util.inspect(db, {depth: null}));

