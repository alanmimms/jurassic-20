{
  function AST(t, props) {
    return {t, location: location(), ...props};
  }
}


board = pages:page+ { return AST('Board', {pages}) }

page = p:pageDef n:chipDef+
		{ p.chips = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  (_ EOL)+
		{ return AST('Page', {name, pdfRef}) }

chipDef = h:chipHead p:pinDef+
		{ h.pins = p; return h }

chipHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL .)+ ) (_ EOL)+
		{ return AST('Chip', {name, type, desc}) }

pinDef = [ \t]+ name:bareID _ dir:direction _ bpPin:bpPin? net:net (_ EOL)+
		{ return AST('Pin', {name, dir, bpPin, net}) }

direction = $('~<>' / '~>' / '~<')

bpPin = $('{' bareID '}') _

macroRef =  '[' _ head:expr _ ids:selectorList ']'
		{ return AST('Macro', {head, ids}) }

selectorList = list:( ',' _ idList )*
		{ return AST('SelectorList', {list: list.map(e => e[2])}) }

idList = list:( macroRef / idChunk )+
       		{ return AST('IDList', {list}) }

bareID = [-/#=%.+_&a-zA-Z]+ [-/#=%.+_&<> a-zA-Z0-9]*
		{ return text().trim() }

idChunk = name:( '\\' EOL _ / [-/#%.+_&<> a-zA-Z0-9=] )+
		{ return AST('IDChunk', {name: text().replace(/\\[\n\r]\s*/g, '')}) }

// like idChunk but allows ',' in the identifier in non-macro context
id = name:( '\\' EOL _ / [-/#%,.+_&<> a-zA-Z0-9=] )+
		{ return AST('IDChunk', {name: text().replace(/\\[\n\r]\s*/g, '')}) }

expr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
		{ return AST(op, {l, r}) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
		{ return AST(op, {l, r}) }
/	primary

primary = [0-9]+
		{ return AST('Value', {value: parseInt(text(), 10)}) }
/	'(' _ val:sum _ ')'
		{ return val }
/	macroName

macroName = name:$( [a-zA-Z0-9]+ )
		{ return AST('IDChunk', {name}) }

net = '%NC%'	{ return AST('NoConnect', {}) }
/	[01]	{ return AST('Value', {value: parseInt(text(), 2)}) }
/	list:( macroRef / id )+
		{ return AST('IDList', {list}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
