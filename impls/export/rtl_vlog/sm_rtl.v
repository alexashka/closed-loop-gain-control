/**
  file : sm_rtl.v

  abs. :
  
  vers. : 3 - сброс счетчика происходит по началу пакета и по концу
    это важно, т.к. сброс по началу прочему-то не всегда происходит
  
  feat. : 
    1. clk_ena - Ok!
   2. ширина окна TIME+1 т.к. предполагаем, что один такт на загрузку
    
  warrn. : При реализации при ошибках обратить внимание на операция загрузки 
      с предыдущей стадии(см. vers. )
  
  power :
    все работает в рамках окна
*/
module sm_control_v3(
  clk, rst, 
  clk_ena,
  // control
  first,  // разрешение загрузки в выходной регистр первого блока
  // master
  windows,  // окно для работы блока
  //count,
  last  // разрешение загрузки в свой выходной регистр
);
  parameter WIDTH = 8;
  parameter MOD_COUNT = 14;
  
  /// Main ///
  input clk, rst;
  
  // out.
  output windows; 
  output last;
  //output [(WIDTH-1):0] count;
  
  /// Enabling ///
  input clk_ena;
  input first; 
    wire carry;  // перенос счетчика
    wire oor_ena = first | carry;
    wire co_ena = windows & clk_ena;
    wire dff_ena = oor_ena & clk_ena;
    wire count_load = first | carry;
  
  /// local
  wire [WIDTH-1:0] dfload = 0; 
  wire adf_in;  // вход разрешающего триггера
  wire adf_out;
  
  // отсчетчик
  counter_load 
  //counter_load_dbus
  #(
    .MOD_COUNT(MOD_COUNT),
    .WIDTH(WIDTH)) 
    label_cnt_load(
      .clk(clk), .rst(rst), 
      .clk_ena(co_ena),
      // control 
      .load(
      count_load),
      //first),  // загрузить данные
      // out
      .carry(carry),  // перенесо счетчика
      //.count(count),
      // datastream
      .dfload(dfload));  // data for load
  
  // триггер разрешения работы 
  a_dff #(
    .WIDTH(WIDTH)) 
    label_aff(
      .clk(clk), .aclr(rst), 
      .ena(dff_ena),
      .data(adf_in), 
      .q(adf_out));
    
  // comb. logic 
  assign adf_in = ~carry | first;

  // out
  assign last = carry; 
  assign windows = first | adf_out;
endmodule

