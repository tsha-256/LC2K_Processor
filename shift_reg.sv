module shift_reg (
    input  [`DATA_LEN:0] in,
    input  clk,
    output [`DATA_LEN:0] out [`SHIFT_LEN:0]
);

    reg [`SHIFT_LEN:0] i_out;

    always @(posedge clk) begin
        i_out <= {i_out[`SHIFT_LEN:1], in};
    end

    assign out = i_out;

endmodule