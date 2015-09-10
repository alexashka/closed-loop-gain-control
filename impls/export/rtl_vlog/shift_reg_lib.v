
/**
  1. нужно сделать шинным(временным будет массив)
  2. и длиной 1-N ноль - соединение напрямую - лучще 
  вставлять в основной код
  v_shift_registers #(
    .DELAY(),
  .WIDTH(`WIDTH)
  )(
    .clk(clk), .rst(rst), .clk_ena(clk_ena), 
    .si(), .so()
  );
  
*/
`include "vconst_lib.v"
/**
  abst. : сдвиговый регистр с паралл. загр (одной шиной)
    парал. выходом разр. такта, загр, сбросом
  
  conn. :
  shift_reg_width
    labdl_srwj(
      .clk(clk), .rst(rst), .clk_ena(clk_ena),
      // control
      .load(load), 
       // datastream
      .din(din), 
      .dfload(dfload),  // для загрузки
      // out. //
      .dout(dout),
      .doutbig(doutbig));  // выходные данные
*/
module shift_reg_width(
  clk, rst, clk_ena,
  // control
  load,
  // stream ///
  din,
  dfload,
  // out. //
  dout,
  doutbig  
);
  parameter NUM_REG = 2;  // число регистров
  input clk, rst, clk_ena;
  input load;
  input [`G_WIDTH-1:0] din;  // последовательные входные данные
  output [`G_WIDTH-1:0] dout;  // последовательные входные данные
  //
  input [`G_WIDTH*NUM_REG-1:0] dfload;  // данные для загрузки
  output [`G_WIDTH*NUM_REG-1:0] doutbig;  // данные для счтитыания
  
  // loc. ///
  wire [`G_WIDTH-1:0] intconn [NUM_REG-1:0];
  // conn. ///
  // первый регистр
  register_pe 
    label_pe0(
      .clk(clk), .rst(rst), .clk_ena(clk_ena),
      // control
      .load(load), 
      // datastream
      .datain(din), 
      .dforload(dfload[`G_WIDTH-1:0]),  // под вопросом! т.к. вообще то он последний
        // в модуле
      .dataout(intconn[0])
    );
  assign doutbig[`G_WIDTH-1:0] = intconn[0];
  // остальные
  genvar g;
  generate for(g = 1; g < NUM_REG; g = g+1) begin : label
    register_pe 
      label_pej(
        .clk(clk), .rst(rst), .clk_ena(clk_ena),
        // control
        .load(load), 
        // datastream
        .datain(intconn[g-1]), 
        .dforload(dfload[(g+1)*(`G_WIDTH)-1:g*(`G_WIDTH)]),  // inputs
        .dataout(intconn[g])
      );
  assign doutbig[(g+1)*(`G_WIDTH)-1:g*(`G_WIDTH)] = intconn[g];
  end endgenerate
  // out. ///
  assign dout = intconn[NUM_REG-1];
endmodule

module v_shift_registers(
  clk, rst, clk_ena, 
  si, so
);
  parameter DELAY = 1;  // 1 - min! число тактов на которое можно сдвинуть
  parameter WIDTH = 8;
  
  input clk, rst, clk_ena;
  input [WIDTH-1:0] si;  // однобитный
  output [WIDTH-1:0] so;
  
  // local/
  reg [DELAY+1-1:0] tmp [WIDTH-1:0];  // 
  integer i;  // нужно для цикла
  // logic
  always @(posedge clk or posedge rst)
    begin
    if(rst) begin
        for(i = 0; i < WIDTH; i = i+1) begin 
      tmp[i] = 'b0; 
      end
    end
      else if(clk_ena) begin
        for(i = 0; i < WIDTH; i = i+1) begin
      tmp[i] = {tmp[i][DELAY+1-2:0], si[i]}; 
      end 
    end  // 
  end
  // out
  genvar g;
  generate for(g = 0; g < WIDTH; g = g+1) begin : asfas
    assign so[g] = tmp[g][DELAY+1-1];
  end endgenerate
endmodule


/*
// подстроечный регистр сдвига
// может лучше сдалать из станд см. альтеру
// сделать число регистров 0(!)-N
module shifter_buses(clk, rst, clk_ena, in, out);
  parameter LEN_DELAY = 3;  // сколько регистров !! может ругатсяна вложенность
  input clk, rst, clk_ena;
  input [`WIDTH-1:0] in; 
  output [`WIDTH-1:0] out;
  //
  wire [`WIDTH-1:0] connectors [0:LEN_DELAY-1-1];  
  // соединителей на один меньше чем задержек
  a_dff #(`WIDTH) label_g1(clk, rst, clk_ena, in, connectors[0]);
  genvar g;
  generate for(g = 0; g < LEN_DELAY-1-1; g = g+1) begin : asdfasdf
    a_dff #(`WIDTH) label_g(clk, rst, clk_ena, connectors[g], connectors[g+1]);
  end endgenerate 
  // выходной регистр
  a_dff #(`WIDTH) label_g2(clk, rst, clk_ena, connectors[LEN_DELAY-1-1], out); 
endmodule*/
