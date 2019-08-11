const util = require('util');


// This is filled in by the parser before any parsing starts.
module.exports.location = null;

function location() {
  return module.exports.location();
}


class ASTNode {
  constructor(t = this.__proto__.constructor.name) {
    this.t = t;
    this.loc = location();
  }

  inspect(depth, opts) {
    return this.t;
  }
}


class Board extends ASTNode {
  constructor(pages) {
    super();
    this.pages = pages;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(pages=${util.inspect(this.pages, opts)})`;
  }
}

class Page extends ASTNode {
  constructor(name, pdfRef) {
    super();
    this.name = name;
    this.pdfRef = pdfRef;
    this.chips = [];
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(name=${this.name}, pdfRef=${this.pdfRef},\n` +
      `  chips=${util.inspect(this.chips, opts)})`;
  }
}

class Chip extends ASTNode {
  constructor(name, type, desc) {
    super();
    this.name = name;
    this.type = type;
    this.desc = desc;
    this.pins = [];
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(` +
      `name=${this.name}, type=${this.type}, desc=${this.desc},\n` +
      `  pins=${util.inspect(this.pins, opts)})`;
  }
}

class Pin extends ASTNode {
  constructor(name, dir, net) {
    super();
    this.name = name;
    this.dir = dir;
    this.net = net;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(` +
      `name=${this.name}, dir=${this.dir}, net=${util.inspect(this.net, opts)})`;
  }
}

class Macro extends ASTNode {
  constructor(head, ids) {
    super();
    this.head = head;
    this.ids = ids;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(\n` +
      `  head=${util.inspect(this.head, opts)},\n` +
      `  ids=${util.inspect(this.ids, opts)})`;
  }
}

class SelectorList extends ASTNode {
  constructor(list) {
    super();
    this.list = list;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(\n` +
      `  list=${util.inspect(this.list, opts)})`;
  }
}

class IDList extends ASTNode {
  constructor(list) {
    super();
    this.list = list;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(\n` +
      `  list=${util.inspect(this.list, opts)})`;
  }
}

class IDChunk extends ASTNode {
  constructor(name) {
    super();
    this.name = name;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(name=${this.name})`;
  }
}

class Value extends ASTNode {
  constructor(value) {
    super();
    this.value = value;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(value=${this.value})`;
  }
}

class NoConnect extends ASTNode { }

class Operator extends ASTNode {
  constructor(t, l, r) {
    super(t);
    this.l = l;
    this.r = r;
  }

  inspect(depth, opts) {
    return `${super.inspect(depth, opts)}(\n` +
      `  ${util.inspect(this.l, opts)},\n` +
      `  ${util.inspect(this.r, opts)})`;
  }
}


Object.assign(module.exports, {
  ASTNode,
  Board,
  Page,
  Chip,
  Pin,
  Macro,
  SelectorList,
  IDList,
  IDChunk,
  Value,
  NoConnect,
  Operator,
});
