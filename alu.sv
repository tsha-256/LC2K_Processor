`include "sys_defs.svh"

module alu
(
    input  op,
    input  [`DATA_LEN-1:0] a,
    input  [`DATA_LEN-1:0] b,
    output eq,
    output [`DATA_LEN-1:0] out
)

    reg [`DATA_LEN-1:0] result;
    reg eq;

    always @(*) begin
        case(op)
            1'b0: result = a + b;
            1'b1: result = ~(a | b);
            default: result = 0;
        endcase
        eq = (result == 0);
    end

    assign out = result;
    assign eq = eq;

endmodule