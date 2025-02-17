module sign_extend #(
    parameter LEN=32
) (
    input  [15:0] in,
    output [LEN-1:0] out
);

    assign out = { {LEN-16{in[15]}}, in};

endmodule