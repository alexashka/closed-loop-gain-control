/**
  File: controlers_ifaces_lib.v
  
  Abstract: Контролирующая часть интерфейса эстафетной передачи.

*/

/**
  Abstract: 
  
  Notes job: 
    - получает импульс, покрывающий первый элемент
    потока данных
  - вырабатывает окно работы блока
  - и импульс покр. первый элем. получ. данных
  
  Feature: Выходной сигнал нужно защелкивать, как и данные, которые
    он сопровождает.
  
  Connect: 
  sm_control label_sm(
    .clk(clk), .rst(rst), .clk_ena(clk_ena),
    // control
    .first(first),  // разрешение загрузки в выходной регистр первого блока
    // master
  .windows(windows),
    .last(last)  // разрешение загрузки в свой выходной регистр
  );

*/
module sm_control(
  clk, rst, clk_ena,
  // control
  first,  // разрешение загрузки в выходной регистр первого блока
  // master
  windows,  // окно для работы блока
  last  // разрешение загрузки в свой выходной регистр
);
  parameter WIDTH = 8;
  parameter MOD_COUNT = 14;
  input clk, rst, clk_ena;
  input first; 
  output windows; 
  output last;
  // local
  wire carry;  // перенос счетчика
  wire load;  // команда загрузки данных
  wire [WIDTH-1:0] dfload; 
  wire oor_ena;
  wire adf_in;  // вход разрешающего триггера
  wire adf_out;
  
  counter_load #(.MOD_COUNT(MOD_COUNT)) 
    label_cnt_load(
      .clk(clk), .rst(rst), .clk_ena(windows),
      // control 
      .load(first),  // загрузить данные
      // out
      .carry(carry),  // перенесо счетчика
      // datastream
      .dfload(dfload)  // data for load
    );
  ///*
  a_dff #(.WIDTH(WIDTH)) label_aff(
    .clk(clk), .aclr(rst), .ena(oor_ena), 
    .data(adf_in), 
    .q(adf_out));  // 
     //* /
   // logic
   assign dfload = 0;
   assign adf_in = ~carry|first;
   assign oor_ena = first|carry;
   // out
   assign last = carry;
   assign windows = first|adf_out;
endmodule
 