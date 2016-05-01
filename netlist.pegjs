{
  let unroll = options.util.makeUnroll(location, options);

//  let DBG = console.log;
  let DBG = function() {}

  let ast = function(a) {
    DBG("makeAST('" + a + "')");
    return options.util.makeAST(location, options)(a);
  }
}

netlist = pages:page+			{ return pages }

page = p:pageDef EOL+ nodes:nodeDef+		{ p.nodes = nodes; return p }

pageDef = 'Page' _ ':' _ name:$( [a-zA-Z0-9-]+ ) _ ',' _ pdfRef:ID _
					{ return ast('Page').set({name, pdfRef}) }

nodeDef = head:nodeHead pins:pinDef+	{ return head.set({pins}) }

nodeHead = chip:ID _ ':' _ desc:$( (!EOL .)+ ) EOL+ { return ast('Chip').set({chip, desc}) }

pinDef = _ name:ID _ '=' _ net:netExpr _ EOL+
					{ return ast('Pin').set({name, net}) }

macro =  '[' _ head:netExpr _ nets:( ',' _ identifier _ )+ ']'
					{ return ast('Selector')
					    .add(unroll(head, nets, 2))
					}
/	'[' _ expr:netExpr _ ']'	{ return ast('Macro').set({expr}) }

// First child of Selector node is the selector, the rest are cases
selector = [-/a-zA-Z0-9]* ( [-/ a-zA-Z0-9]* macro* )*
					{ return ast('Selector').set({value: text()}) }

netExpr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
					{ return ast(op).add(l).add(r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
					{ return ast(op).add(l).add(r) }
/	primary

primary = operand
/	'(' _ val:sum _ ')'		{ return val }


operand = id:ID
/	[0-9]+				{ return ast('#').set({value: parseInt(text(), 10)}) }
/	%NC%				{ return ast('%NC%') }

identifier = [-/a-zA-Z]+ ( [-/ a-zA-Z0-9] )*
					{ return ast('Identifier').set({name: text()}) }

ID = [-/ a-zA-Z0-9]+			{ return ast('ID').set({name: text()}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
