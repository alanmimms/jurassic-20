{
  const util = require('util');
  let unroll = options.util.makeUnroll(location, options);

//  let DBG = console.log;
  let DBG = function() {}

  let ast = function(a) {
    DBG("makeAST('" + a + "')");
    return options.util.makeAST(location, options)(a);
  }
}

netlist = pages:page+			{ return ast('Netlist').add(pages) }

page = p:pageDef nodes:nodeDef+		{ p.add(nodes); return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  EOL+
					{ return ast('Page').set({name, pdfRef}) }

nodeDef = head:nodeHead pins:pinDef+	{ return head.add(pins) }

nodeHead = name:bareID _ ':' _ desc:$( (!EOL .)+ ) EOL+
					{ return ast('Chip').set({name, desc}) }

pinDef = _ name:bareID ':' _ net:operand _ EOL+
					{ return ast('Pin').set({name}).add(net) }

macroRef =  '[' _ head:expr _ nets:( ',' c:( idChunk / macroRef )+ { return c[0] }  )* ']'
					{ return ast('[]')
					    .add(head)
					    .add(nets)
					}

macroSeg = seg:$( ( '\\' EOL _ / [-/# a-zA-Z0-9=] )+ )
					{ return seg.replace(/\\[\n\r]/g, '') }

bareID = [-/#=a-zA-Z]+ [-/#= a-zA-Z0-9]*
					{ return text() }

idChunk = ( '\\' EOL _ / [-/# a-zA-Z0-9=] )+
					{ let t = text().replace(/\\[\n\r]\s*/g, '');
					  return ast('IDchunk').set({name: t})
					}

expr = s:sum				{ return s }

sum = l:product _ op:( '+' / '-' ) _ r:sum
					{ return ast(op).add(l).add(r) }
/	product

product = l:primary _ op:('*' / '/') _ r:product
					{ return ast(op).add(l).add(r) }
/	p:primary			{ return p }

primary = [0-9]+			{ return ast('#').set({value: 
						parseInt(text(), 10)}) }
/	macroName
/	'(' _ val:sum _ ')'		{ return val }


macroName = [a-zA-Z0-9]+		{ return ast('id').set({name: text()}) }

operand = '%NC%'			{ return ast('%NC%') }
/	m:macroRef			{ return m }
/	chunks:( macroRef / idChunk )*	{ return ast('ID').add(chunks) }
/	[0-9]+				{ return ast('#').set({value:
						 parseInt(text(), 10)}) }

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
