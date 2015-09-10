/**
  Abstract: библиотека триггеров и регистров

*/
`include "vconst_lib.v"
/*
  триггер пока что с разрешением работы и асинхронным сбросом
  a_dff #(.WIDTH()) label_(
    .clk(), .aclr(), .ena(), 
  .data(), .q());
*/
module a_dff(clk, aclr, ena, data, q);
  parameter WIDTH = 8;
  input clk, aclr, ena; 
  input [WIDTH-1:0] data;
  output reg [WIDTH-1:0] q;
  // logic
  always @ (posedge clk or posedge aclr)
  begin
    if (aclr)
      q <= 1'b0;
    else if (ena)
      q <= data;
  end
endmodule
/**
  триггер с синхр. установкой и асинхронным сбросом
  dffe_flag gflag(
    .clk(clk), .rst(rst), .clk_ena(_ena), 
  .d(d));
  // в принципе можено получить из первого
*/
module dffe_flag(clk, rst, clk_ena, d);
  input clk, rst, clk_ena;
  output d; 
  // local
  reg tmp;
  // logic
  always @(posedge clk or posedge rst)
    begin
  if(rst)
    tmp <= 'b0;  // !!в ноль сбрасывается только так
  else if(clk_ena)
      tmp <= 'b1;  // защелкивает единицу по разрешению
  end
  // out
  assign d = tmp;
endmodule

/*
  Abstract: PE Register with synchronous load, 
            intialize, hold
  Connect:
  register_pe label_rp(
  .clk(clk), .rst(rst), .clk_ena(clk_ena),
  // control
  .load(load), 
  // datastream
  .datain(), .dforload(),   // inputs
  .dataout()
);
*/
module register_pe(
  clk, rst, clk_ena,
  // control
  load, 
  
  // datastream
  // in
  datain, dforload, 
  
  // out
  dataout
);
  input clk, rst, clk_ena;  // ? rst нужен или нет
  // control
  input load;
  // data 
  input [`G_WIDTH-1:0] datain, dforload;
  output [`G_WIDTH-1:0] dataout;
  
  // local
  reg [`G_WIDTH-1:0] out;
  // logic
  always @(posedge clk or posedge rst)
    begin
    if(rst)
       out <= 0;
    else if(clk_ena)  // если тактирование разрешено
      if(load)  // синфронная загрузка
      out <= dforload;
      else
	out <= datain;  // сквозное прохождение сигнала
  end
  // out 
  assign dataout = out;
endmodule

// версия предыдущего, но с разрешением такта
module register_pe_new(
  clk, rst, clk_ena,
  // control
  load, init, 
  // datastream
  datain, initdata,   // inputs
  dataout
);
  input clk, rst, clk_ena; 
  // control
  input load, init;
  // data 
  input [`G_WIDTH-1:0] datain, initdata;
  output [`G_WIDTH-1:0] dataout;
  
  // local
  reg [`G_WIDTH-1:0] out;
  // logic
  always @(posedge clk)
    begin
  if(rst)
    out <= 'b0;
    else if(clk_ena) 
    if(init)
        out <= initdata;  // по сути загрузка синдрома
      else if(load)
        out <= datain;  // рабочий режим
  end
  // out 
  assign dataout = out;
endmodule




