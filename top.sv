// filename: top.sv
//function : instantiation 
// author:zy1u21
//version :1
//date: 15/04/2022
//--------------------------------------------
module top (
    input logic clk,
    input logic [9:0] SW,
    output logic [7:0]led

);

logic Ready_dis;
logic [3:0] addr_led;
logic MULEN;
logic signed[7:0] c;      // product input
logic signed[7:0] d;
logic signed [7:0] product; // product    
logic reg_en; // enable external input
logic [3:0] addr; // address
logic reg_finish;
logic reg_add_finish;
logic reg_MUL;
logic cal_flag;
logic cycle_finish;
logic clk_slow;

//------------------intantiation ------------------
counter #(19) t_counter (.fastclk(clk), .clk(clk_slow));

FFT_BUTTERFLY F (.clk(clk_slow), .rst(SW[9]),  .Ready_dis(Ready_dis), .addr_led(addr_led), .cal_flag (cal_flag),
                 .led(led), .MULEN(MULEN), .c(c), .d(d), .product(product), .reg_en(reg_en),
                 .addr(addr), .SW(SW[7:0]), .reg_finish(reg_finish), .reg_MUL(reg_MUL),.reg_add_finish(reg_add_finish),
                 .cycle_finish(cycle_finish)

);

controller con (.clk(clk_slow), .rst(SW[9]), .ReadyIn2(SW[8]), .Ready_dis(Ready_dis), .addra(addr), .cal_flag(cal_flag),
              .reg_WEN(reg_en),  .addr_led(addr_led), .reg_finish(reg_finish), .reg_add_finish(reg_add_finish));

multiplier_twiddle m (.EN(MULEN), .c(c), .d(d), .z(product), .clk(clk_slow),.ready_product(reg_MUL),  .cycle_finish(cycle_finish));

endmodule 


