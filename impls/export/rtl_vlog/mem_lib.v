/*
 rom_init_rtl.v
  Altera "Recommended HDL Coding Styles"
  ROM с инициализацией и разрешением такта
*/
//`include "vconst_lib.v"
module rom_init_rtl(clk, clk_ena, addr_a, q_a);
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  
  input clk, clk_ena;
  input [ADDR_WIDTH-1:0] addr_a;
  output reg [DATA_WIDTH-1:0] q_a;
  // local
  reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
  
  // init ///
  initial 
    begin
    $readmemb("rs_255_inv.vec", rom);
  end
  // logic
  always @ (posedge clk)
    begin
    if(clk_ena)
      q_a <= rom[addr_a];
  end
endmodule

/**


single_clock_wr_ram lable_store(  // память для fifo
  .q(), .d(), 
  .write_address(), .read_address(),
  .we(), .rde(), .clk(), .clk_ena() // последний нужен ли
);
*/


module single_clock_wr_ram(
  q, d, 
  write_address, read_address,
  we, rde, clk, clk_ena // последний нужен ли
);
  parameter WIDTH = 8;
  parameter LEN_ADDR = 8;
  parameter  DEPTH = 2**LEN_ADDR;
  
  output reg [WIDTH-1:0] q;
  input [WIDTH-1:0] d;
  input [LEN_ADDR-1:0] write_address, read_address;
  input we, rde, clk, clk_ena;
  // local
  reg [WIDTH-1:0] mem [DEPTH-1:0];
  
  always @ (posedge clk) begin
    //if()
    if (we)
      mem[write_address] <= d;
    if(rde)
      q <= mem[read_address]; // q does get d in this clock cycle if
  // we is high
  end
endmodule