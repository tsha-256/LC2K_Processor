`include "sys_defs.svh"

module pc (
input  [`DATA_LEN-1:0] in,
output [`DATA_LEN-1:0] out,
input CLK,
input EN
)

always @(posedge CLK) begin
    if (EN) begin
        out <= in + 1;
    end
end

endmodule