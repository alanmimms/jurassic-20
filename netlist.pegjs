{
}

board = p:page+ { return {t: 'Board', pages: p } }

page = p:pageDef n:nodeDef+
		{ p.nodes = n; return p }

pageDef = 'Page' _ ':' _ name:$( [^\r\n, ]+ ) _ ',' _ pdfRef:$( ( !EOL . )+ )  EOL+
		{ return {t: 'Page', name, pdfRef} }

nodeDef = h:nodeHead p:pinDef+
		{ h.pins = p; return h }

nodeHead = !'Page' name:bareID _ ':' _ type:$([^ \t]+) _ desc:$( (!EOL .)+ ) EOL+
		{ return {t: 'Chip', name, type, desc} }

pinDef = [ \t]+ name:bareID _ dir:direction _ net:net _ EOL+
		{ return {t: 'Pin', name, dir, net} }

direction = $( '>' / '<' / '<>' )

macroRef =  '[' _ head:expr _ ids:selectorList ']'
		{ return {t: '[]', head, ids} }

selectorList = list:( ',' _ ( macroRef / idChunk )+ )*
		{ return list[2] }

bareID = [-/#=a-zA-Z]+ [-/#= a-zA-Z0-9]*
		{ return text().trim() }

idChunk = name:( '\\' EOL _ / [-/# a-zA-Z0-9=] )+
		{ return {t: 'IDchunk', name: text().replace(/\\[\n\r]\s*/g, '')} }

expr = sum

sum = l:product _ op:( '+' / '-' ) _ r:sum
		{ return {t: op, l, r} }
/	product

product = l:primary _ op:('*' / '/') _ r:product
		{ return {t: op, l, r} }
/	primary

primary = [0-9]+
		{ return {t: '#', value: parseInt(text(), 10)} }
/	'(' _ val:sum _ ')'
		{ return val }
/	macroName

macroName = name:$( [a-zA-Z0-9]+ )
		{ return {t: 'id', name} }

net = '%NC%'	{ return {t: '%NC%'} }
/	[01]	{ return {t: '#', value: parseInt(text(), 2)} }
/	macroRef
/	idChunk

EOL "end of line" = '\r\n' / '\r' / '\n'

_ "whitespace or comments"
=	(   [ \t]+   /    '\\' EOL    /    '//' (!EOL .)*   /   '/*' (!'*/' .)* '*/'   )*
