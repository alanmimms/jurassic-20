// MC10181 from Fairchild ECL datasheet F10181.pdf.
//
// S8 S4 S2 S1   BOOLE=1 C0=X 	BOOLE=0 C0=0   BOOLE=0 C0=1
//-----------------------------------------------------------
//  0  0  0  0   ~A          	A              A+1
//  0  0  0  1   ~A|~B       	A+(A&~B)       A+(A&~B)+1
//  0  0  1  0   ~A|B        	A+(A&B)        A+(A&B)+1
//  0  0  1  1   1111        	A+A            A+A+1
//  0  1  0  0   ~A&~B       	A|B            (A|B)+1
//  0  1  0  1   ~B          	(A|B)+(A&~B)   (A|B)+(A&~B)+1
//  0  1  1  0   ~(A^B)      	A+B            A+B+1
//  0  1  1  1   A|~B        	(A|B)+A        (A|B)+A+1
//  1  0  0  0   ~A&B        	A|~B           (A|~B)+1
//  1  0  0  1   A^B         	A-B-1          A-B
//  1  0  1  0   B           	(A|~B)+(A&B)   (A|~B)+(A&B)+1
//  1  0  1  1   A|B         	(A|~B)+A       (A|~B)+A+1
//  1  1  0  0   0000        	1111           0000
//  1  1  0  1   A&~B        	(A&~B)-1       A&~B
//  1  1  1  0   A&B         	(A&B)-1        A&B
//  1  1  1  1   A           	A-1            A
module mc10181(input bit s8,s4,s2,s1, boole, cin,
               input bit a8,a4,a2,a1, b8,b4,b2,b1,
               output bit f8,f4,f2,f1, cg, cp, cout);

  bit [3:0] G, P;
  bit notGG;

  bit [3:0] A;
  bit [3:0] B;

  always_comb begin
    A = {a8,a4,a2,a1};
    B = {b8,b4,b2,b1};

    G = ~(~({4{s8}} | B | A) | ~({4{s4}} | A | ~B));
    P = ~(~(~B | {4{s2}}) | ~({4{s1}} | B) | ~A);

    f8 = ~(G[3] ^ P[3] ^ (~(boole | G[2]) |
			  ~(boole | P[2] | G[1]) |
			  ~(boole | P[2] | P[1] | G[0]) |
			  ~(boole | P[2] | P[1] | P[0] | cin)));
    f4 = ~(G[2] ^ P[2] ^ (~(boole | G[1]) |
			  ~(boole | P[1] | G[0]) |
			  ~(boole | P[1] | P[0] | cin)));
    f2 = ~(G[1] ^ P[1] ^ (~(boole | G[0]) |
			  ~(boole | P[0] | cin)));
    f1 = ~(G[0] ^ P[0] ^ (~(boole | cin)));

    notGG = ~G[3]  |
            ~(P[3] | G[2]) |
            ~(P[3] | P[2]  | G[1]) |
            ~(P[3] | P[2]  | P[1]  | G[0]);

    cg = ~notGG;
    cp = ~(P[3] | P[2] | P[1] | P[0]);
    cout = ~(notGG | ~(P[3] | P[2] | P[1] | P[0] | cin));  
  end
endmodule // mc10181
