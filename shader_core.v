module shader_core (
    input         clk,
    input         rst,
    input  [15:0] instruction,  // current instruction from memory
    output reg    done          // signals when thread is finished
);

    // FSM states
    parameter FETCH     = 2'b00;
    parameter DECODE    = 2'b01;
    parameter EXECUTE   = 2'b10;
    parameter WRITEBACK = 2'b11;

    reg [1:0] state;  // current state

    // decoded instruction fields
    reg [3:0]  opcode;   // what operation
    reg [2:0]  rd;       // destination register
    reg [2:0]  rs1;      // source register 1
    reg [2:0]  rs2;      // source register 2

    // ALU connections
    reg  [3:0]  alu_op;
    wire [15:0] alu_result;
    reg  [15:0] alu_a, alu_b;

    // Register file connections
    reg         we;
    wire [15:0] r_data1, r_data2;

    // Program counter connections
    reg        jump;
    reg [7:0]  jump_addr;
    wire [7:0] pc;

    // instantiate ALU
    alu alu_inst (
        .op(alu_op),
        .a(alu_a),
        .b(alu_b),
        .result(alu_result)
    );

    // instantiate register file
    reg_file rf_inst (
        .clk(clk), .we(we),
        .r_addr1(rs1), .r_addr2(rs2),
        .w_addr(rd), .w_data(alu_result),
        .r_data1(r_data1), .r_data2(r_data2)
    );

    // instantiate program counter
    prog_counter pc_inst (
        .clk(clk), .rst(rst),
        .jump(jump), .jump_addr(jump_addr),
        .pc(pc)
    );

    // FSM
    always @(posedge clk) begin
        if (rst) begin
            state <= FETCH;
            done  <= 0;
            we    <= 0;
            jump  <= 0;
        end
        else begin
            case(state)

                FETCH: begin
                    // instruction already provided as input
                    // just move to decode
                    we    <= 0;
                    jump  <= 0;
                    done  <= 0;
                    state <= DECODE;
                end

                DECODE: begin
                    // break instruction into fields
                    // instruction format: [15:12]=opcode, [11:9]=rd, [8:6]=rs1, [5:3]=rs2
                    opcode <= instruction[15:12];
                    rd     <= instruction[11:9];
                    rs1    <= instruction[8:6];
                    rs2    <= instruction[5:3];
                    state  <= EXECUTE;
                end

                EXECUTE: begin
                    // set ALU operation and inputs
                    alu_op <= opcode;
                    alu_a  <= r_data1;
                    alu_b  <= r_data2;
                    state  <= WRITEBACK;
                end

                WRITEBACK: begin
                    // write ALU result back to register file
                    we    <= 1;
                    state <= FETCH;
                    done  <= 1;
                end

            endcase
        end
    end

endmodule