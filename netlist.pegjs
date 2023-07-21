{
  const util = require('util');
  const astDirToDir = options.astDirToDir;

  var chip;
  var page;
  var wires = {};
  var nets = {};
  var bpPins = {};


  function AST(nodeType, props) {
    const loc = location();

    // So we can toString() and util.inspect() our location() values with readable results.
    loc.__proto__.toString = loc[util.inspect.custom] = function() {
      const [s, e] = [this.start ? this.start : this, this.end? this.end: this];
      return `@${s.line}:${s.column}:${s.offset}..${e.line}:${e.column}:${e.offset}`;
    };

    return {nodeType, location: loc, ...props};
  }


  function addNet(page, chip, pin, dir, bpPin, net) {
    const netAST = net.list;
    net = net.text;

    if (!nets[net]) nets[net] = [];

    const n = {net, bpPin, netAST, page, chip, pin, dir: astDirToDir(dir)};
    const key = `${chip.name}.${astDirToDir(dir)}.${pin}`;
    wires[key] = n;
    nets[net].push(n);

    if (bpPin) {
      if (!bpPins[bpPin]) bpPins[bpPin] = {};
      bpPins[bpPin][key] = n;
    }
  }
}


compileable = blankLines? b:(stubBoard / backplane+ / board) { return b }

backplane = 'Backplane' _ ':' _
	macros:( '{' _ m:macroDef* '}' _ {return m} )?
	name:simpleID _ EOL
	slots:slotDef+
                { return AST('Backplane', {name, macros, slots, boards: {}}) }

slotDef = 'Slot' _ n:simpleID _ ':' _ board:slotContent blankLines slotWires:wireDef* blankLines?
                { return AST('Slot', {n, board, slotWires, bpPins: {}}) }

slotContent = macros:( '{' _ m:macroDef* '}' {return m} )? _
	id:simpleID _ comments:$( !EOL . )*
                { return AST('ModuleID', {macros, id, comments}) }

macroDef = id:simpleID _ '=' _ value:$(number / simpleID) _
                { return AST('MacroDef', {id, value}) }

wireDef = _ slotPin:bpPinID _ farPin:bpPinID '[' slot:number ']' _ name:id _ blankLines
	        { return AST('Wire', {slotPin, farPin, slot, name}) }

stubBoard = 'STUB IMPLEMENTATION' EOL p:pageDef*
	    	{ return AST('Stub', {pages: p}) }

board = pages:(page / warning)+
		{ const b = AST('Board', {pages, nets, wires, bpPins});
		  // Cleanly reinitialize accumulators for next board.
		  wires = {};
		  nets = {};
		  bpPins = {};
		  return b; }

page = p:pageDef n:chipDef*
		{ p.chips = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  blankLines
		{ page = {name, pdfRef};
		  return AST('Page', {name, pdfRef, chips: []}); }

warning = _ '%warning' _ s:$( !EOL . )* blankLines
		{ console.error(`= = = = WARNING: ${s}`);
		  return AST('Page', {name: '%warning', pdfRef: 'none', chips: [], s}); }

chipDef = h:chipHead p:pinDef+
		{ h.pins = p; return h }

chipHead = !'Page' name:$idChunk ':' _ type:$([^ \t]+) _ desc:$( (!EOL . )+ ) blankLines
		{ chip = {name, type, desc};
		  return AST('Chip', chip); }

pinDef = [ \t]+ pin:number _ dir:direction _ bpPin:bpPin? _ net:net blankLines
		{ addNet(page, chip, pin, dir, bpPin, net);
		  return AST('Pin', {pin, dir, bpPin: bpPin ? bpPin.trim() : null, net}); }

direction = $('~>' / '~<')

bpPin = '{' pinID:bpPinID '}'
		{ return pinID; }

bpPinID = $( [abcdef] [abcdefhjklmnprstuv] [12] )

macroRef = '[' head:expr ids:selectorList ']'
		{ return AST('Macro', {head, ids}) }

selectorList = list:( ',' id:idList {return id} )*
		{ return AST('SelectorList', {list}); }

idList = list:( macroRef / idChunk )*
       		{ return AST('IDList', {list}) }

NC = '%NC%'	{ return AST('IDChunk', {name: '%NC%'}) }

idChunk = NC
/       name:$[-/#%.+& <>()a-z0-9=]+
		{ return AST('IDChunk', {name}) }


// like idChunk but allows ',' in the identifier in non-macro context
id = NC
/       name:[-/#%,.+*& <>()a-z0-9=^]+
		{ return AST('IDChunk', {name: text().replace(/\\[\n\r]\s*/g, '')}) }

expr = sum

sum = l:product _ op:$[-+] _ r:sum
		{ return AST(op, {l, r}) }
/	product

product = l:primary _ op:$[*/] _ r:product
		{ return AST(op, {l, r}) }
/	primary

primary = value:$number
		{ return AST('Value', {value}) }
/	'(' _ val:sum _ ')'
		{ return val }
/	macroName

number = $[0-9]+

macroName = name:simpleID
		{ return AST('IDChunk', {name}) }

simpleID = $[a-zA-Z0-9]+

net = '%NC%'	{ return AST('NoConnect', {text: text()}) }
/	[01]	{ return AST('Value', {value: parseInt(text(), 2), text: text()}) }
/	list:( macroRef / idWith_ )+
		{ return AST('IDList', {list, text: text()}) }

idWith_ = ( '\\' EOL _ )* id:id
		{ return id }

EOL "end of line" = '\r\n' / '\r' / '\n'

blankLines = (_ EOL)+

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' ( !EOL . )*  /   '/*' ( !'*/' . )* '*/'   )*
