{
  const util = require('util');

  class ASTNode {
    constructor(t = this.__proto__.constructor.name) {
      this.t = t;
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
}


board = p:page+ { return new Board(p) }

page = p:pageDef n:chipDef+
		{ p.chips = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  (_ EOL)+
		{ return new Page(name, pdfRef) }

chipDef = h:chipHead p:pinDef+
		{ h.pins = p; return h }

chipHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL .)+ ) (_ EOL)+
		{ return new Chip(name, type, desc) }

pinDef = [ \t]+ name:bareID _ dir:direction _ net:net (_ EOL)+
		{ return new Pin(name, dir, net) }

direction = $( '~<>' / '~>' / '~<')

macroRef =  '[' _ head:expr _ ids:selectorList ']'
		{ return new Macro(head, ids) }

selectorList = list:( ',' _ idList )*
		{ return new SelectorList(list.map(e => e[2])) }

idList = list:( macroRef / idChunk )+
       		{ return new IDList(list) }

bareID = [-/#=%.+_&a-zA-Z]+ [-/#=%.+_&<> a-zA-Z0-9]*
		{ return text().trim() }

idChunk = name:( '\\' EOL _ / [-/#%.+_&<> a-zA-Z0-9=] )+
		{ return new IDChunk(text().replace(/\\[\n\r]\s*/g, '')) }

// like idChunk but allows ',' in the identifier in non-macro context
id = name:( '\\' EOL _ / [-/#%,.+_&<> a-zA-Z0-9=] )+
		{ return new IDChunk(text().replace(/\\[\n\r]\s*/g, '')) }

expr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
		{ return new Operator(op, l, r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
		{ return new Operator(op, l, r) }
/	primary

primary = [0-9]+
		{ return new Value(parseInt(text(), 10)) }
/	'(' _ val:sum _ ')'
		{ return val }
/	macroName

macroName = name:$( [a-zA-Z0-9]+ )
		{ return new IDChunk(name) }

net = '%NC%'	{ return new NoConnect() }
/	[01]	{ return new Value(parseInt(text(), 2)) }
/	c:( macroRef / id )+
		{ return new IDList(c) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
