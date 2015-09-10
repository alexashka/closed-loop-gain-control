/**
  File: mux_lib.v
  Abstract: Ѕиблиотека с мультиплексорами.
  
*/

/**
  Abstract: ћультиплексор 2xWIDTH в 1
  
  Connect:
  mux2bus #(.WIDTH()) 
    label_mux2b1(
      .sel(), 
    .A0(), .A1(), 
    .Z());
*/
module mux2bus(sel, A0, A1, Z);
  parameter WIDTH = 8;
  input sel;
  input [WIDTH-1:0] A0, A1;
  output reg[WIDTH-1:0] Z;
  // logic
  always @(sel or A0 or A1)
    begin
    if(sel == 1)
      Z = A1;
    else
      Z = A0;
  end
endmodule
