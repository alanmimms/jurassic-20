  bit [0:9] a;
  bit d, nen, nwrite, q;

  mc10415a testRAM(.a0(a[0]), .a1(a[1]), .a2(a[2]), .a3(a[3]), .a4(a[4]),
		   .a5(a[5]), .a6(a[6]), .a7(a[7]), .a8(a[8]), .a9(a[9]), .*);

  initial begin
    nwrite <= 1;
    nen <= 1;

    repeat (10) @(posedge clk);

    a <= 0;
    d <= 1;
    nwrite <= 0;
    nen <= 0;

    repeat (2) @(posedge clk);
    nwrite <= 1;

    repeat (2) @(posedge clk);
    a <= 42;
    d <= 1;
    nwrite <= 0;
    nen <= 0;

    repeat (2) @(posedge clk);
    nwrite <= 1;
    a <= 0;

    repeat (2) @(posedge clk);
    a <= 1;

    repeat (2) @(posedge clk);
    a <= 2;

    repeat (2) @(posedge clk);
    a <= 42;

    repeat (2) @(posedge clk);
    a <= 43;
  end

