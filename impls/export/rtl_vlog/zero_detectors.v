/**
  File: zero_detectors.v
  
  Abstract: различные вариатнты детекторов нуля

*/
`include "vconst_lib.v"
/** 
  Abstract: Детектор нуля 
  
  Feature: Выход дублирован в шину
  
  Connect:
  zero_detect 
    label_zd_bus(.in(), .out());
*/
module zero_detect(in, out);
  parameter WIDTH = 8;
  ///
  input [WIDTH-1:0] in;  
  output [WIDTH-1:0] out;  // пусть шина будет, потом проще соединять будет
  // local
  wor rez;  // по сути результат
  genvar g;
  assign rez = in[0];
  generate for(g = 1; g < WIDTH; g = g+1) begin : adsf  
    assign rez = in[g];
  end  endgenerate
  // out/
  generate for(g = 0; g < WIDTH; g = g+1) begin : adsfjo
    assign out[g] = ~rez;
  end  endgenerate
endmodule

/** 
  Abstract: детектор нуля с однобитным выходом

  Connect:
  zero_detect_owire 
    label_zd_owire(.in(), .out());
  
*/
module zero_detect_owire(in, out);
  input [`WIDTH-1:0] in;  
  output out;  // пусть шина будет, потом проще соединять будет
  // local
  wor rez;  // по сути результат
  genvar g;
  assign rez = in[0];
  generate for(g = 1; g < `WIDTH; g = g+1) begin : adsf  
    assign rez = in[g];
  end  endgenerate
  // out
  assign out = ~rez;
endmodule

/** 
  Abstract: Детектор нуля с однобитным выходом. По сути
    схема OR на много входов.
  
  Feature:
  
  Connect:
  zero_detect_owire_not 
    label_not_zd(
      .in(in), 
      .out(out)
    );
*/
module zero_detect_owire_not(
  in, 
  out
);
  input [`WIDTH-1:0] in;  
  output out;  // пусть шина будет, потом проще соединять будет
  // local
  wor rez;  // по сути результат
  genvar g;
  assign rez = in[0];
  generate for(g = 1; g < `WIDTH; g = g+1) begin : adsf  
    assign rez = in[g];
  end  endgenerate
  // out
  assign out = rez;  // нет инверсии
endmodule

