'use strict';


class PartType {

  constructor({name, description, sections}) {
    Object.assign(this, arguments[0]);
  }
}


class PinType {

  constructor({direction, name, number}) {
    let o = arguments[0];
    const dirNot = o.direction;
    o.direction = dirNot.replace(/!/, '');
    o.flavor = (o.direction !== dirNot) ? 'Inverted' : 'Simple';
    Object.assign(this, o);
  }
}


class SectionType {

  constructor(pinTypes) {
    this.pinTypes = pinTypes;
  }
}


class Part {

  constructor({type, ref, location, pins}) {
    Object.assign(this, arguments[0]);
  }
}


class Pin {

  constructor({type, part, location}) {
    Object.assign(this, arguments[0]);
  }
}


class Signal {

  constructor(wires) {
    this.wires = wires;
  }
}


class Wire {

  constructor({from, to, signal}) {
    Object.assign(this, arguments[0]);
  }
}


class Page {

  constructor({pdfPage, title, pageCode, revision, parts, wires, noteBlocks}) {
    Object.assign(this, arguments[0]);
  }
}


class Schematic {

  constructor({title, moduleName, revision, pages}) {
    Object.assign(this, arguments[0]);
  }
}


const db = [
  // '10161': dev('decoder active low', 'sel@3, nen#1/2', 'nq/8'),
  new PartType({
    name: '10161',
    description: 'decoder active low',
    sections: [
      new PartSection({
	pins: [
	  new PinType('in', 'sel1', 7),
	  new PinType('in', 'sel2', 9),
	  new PinType('in', 'sel4', 14),
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
	],
      }),
    ],
  }),
];

