// COUNTER
module counter #(parameter n = 24)(
input logic fastclk, output logic clk);

logic [n-1:0] count;

always_ff @(posedge fastclk)
    count <= count +1;
	 
assign clk = count[n-1]; // slow clock

endmodule