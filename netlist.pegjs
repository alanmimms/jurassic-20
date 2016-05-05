{
  const unroll = options.util.makeUnroll(location, options);

//  const DBG = console.log;
  const DBG = function() {}

  const ast = function(a) {
    DBG("makeAST('" + a + "')");
    return options.util.makeAST(location, options)(a);
  }

  const asty = parser.asty;
}

board = pages:page+			{ return ast('Board').add(pages) }

page = p:pageDef nodes:nodeDef+		{ p.add(nodes); return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  EOL+
					{ return ast('Page').set({name, pdfRef}) }

nodeDef = head:nodeHead pins:pinDef+	{ return head.add(pins) }

nodeHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL .)+ ) EOL+
					{ return ast('Chip').set({name, type, desc}) }

pinDef = [ \t]+ name:bareID _ dir:direction _ net:operand _ EOL+
					{ return ast('Pin').set({name, dir}).add(net) }

direction = $( '>' / '<' / '<>' )

macroRef =  '[' _ head:expr _ 
		nets:( ',' _ c:( idChunk / macroRef )+ )* ']'
					{ return ast('[]')
					    .add(head)
					    .add(nets.filter(n => asty.isA(n)));
					}

bareID = [-/#=a-zA-Z]+ [-/#= a-zA-Z0-9]*
					{ return text().trim() }

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
