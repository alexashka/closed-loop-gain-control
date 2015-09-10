/**
  File: counters_lib.v
  
  Abstract: Библиотека счетчиков.
  
  Feature: Пока что логика чисто положительная.
  
  Opt: 
    - каскадирование
  - and на много входов сделать подругому
  - не на сумматорах сделать, а на регистрах

*/
`include "vconst_lib.v"
/**
  abs. : 
  
  feat. : есть выход с шиной, и вообще лучше делать со многоими выходами
    а потом ими просто когда не нужно не пользоваться
*/
module counter_load_dbus(
  clk, rst, clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload,  // data for loading
  count
);
  parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  //input sload;
  input load;
  input [WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  output [WIDTH-1:0] count;
  // local
  reg [WIDTH-1:0] count_r;  // накопитель
    assign count = count_r;
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count_r <= 0;
  else if(clk_ena)
    if(load)  // синхронная загрузка посути
      count_r <= dfload;
    else
      count_r <= count_r+1;
  end
  // формирование сигнала переноса
  always @(count_r) begin // комбинационная часть
    if(count_r == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
endmodule 

/*
  Abstract: Cчетчик по модулю с асинфронным сбросом, разр. такта
    и синхронной загрузкой

  Gate level:
    Cyciii:
      fmax = MHz

  Connect:
  counter_load #(.MOD_COUNT(`MOD_COUNT)) 
    label_cl(
      .clk(clk), .rst(rst), .clk_ena(clk_ena),
      // control 
      .load(load),  // загрузить данные
      // out
      .carry(carry),  // перенесо счетчика
      // datastream
      .dfload(dfload)  // data for loading
    );
  
  ZZZ: 
    - загружает ли модуль, тот, что нужно
  ! можно соединить перенос с загрузкой и подать ноль на 
  ! dfload

*/
module counter_load(
  clk, rst, clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload  // data for loading
);
  parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  //input sload;
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  // local
  reg [WIDTH-1:0] count;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(load)  // синхронная загрузка посути
      count <= dfload;
    else
      count <= count+1;
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
endmodule 
/**
  abstr. : модуль не только с выходом переноса, но и с 
    паралл. выходом (более общий случай уже имеющегося)

*/
module counter_load_out(
  clk, rst, clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload,  // data for loading
  dout  // выход
);
  parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  //input sload;
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  // local
  reg [WIDTH-1:0] count;  // накопитель
  output [WIDTH-1:0] dout;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(load)  // синхронная загрузка посути
      count <= dfload;
    else
      count <= count+1;
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
  //
  assign dout = count;
endmodule 
/**
  abstr. : модуль не только с выходом переноса, но и с 
    паралл. выходом (более общий случай уже имеющегося)

*/
module counter_load_out_collaps_free(
  clk, rst, clk_ena,
  // control 
  clk_ena_job,  // рабочее разрешение
  //sload,  // загрузить ноль
  load,  // загрузить
  // out
  carry,  // перенесо счетчика
  // datastream
  // in
  dfload,  // data for loading
  // out
  dout  // выход
);
  parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  input clk_ena_job;
  //input sload;
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  wire loco = load & clk_ena_job;  // сигналы приходят одноврем.
  // local
  reg [WIDTH-1:0] count;  // накопитель
  output [WIDTH-1:0] dout;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
      count <= 0;
    else if(clk_ena) begin
    if(load)  // синхронная загрузка посути
        count <= 0;//dfload;
    if(clk_ena_job)
        count <= count+1;
    if(load & clk_ena_job)  // одновременный приход
        count <= 1;  
    end
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
  //
  assign dout = count;
endmodule 




