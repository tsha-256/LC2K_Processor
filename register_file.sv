`timescale 1ns / 1ps
// ATTRIBUTION NOTE: This is based off of the UW ECE 369 Lab 2.
module register_file(
  input [2:0] addr1, addr2,
  input [`DATA_LEN:0] data_wr,
  input [2:0] dest_wr,
  input en,
  output [`DATA_LEN:0] out_A, out_B
);
	
	//reg [31:0] Registers = new reg[32];
  reg [31:0] regs [0:7];
	
	initial begin
    for (int i = 0; i < 8; i++) begin
      regs[i] <= 32'd0;
    end
	end
	
	
	always @(posedge Clk)
	begin
		
    if (en == 1) 
		begin
      regs[dest_wr] <= data_wr;
		end
	end
	
	always @(negedge Clk)
	begin
    out_A <= regs[addr1];
    out_B <= regs[addr2];
	end
	
endmodule
