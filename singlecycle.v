//NOTE: This is Harvard architecture but I am too lazy to change it
//NOTE: INSTRLEN = PCLEN = REGLEN = MEMWIDTH = 32

module processor #(
    parameter DATA_LEN = 31;
    parameter MEMDEPTH = 200;
)
(
    input CLK,
    input RST,
    input EN
)

//control registers - probably implement using a control FSM + as inputs
reg pc_swap, pc_jalr; //TODO something might have to be done with this to prevent early PC updating - maybe shift register with control code from prev instr
reg rf_dest_mux, rf_data_mux, rf_jalr_mux, rf_en;
reg alu_in, alu_op;
reg dm_en, dm_rw;

//state registers
reg [DATA_LEN:0] pc_in, pc_out;
reg [DATA_LEN:0] pc_plus1;

reg [DATA_LEN:0] instr;

reg [DATA_LEN:0] offset;

reg [DATA_LEN:0] rf_data;
reg [ 2:0] rf_dest;
reg [DATA_LEN:0] rf_A, rf_B;

reg [DATA_LEN:0] alu_b;
reg [DATA_LEN:0] alu_out;
reg        alu_eq;

reg [DATA_LEN:0] dm_out



//Components: PC, Memory (instr, data), sign extend, register file, ALU
pc p(.in(pc_in), .out(pc_out));
instr_mem #(DEPTH=MEMDEPTH) i( .addr(pc_out), .data_out(instr) );
sign_extend se( .in(instr[15:0]), .out(offset) );
register_file rf( .addr1(instr[21:19]), .addr2(instr[18:16]), .data_wr(rf_data), .dest_wr(rf_dest), .en(rf_en), .out_A(rf_A), .out_B(rf_B) );
alu a( .op(alu_op), .a(rf_A), .b(alu_b), .eq(alu_eq), .out(alu_out) );
data_mem #(DEPTH=MEMDEPTH) d( .addr(alu_out), .data_in(rf_B), .data_out(dm_out), .rw(dm_rw), .en(dm_en));

always @(*) begin
    pc_plus1 = pc_out + 1; //TODO figure out if + n is ok
    pc_in    = pc_jalr     ? rf_A         : (pc_swap ? pc_plus1 + offset : pc_plus1); //TODO figure out if + n is ok
    rf_dest  = rf_dest_mux ? instr[18:16] : instr[2:0];
    rf_data  = rf_jalr_mux ? pc_plus1     : (rf_data_mux ? dm_out : alu_out);
    alu_b    = alu_in      ? rf_B         : offset;
end

endmodule