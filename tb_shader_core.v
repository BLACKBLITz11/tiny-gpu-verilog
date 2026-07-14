module tb_shader_core;

    reg         clk, rst;
    reg  [15:0] instruction;
    wire        done;

    // connect shader core
    shader_core uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .done(done)
    );

    // clock: flips every 5 time units
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== SHADER CORE TEST START ===");

        // reset
        rst = 1;
        instruction = 16'h0;
        #20;
        rst = 0;

        // Test 1: ADD r1 = r0 + r0
        // opcode=0000(ADD), rd=001, rs1=000, rs2=000
        // [15:12]=0000, [11:9]=001, [8:6]=000, [5:3]=000
        instruction = 16'b0000_001_000_000_000;
        #80; // wait 4 cycles for FETCH->DECODE->EXECUTE->WRITEBACK
        $display("ADD instruction done: %0d (expected 1)", done);

        // Test 2: SUB r2 = r0 - r0
        // opcode=0001(SUB), rd=010, rs1=000, rs2=000
        instruction = 16'b0001_010_000_000_000;
        #80;
        $display("SUB instruction done: %0d (expected 1)", done);

        // Test 3: OR r3 = r1 | r2
        // opcode=0100(OR), rd=011, rs1=001, rs2=010
        instruction = 16'b0100_011_001_010_000;
        #80;
        $display("OR instruction done: %0d (expected 1)", done);

        $display("=== SHADER CORE TEST DONE ===");
        $finish;
    end

endmodule