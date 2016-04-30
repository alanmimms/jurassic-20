{
  let unroll = options.util.makeUnroll(location, options);

//  let DBG = console.log;
  let DBG = function() {}

  let ast = function(a) {
    DBG("makeAST('" + a + "')");
    return options.util.makeAST(location, options)(a);
  }
}

nelist = pages:page+			{ return pages }

page = p:pageDef nodes:nodeDef+		{ p.nodes = nodes; return p }

pageDef = 'Page' _ ':' _ name:ID _ ',' _ pdfRef:ID _ EOL
					{ return ast('Page').set({name, pdfRef}) }

nodeDef = head:nodeHead pins:pinDef+	{ return head.set({pins}) }

nodeHead = chip:ID _ ':' _ desc:ID _ EOL { return ast('Chip').set({chip, desc}) }

pinDef = _ name:ID _ '=' _ net:netName _ EOL
					{ return ast('Pin').set({name, net}) }

netName = ID				{ return ast('ID').set({name: text()}) }
/	selector

selector = '[' _ head:netExpr _ nets:( ',' _ netExpr _ )+ ']'
					{ return ast('Selector')
					    .add(unroll(head, nets, 2))
					}

netExpr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
					{ return ast(op).add(l).add(r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
					{ return ast(op).add(l).add(r) }
/	primary

primary = operand
/	'(' _ val:sum _ ')'		{ return val }


operand = ID
/	dig:[0-9]+			{ return parseInt(dig.join(''), 10) }


ID = [-a-zA-Z] [-a-zA-Z0-9]*		{ return ast('ID').set({name: text()}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /   '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
