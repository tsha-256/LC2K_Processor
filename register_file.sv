`include "sys_defs.svh"

// ATTRIBUTION NOTE: This is based off of the UW ECE 369 Lab 2.
module register_file(
  input [2:0] addr1, addr2,
  input [`DATA_LEN:0] data_wr,
  input [2:0] dest_wr,
  input en,
  input clk,
  output [`DATA_LEN:0] out_A, out_B
);
	
	//reg [31:0] Registers = new reg[32];
  reg [31:0] regs [0:7];
	
	initial begin
    for (int i = 0; i < 8; i++) begin
      regs[i] <= 32'd0;
    end
	end
	
	
	always @(posedge clk)
	begin
		
    if (en == 1) 
		begin
      regs[dest_wr] <= data_wr;
		end
	end
	
	always @(negedge clk)
	begin
    if (addr1 == 0) begin
      out_A <= 32'd0;
    end
    else if(addr1 == dest_wr) begin
      out_A <= data_wr;
    end
    else begin
      out_A <= regs[addr1];
    end

    if (addr2 == 0) begin
      out_B <= 32'd0;
    end
    else if(addr2 == dest_wr) begin
      out_B <= data_wr;
    end
    else begin
      out_B <= regs[addr2];
    end
	end
	
endmodule