/*
  Abstract: счетчик по мудулю c выводом переноса
  
  Connect:
  counters_mod_rtl #(
    .ADDR_MOD(`ADDR_MOD),
    .ADDR_WIDTH(`ADDR_WIDTH))
    counters_mod(
      .clk(clk), .rst(rst), .clk_ena(clk_ena), 
      .q(q), 
      .carry(carry));
*/
module counters_mod_rtl(
  clk, rst, clk_ena, 
  q, 
  carry
);
  parameter ADDR_MOD = 9;
  parameter ADDR_WIDTH = 9;
  
  input clk, clk_ena, rst;
  output [ADDR_WIDTH-1:0] q;
  output carry;
  
  // local
  reg [ADDR_WIDTH-1:0] cnt;
  reg carry_tmp;
  // logic
  always @ (posedge clk or posedge rst)
    begin
    if(rst)
      cnt <= 0;
    else if(clk_ena)
   if(carry_tmp)
    cnt <= 0;
   else
      cnt <= cnt + 1;  // для реализации сделать подругому
  end
  // комб. часть - перенос
  always @ (cnt)
    begin
    if(cnt == ADDR_MOD-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
  //
  assign q = cnt;
  assign carry = carry_tmp;
endmodule

/*
  Abstract: счетчик по мудулю без вывода переноса
*/
module counters_mod_nocarry_rtl(
  clk, clk_ena, rst, 
  q);
  parameter ADDR_MOD = 9;
  parameter ADDR_WIDTH = 9;
  
  input clk, clk_ena, rst;
  output [ADDR_WIDTH-1:0] q;
  //output carry;
  
  // local
  reg [ADDR_WIDTH-1:0] cnt;
  reg carry_tmp;
  // logic
  always @ (posedge clk or posedge rst)
    begin
    if(rst)
      cnt <= 0;
    else if(clk_ena)
      if(carry_tmp)
    cnt <= 0;
   else
      cnt <= cnt + 1;  // для реализации сделать подругому
  end
  // комб. часть - перенос
  always @ (cnt)
    begin
    if(cnt == ADDR_MOD-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
  assign q = cnt;
endmodule

/* 
  Abstract: хороший счетчик по модулю
*/
module counters_mod_speed_rtl(clk, clk_ena, rst, q);
  parameter ADDR_MOD = 9;
  parameter ADDR_WIDTH = 9;
  
  input clk, clk_ena, rst;
  output [ADDR_WIDTH-1:0] q;
  //output carry;
  
  // local
  reg [ADDR_WIDTH-1:0] cnt;
  reg carry_tmp;
  // logic
  always @ (posedge clk or posedge rst)
    begin
    if(rst)
      cnt <= 0;
    else if(clk_ena)
      cnt <= (cnt + 1)%ADDR_MOD;  // для реализации сделать подругому
  end
  // комб. часть - перенос
  always @ (cnt)
    begin
    if(cnt == ADDR_MOD-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
  //
  assign q = cnt;
endmodule

/**
  abst. : вычитающий счетчик
    для получения счета по мудулю нужно замыкаь перенос на лоад
  
  con. :
  counter_load_down #(
    .MOD_COUNT(`MOD_COUNT),
  .WIDTH(`WIDTH)) 
    label_cl(
      .clk(clk), .rst(rst), .clk_ena(clk_ena),
      // control 
      .load(load),  // загрузить данные
      // out
      .carry(carry),  // перенесо счетчика
      // datastream
      .dfload(dfload)  // data for loading
    );
*/
module counter_load_down(
  clk, rst, clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить ноль
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload  // data for loading
);
  parameter MOD_COUNT = 4;
  parameter WIDTH = 4;
  input clk, rst, clk_ena;
  //input sload;
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  // local
  reg [WIDTH-1:0] count;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(load)  // синхронная загрузка посути
      count <= dfload;
    else
      count <= count-1;
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == 
  0)
  //  MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
endmodule 

/**
  abst. : вычитающий счетчик
    для получения счета по мудулю нужно замыкаь перенос на лоад
  
  con. :
  counter_load_down #(
    .MOD_COUNT(`MOD_COUNT),
  .WIDTH(`WIDTH)) 
    label_cl(
      .clk(clk), .rst(rst), .clk_ena(clk_ena),
      // control 
      .load(load),  // загрузить данные
      // out
      .carry(carry),  // перенесо счетчика
      // datastream
      .dfload(dfload)  // data for loading
    );
*/
module counter_load_down_2(
  clk, 
  rst,
  srst,  // синхронный сброс 
  clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить ноль
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload  // data for loading
);
  parameter MOD_COUNT = 4;
  parameter WIDTH = 4;
  input clk, rst, srst, clk_ena;
  //input sload;
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  // local
  reg [WIDTH-1:0] count;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(srst)
      count <= 0;
    else if(load)  // синхронная загрузка посути
      count <= dfload;
    else
      count <= count-1;
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == 
  0)
  //  MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
endmodule 

/***/
module counter_load_down_set(
  clk, rst, clk_ena,
  // control 
  //sload,  // загрузить ноль
  load,  // загрузить ноль
  set,
  // out
  carry,  // перенесо счетчика
  // datastream
  dfload  // data for loading
);
  parameter MOD_COUNT = 4;
  parameter WIDTH = 4;
  input clk, rst, clk_ena;
  //input sload;
  input load, set;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  // local
  reg [WIDTH-1:0] count;  // накопитель
  // logic
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(set)
      count <= 0;
      else if(load)  // синхронная загрузка посути
      count <= dfload;
    else
      count <= count-1;
  end
  // формирование сигнала переноса
  always @(count) begin // комбинационная часть
    if(count == 
  0)
  //  MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  // для реализации сделать подругому
  end
endmodule 


