{
  const {AST} = options;

  // Pass our location() function in to the AST module.
  AST.location = location;
}


board = p:page+ { return new AST.Board(p) }

page = p:pageDef n:chipDef+
		{ p.chips = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  (_ EOL)+
		{ return new AST.Page(name, pdfRef) }

chipDef = h:chipHead p:pinDef+
		{ h.pins = p; return h }

chipHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL .)+ ) (_ EOL)+
		{ return new AST.Chip(name, type, desc) }

pinDef = [ \t]+ name:bareID _ dir:direction _ bpPin:bpPin? net:net (_ EOL)+
		{ return new AST.Pin(name, dir, bpPin, net) }

direction = $('~<>' / '~>' / '~<')

bpPin = $('{' bareID '}') _

macroRef =  '[' _ head:expr _ ids:selectorList ']'
		{ return new AST.Macro(head, ids) }

selectorList = list:( ',' _ idList )*
		{ return new AST.SelectorList(list.map(e => e[2])) }

idList = list:( macroRef / idChunk )+
       		{ return new AST.IDList(list) }

bareID = [-/#=%.+_&a-zA-Z]+ [-/#=%.+_&<> a-zA-Z0-9]*
		{ return text().trim() }

idChunk = name:( '\\' EOL _ / [-/#%.+_&<> a-zA-Z0-9=] )+
		{ return new AST.IDChunk(text().replace(/\\[\n\r]\s*/g, '')) }

// like idChunk but allows ',' in the identifier in non-macro context
id = name:( '\\' EOL _ / [-/#%,.+_&<> a-zA-Z0-9=] )+
		{ return new AST.IDChunk(text().replace(/\\[\n\r]\s*/g, '')) }

expr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
		{ return new AST.Operator(op, l, r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
		{ return new AST.Operator(op, l, r) }
/	primary

primary = [0-9]+
		{ return new AST.Value(parseInt(text(), 10)) }
/	'(' _ val:sum _ ')'
		{ return val }
/	macroName

macroName = name:$( [a-zA-Z0-9]+ )
		{ return new AST.IDChunk(name) }

net = '%NC%'	{ return new AST.NoConnect() }
/	[01]	{ return new AST.Value(parseInt(text(), 2)) }
/	c:( macroRef / id )+
		{ return new AST.IDList(c) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
