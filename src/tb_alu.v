`timescale 1ns/1ps
`define CLK_PERIOD 50
`define NO_VECTORS 15
`include "alu.v"


module tb_alu;
  
  reg [63:0] key1 [0:255];
  reg [43:0] key2 [0:255];
  initial begin
    $readmemh("key_alu.txt",key1);
    $readmemh("key_alu2.txt",key2);
  end

  //test
  /*integer i;
  initial begin
    for (i=0; i<10; i=i+1)
      $display("%x",key[i]);
  end*/

  reg [31:0] opA,opB;
  reg [2:0] sel;
  wire [31:0] res;
  wire z,c,v;

  alu UUT(
    .opA(opA),
    .opB(opB),
    .sel(sel),
    .res(res),
    .z(z),
    .c(c),
    .v(v)
  );

  integer i,j;
  integer add,sub,band,bor,bnot;
  integer fz,fc,fv;
  reg [43:0] answer;
  initial begin

    //$vcdplusfile("tb_alu.vpd");
    //$vcdpluson;

    //init
    opA = 0;
    opB = 0;
    add = 0;
    sub = 0;
    band = 0;
    bor = 0;
    bnot = 0;
    fz = 0;
    fc = 0;
    fv = 0;

    #(`CLK_PERIOD);
    j = 0;
    //loop: add (000)
    sel = 3'b000;
    for (i=0; i<`NO_VECTORS; i=i+1) begin
      {opA,opB} = key1[i];
      #(`CLK_PERIOD);
      answer = key2[j];
      if (res == answer[43:12])
        add = add + 1;
      if (z == answer[8])
        fz = fz + 1;
      if (c == answer[4])
        fc = fc + 1;
      /*else begin
        $display("%X",key1[i]);
      end*/
      if (v == answer[0])
        fv = fv + 1; 
      j = j + 1;
    end
    //loop: sub (001)
    sel = 3'b001;
    for (i=0; i<`NO_VECTORS; i=i+1) begin
      {opA,opB} = key1[i];
      #(`CLK_PERIOD);
      answer = key2[j];
      if (res == answer[43:12])
        sub = sub + 1;
      if (z == answer[8])
        fz = fz + 1;
      if (c == answer[4])
        fc = fc + 1;
      /*else begin
        $display("%X",key1[i]);
      end*/
      $display("%X",{res,3'd0,z,3'd0,c,3'd0,v});
      if (v == answer[0])
        fv = fv + 1; 
      j = j + 1;
    end

    //loop: and (010)
    sel = 3'b010;
    for (i=0; i<`NO_VECTORS; i=i+1) begin
      {opA,opB} = key1[i];
      #(`CLK_PERIOD);
      answer = key2[j];
      if (res == answer[43:12])
        band = band + 1;
      if (z == answer[8])
        fz = fz + 1;
      if (c == answer[4])
        fc = fc + 1;
      if (v == answer[0])
        fv = fv + 1; 
      j = j + 1;
    end

    //loop: or  (011)
    sel = 3'b011;
    for (i=0; i<`NO_VECTORS; i=i+1) begin
      {opA,opB} = key1[i];
      #(`CLK_PERIOD);
      answer = key2[j];
      if (res == answer[43:12])
        bor = bor + 1;
      if (z == answer[8])
        fz = fz + 1;
      if (c == answer[4])
        fc = fc + 1;
      if (v == answer[0])
        fv = fv + 1; 
      j = j + 1;
    end

    //loop: not (100)
    sel = 3'b100;
    for (i=0; i<`NO_VECTORS; i=i+1) begin
      {opA,opB} = key1[i];
      #(`CLK_PERIOD);
      answer = key2[j];
      if (res == answer[43:12])
        bnot = bnot + 1;
      if (z == answer[8])
        fz = fz + 1;
      if (c == answer[4])
        fc = fc + 1;
      if (v == answer[0])
        fv = fv + 1; 
      j = j + 1;
    end
   
    $display("Add:      %d/15",add);
    $display("Sub:      %d/15",sub);
    $display("And:      %d/15",band);
    $display("Or:       %d/15",bor);
    $display("Not:      %d/15",bnot);
    $display("Zero:     %d/75",fz);
    $display("Carry:    %d/75",fc);
    $display("Overflow: %d/75",fv);

    $display("ALU add: %d pts",add/3.0); 
    $display("ALU sub: %d pts",sub/3.0);
    $display("ALU bit: %d pts",(band+bor+bnot)/9.0);
    $display("ALU flg: %d pts",(fz/75)+(2*(fc/75))+(2*(fv/75)));
  end 

`ifdef SDF
  initial begin
    //$sdf_annotate("../mapped/alu_mapped.sdf",alu);
    $sdf_annotate("../check/alu_mapped.sdf",alu);
  end
`endif
    
endmodule
