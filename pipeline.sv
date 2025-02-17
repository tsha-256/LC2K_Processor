//For now, this will only be datapath implementation
//For now, this doesn't have hazard handling

module datapath
(
    input CLK,
    input RST,
    input EN
)

// Components: PC, Memory (instr, data), register file, ALU 

//Control registers
reg addr_mux; // 0 for ALU result (e.g., beq, jalr), 1 for PC+4
reg pc_en; // PC enable
reg dm_en; // Memory enable
reg dm_rw; // 0 for read, 1 for write
reg rf_dest_mux; // Register file destination from instruction (reg B or reg C)
reg rf_data_mux; // Register file data input from MEMWB stage
reg rf_en; // Register file enable
reg alu_in; // 1 for PC, 0 for register file output
reg alu_op; // 0 for add, 1 for nor

//Pipeline state registers
reg [`DATA_LEN:0] IFID_instr;
reg [`DATA_LEN:0] IFID_pc; //next addr

reg [`DATA_LEN:0] IDEX_pc;  //next addr
reg [`DATA_LEN:0] IDEX_offset; 
reg [`DATA_LEN:0] IDEX_A;
reg [`DATA_LEN:0] IDEX_B;
reg [2:0]         IDEX_dest;
reg [2:0]         IDEX_opcode;

reg [`DATA_LEN:0] EXMEM_target;
reg               EXMEM_eq;
reg [`DATA_LEN:0] EXMEM_result;
reg [`DATA_LEN:0] EXMEM_B;
reg [2:0]         EXMEM_dest;
reg [2:0]         EXMEM_opcode;

reg [`DATA_LEN:0] MEMWB_result;
reg [`DATA_LEN:0] MEMWB_mem_data;
reg [2:0]         MEMWB_dest;
reg [2:0]         MEMWB_opcode;


//IF stage
wire [`DATA_LEN:0] pc_in, pc_out;
pc p(.in(pc_in), .out(pc_out), .clk(CLK), .en(pc_en));
instr_mem i( .addr(pc_out), .data_out(IFID_instr) );

assign pc_in = addr_mux ? EXMEM_target : pc_out + 1;
always @(posedge clk) begin
    IFID_pc <= pc_out + 1;
end

//ID stage
reg [`DATA_LEN:0] memwb_out;
sign_extend se( .in(IFID_instr[15:0]), .out(IDEX_offset) );
register_file rf( .addr1(IFID_instr[21:19]), .addr2(IFID_instr[18:16]), .data_wr(memwb_out), .dest_wr(MEMWB_dest), .en(rf_en), .out_A(IDEX_A), .out_B(IDEX_B) );
shift_reg #() sr( .in(), .clk(), .out() ); //TODO implement shift register for forwarding

always @(*) begin
    IDEX_pc = IFID_pc;
    IDEX_dest = rf_dest_mux ? IFID_instr[2:0] : IFID_instr[18:16];
    IDEX_opcode = IFID_instr[24:22];
end

//EX stage
wire [`DATA_LEN:0] alu_a, alu_b;
alu a( .op(alu_op), .a(alu_a), .b(alu_b), .eq(EXMEM_eq), .out(EXMEM_result) );

assign alu_a = jalr   ? IDEX_pc : IDEX_A; //TODO add forwarding in ID stage for 
assign alu_b = alu_in ? IDEX_B  : IDEX_offset;
always @(*) begin
    EXMEM_target = jalr ? IDEX_A : IDEX_pc + IDEX_offset;
    EXMEM_B = IDEX_B;
    EXMEM_dest = IDEX_dest;
    EXMEM_opcode = IDEX_opcode;
end

//MEM stage
data_mem d( .addr(EXMEM_result), .data_in(EXMEM_B), .data_out(MEMWB_mem_data), .rw(dm_rw), .en(dm_en));

assign memwb_out = rf_data_mux ? MEMWB_result : MEMWB_mem_data;
always @(*) begin
    MEMWB_result = EXMEM_result;
    MEMWB_dest   = EXMEM_dest;
    MEMWB_opcode = EXMEM_opcode;
end

endmodule