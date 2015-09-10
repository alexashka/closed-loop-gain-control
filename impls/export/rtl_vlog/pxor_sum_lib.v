/**
  Name file: pxor_sum_lib.v
  Abstract lib:
    многовходовая схема суммирования по мод 2
    конвееризованная
  Warning:
    базовые схемы минимум на три входа, т.к. 
    конвееризуем по два сумматора
*/

/*
  Abstract: простейший модуль 
    на выходе стандартный конвеерный регистр
  
  Connect:
  pxor_4w21w label_(
    .clk(clk), .rst(rst), .clk_ena(clk_ena),
    // datastream
    .pbus_in(),  // учетвененная ширина
    // out
    .busout()
  );
*/

module pxor_4w21w(
  clk, rst, clk_ena,
  // datastream
  pbus_in,  // учетвененная ширина
  // out
  busout
);
  parameter WIDTH = 8;  // ширина разрадной шины
  input clk, rst, clk_ena;
  input [4*WIDTH-1:0] pbus_in;
  // out
  output [WIDTH-1:0] busout;
  // local
  wire [WIDTH-1:0] out_tmp;
  reg [WIDTH-1:0] out_tmp_reg;
  // split
  
  // logic
  assign out_tmp = (pbus_in[WIDTH*1-1:WIDTH*0]^
                    pbus_in[WIDTH*2-1:WIDTH*1])^
                   (pbus_in[WIDTH*3-1:WIDTH*2]^
                    pbus_in[WIDTH*4-1:WIDTH*3]);
  always @(posedge clk or posedge rst) begin
    if(rst)
      out_tmp_reg <= 0;
    else if(clk_ena)
      out_tmp_reg <= out_tmp;
  end
  // out
  assign busout = out_tmp_reg;
endmodule
/**
  Abstract: специализированные модул
*/
/*
wire [`WIDTH-1:0] tmp_ch_0, tmp_ch_1, tmp_ch_2;
  wire [4*`WIDTH-1:0] odd_lamb;
    assign odd_lamb = {out_lambda_arr[1], out_lambda_arr[3],
                     out_lambda_arr[5], out_lambda_arr[7]};
  wire [4*`WIDTH-1:0] even_lamb;
    assign even_lamb = {out_lambda_arr[2], out_lambda_arr[4],
                      out_lambda_arr[6], out_lambda_arr[8]};
  pxor_4w21w lamb_odd(
    .clk(clk), .rst(rst), .clk_ena(clk_ena),
    // datastream
    .pbus_in(odd_lamb),  // учетвененная ширина
    // out
    .busout(tmp_ch_0));
  pxor_4w21w lamb_even(
    .clk(clk), .rst(rst), .clk_ena(clk_ena),
    // datastream
    .pbus_in(even_lamb),  // учетвененная ширина
    // out
    .busout(tmp_ch_1));
  assign tmp_ch_2 = (tmp_ch_0^tmp_ch_1)^out_lambda_arr[0];  // в обобщенную схему 
*/
