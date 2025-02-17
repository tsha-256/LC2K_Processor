`include "sys_defs.svh"

// ATTRIBUTION NOTE: This is based off of the UW ECE 369 Lab 2.
module data_mem (
    input [`DATA_LEN:0] addr,
    input [`DATA_LEN:0] data_in,
    output [`DATA_LEN:0] data_out
    input rw,
    input en,
    input clk
);
	
    reg [`DATA_LEN:0] mems [0:`MEMDEPTH];
	
	initial begin
        for (int i = 0; i <= `MEMDEPTH; i++) begin
            mems[i] <= 'd0;
        end
	end
	
	always @(posedge clk)
	begin
        if (en == 1) begin
            if (rw == 1) begin //write
                mems[addr] <= data_in;
                data_out <= 'd0; 
            end
            else begin //read
                data_out <= mems[addr];
            end
		end
	end
	
	always @(negedge clk)
	begin
        out_A <= mems[addr1];
        out_B <= mems[addr2];
	end
	
endmodule