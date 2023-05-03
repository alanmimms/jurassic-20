{
  const util = require('util');

  function AST(nodeType, props) {
//    console.log(`${nodeType}: ${require('util').inspect(props, {depth: 9})}`);
    const loc = location();
    loc[util.inspect.custom] = function() {
      return `@${this.start.line}:${this.start.column}:${this.start.offset}..${this.end.line}:${this.end.column}:${this.end.offset}`;
    }
    return {nodeType, location: loc, ...props};
  }
}


compileable = (_ EOL )* b:(backplane+ / board) { return b }

backplane = 'Backplane' _ ':' _
	macros:( '{' _ m:macroDef* '}' _ {return m} )?
	name:simpleID _ EOL
	slots:slotDef+
                { return AST('Backplane', {name, macros, slots}) }

slotDef = 'Slot' _ n:number _ ':' _ board:slotContent blankLines
                { return AST('Slot', {n, board, bpPins: {}}) }

slotContent = macros:( '{' _ m:macroDef* '}' {return m} )? _
	id:simpleID _ comments:$( !EOL . )*
                { return AST('ModuleID', {macros, id, comments}) }

macroDef = id:simpleID _ '=' _ value:number _
                { return AST('MacroDef', {id, value}) }

board = pages:page+ { return AST('Board', {pages}) }

page = p:pageDef n:chipDef*
		{ p.chips = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  blankLines
		{ return AST('Page', {name, pdfRef}) }

chipDef = h:chipHead p:pinDef+
		{ h.pins = p; return h }

chipHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL . )+ ) blankLines
		{ return AST('Chip', {name, type, desc}) }

pinDef = [ \t]+ pin:number _ dir:direction _ bpPin:$bpPin? net:net blankLines
		{ return AST('Pin', {pin, dir, bpPin: bpPin ? bpPin.trim() : null, net}) }

direction = $('~>' / '~<')

bpPin = $('{' bpPinID '}') _

bpPinID = $( [abcdef] [abcdefhjklmnprstuv] [12] )

macroRef =  '[' head:expr ids:selectorList ']'
		{ return AST('Macro', {head, ids}) }

selectorList = list:( ',' id:idList {return id} )*
		{ /* console.error('list', util.inspect(list)); */
		  return AST('SelectorList', {list}); }

idList = list:( macroRef / idChunk )*
       		{ return AST('IDList', {list}) }

bareID = [-/#=%.+_&()a-zA-Z^]+ [-/#=%.+_&<> a-zA-Z0-9^]*
		{ return text() }

idChunk = name:$[-/#%.+_&<> ()a-zA-Z0-9=]+
		{ return AST('IDChunk', {name}) }

// like idChunk but allows ',' in the identifier in non-macro context
id = name:( '\\' EOL _ / [-/#%,.+_&<> ()a-zA-Z0-9=^] )+
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

number = $([0-9]+)

macroName = name:$simpleID
		{ return AST('IDChunk', {name}) }

simpleID = $[a-zA-Z0-9]+

net = '%NC%'	{ return AST('NoConnect', {}) }
/	[01]	{ return AST('Value', {value: parseInt(text(), 2)}) }
/	list:( macroRef / id )+
		{ return AST('IDList', {list}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

blankLines = (_ EOL)+

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' ( !EOL . )*   /   '/*' ( !'*/' . )* '*/'   )*
