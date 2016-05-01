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

nodeHead = chip:ID _ ':' _ desc:$( (!EOL .)+ ) EOL+
					{ return ast('Chip').set({chip, desc}) }

pinDef = _ name:bareID '=' _ net:( identifier / operand ) _ EOL+
					{ console.log("pinDef name=", name);
					  return ast('Pin').set({name, net}) }

macroRef =  '[' _ head:netExpr _ nets:( ',' $( [^,\]\n\r]+ ) )* ']'
					{ return ast('Macro')
					    .add(unroll(head, ast('case').set({text: nets}), 1))
					}

identifier = [-/a-zA-Z]+ ( macroRef / [-/ a-zA-Z0-9] )*
					{ return ast('Identifier').set({name: text()}) }
/	macroRef

bareID = [-/a-zA-Z]+ [-/ a-zA-Z0-9]*	{ return ast('ID').set({name: text()}) }

netExpr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
					{ return ast(op).add(l).add(r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
					{ return ast(op).add(l).add(r) }
/	primary

primary = operand
/	'(' _ val:sum _ ')'		{ return val }


operand = id:identifier			{ return id }
/	[0-9]+				{ return ast('#').set({value: parseInt(text(), 10)}) }
/	'%NC%'				{ return ast('%NC%') }

ID = [-/ a-zA-Z0-9]+			{ return ast('ID').set({name: text()}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
