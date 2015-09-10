/**
  File: arif_lib.v
  
  Abstract: Ѕлоки амифметических операций. 

*/

`include "vconst_lib.v"
/** 
  Abstract: Cумматор ! нужно подумать что со знаковым разр¤дом делать
    ! вроде пока беззнаковый
  Connect:
*/
module full_adder(
  a, b, 
  c
);
  input [`G_WIDTH-1:0] a, b;
  output [`G_WIDTH-1:0] c;
  // logic
  assign c = a+b;
endmodule

/**
  Abstract: Знаковый сумматор
  
  Connect:
  adder_signed label_add_sig(
   .a(), .b(), 
   .c());
*/
module adder_signed(a, b, c);
  input signed [`G_WIDTH-1:0] a, b;
  output signed [`G_WIDTH-1:0] c;
  // logic
  assign c = a+b;
endmodule
