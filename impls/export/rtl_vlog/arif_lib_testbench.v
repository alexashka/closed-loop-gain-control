 /*
  Abstract: тесты для сумматоров
 */
 `include "vconst.v"
 module sum_tb;
  wire [`WIDTH-1:0] c;
  // stimuls
  reg signed [`WIDTH-1:0] a;
  reg signed [`WIDTH-1:0] b;
  
  adder_signed addsig(
   .a(a), .b(b), 
   .c(c));
  // logic
  initial begin
    a = -1;
  b = -4;
  end
endmodule
  