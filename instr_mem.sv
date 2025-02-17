`include "sys_defs.svh"

// ATTRIBUTION NOTE: This is based off of the UW ECE 369 Lab 2.
module instr_mem (
    input [`DATA_LEN] addr,
    input [`DATA_LEN] data_out
    );

    reg [`DATA_LEN:0] mems [0:`MEMDEPTH];

	initial begin
        for (int i = 0; i <= `MEMDEPTH; i++) begin
            mems[i] <= 'd0; //TODO write code to autofill instructions from MC file
        end
	end
	
	always @(posedge clk)
	begin
        data_out <= mems[addr];
	end

endmodule