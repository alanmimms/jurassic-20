{
  let unroll = options.util.makeUnroll(location, options);

  let DBG = console.log;
//  let DBG = function() {}

  let ast = function(a) {
    DBG("makeAST('" + a + "')");
    return options.util.makeAST(location, options)(a);
  }
}

netlist = pages:page+			{ return pages }

page = p:pageDef nodes:nodeDef+		{ p.nodes = nodes; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  EOL+
					{ return ast('Page').set({name, pdfRef}) }

nodeDef = head:nodeHead pins:pinDef+	{ return head.set({pins}) }

nodeHead = chip:ID _ ':' _ desc:$( (!EOL .)+ ) EOL+
					{ return ast('Chip').set({chip, desc}) }

pinDef = _ name:bareID '=' _ net:operand _ EOL+
					{ return ast('Pin').set({name, net}) }

macroRef =  '[' _ head:netExpr _ nets:( ',' ( idChunk / macroRef )+  )* ']'
					{ return ast('Macro')
					    .set({parts: unroll(head, nets, 1)})
					}

macroSeg = seg:$( ( '\\' EOL _ / [^\[\],\n\r] )+ )
					{ DBG(`macroSeg='${seg}'`); 
					  return seg.replace(/\\[\n\r]/g, '') 
					}
					  
identifier = macroRef
/	[-/a-zA-Z]+ ( macroRef / idChunk )*
					{ return ast('Identifier').set({name: text()}) }

bareID = [-/a-zA-Z]+ [-/ a-zA-Z0-9]*	{ return ast('ID').set({name: text()}) }

idChunk = $( ( '\\' EOL _ / [-/ a-zA-Z0-9=] )+ )
					{ DBG(`idChunk='${text()}'`); 
					  return text().replace(/\\[\n\r]/g, '') 
					}

netExpr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
					{ return ast(op).add(l).add(r)
					}
/	product

product = l:primary _ op:('*' / '/') _ r:product
					{ return ast(op).add(l).add(r) 
					}
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
