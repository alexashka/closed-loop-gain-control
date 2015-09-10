 /*
   stage_wrapper_tb.v
   Abstract: оболочка для блока при конвееризации
      
*/
`include "vconst.v"
`timescale 1 ns / 100 ps
`define WIDTH 8
`define LEN_WORD 15
`define IN_WIDTH 8
`define OUT_WIDTH 8
 module stage_wrapper_tb;
  reg clk_tmp, rst, clk_ena;
  wire clk_t;
  wire clk;
  //wire [`WIDTH-1:0] rsin; // вход данных в стенд - выход для кодера
  //reg [`WIDTH-1:0] rsout;
  
  // stream-control and interface 
  wire source_val;    
  wire source_sop;  
    reg source_sop_tmp;  
  wire source_eop;
    reg source_eop_tmp;  
  // analysis 
  wire sink_val;  // окно разрешения  
  wire sink_sop;  // начало пакета    
  wire sink_eop;  // конец пакета    
  wire source_ena;  
    assign source_ena = 1;  // пусть пока без эксцессов
   
  wire [`IN_WIDTH-1:0] pin, pin_latch;
  reg [`OUT_WIDTH-1:0] pout;
  
  // local
  reg [2*`WIDTH-1:0] ibig;  // для счетчика больших циклов
  reg [2*`WIDTH-1:0] isbig;  // для счетчика адресов маски
  reg [`WIDTH-1:0] MemV[`LEN_WORD-1:0];
  
  /// Connecting 
  stage_wrapper_rtl label_sw(
   .clk(clk), .rst(rst), .clk_ena(clk_ena),
   
   // control
   // slave
   .first(source_eop),
   .windows(windows),
   // master
   .last(last),
   // datastream
   // in
   .pin(pout), // параллельная шина синдромов
   .pin_latch(pin_latch),
   // out
   .pout(pin)
   
   // test
   
 );
  // stream-control and interface 
  initial begin // общие сигналы (в реализуемом они будут внешними)
    clk_tmp = 0;  rst = 0;   clk_ena = 0;
  // сброс пусть будет здесь
  #2;  rst = 1;  #3;  rst = 0;
  end
  always #20 clk_tmp = ~clk_tmp;  // тактовый генератор 
  assign #15 clk = clk_tmp;
  
  initial begin
    //$readmemb("rs_255_full8_roots.vec ", MemV);  // dvbt без ошибок
  $readmemb("rs_drm_tb.vec", MemV); // 8 ошибок вроде бы
    // загрузка в память слова(пока одного)
  ibig = 'b0;  isbig = 'b0;
    source_sop_tmp = 'b0;  source_eop_tmp = 'b0;    
  end
  initial
    begin
    //#10; clk_ena = 1; #(`LEN_WORD*20); clk_ena = 0; #80; clk_ena = 1;
  clk_ena = 1;
  end
  // чтение памяти
  always @(posedge clk_tmp) begin 
  pout <= MemV[ibig%`LEN_WORD];  
  end
  
  always @(posedge clk_tmp) begin 
  // рамки слова
  if(ibig%`LEN_WORD == 0)  // начало пакета
    source_sop_tmp = 1;
    else
      source_sop_tmp = 0;
  if(ibig%`LEN_WORD == `LEN_WORD-1)  // начало пакета
    source_eop_tmp = 1;
    else
      source_eop_tmp = 0;
  end
  
  always @(posedge clk_tmp) begin 
  if(clk_ena)
    ibig = ibig+1;
  end
  // адрес для чтения из памяти маски разрешения
  always @(posedge clk_tmp) begin 
    isbig = isbig+1;
  end
  // out
  assign source_val = clk_ena;
  assign source_sop = source_sop_tmp & clk_ena;
  assign source_eop = source_eop_tmp & clk_ena;

endmodule
 
 