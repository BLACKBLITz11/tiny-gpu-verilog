module tb_alu;

    // inputs (reg because we drive them)
    reg [3:0]  op;
    reg [15:0] a, b;

    // output (wire because we just read it)
    wire [15:0] result;

    // connect our ALU module here
    alu uut (
        .op(op),
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
    $dumpfile("alu.vcd");      // Name of waveform file
    $dumpvars(0, tb_alu);      // Dump all signals in tb_alu
end

    initial begin
        $display("=== ALU TEST START ===");

        // Test ADD: 10 + 5 = 15
        op = 4'b0000; a = 16'd10; b = 16'd5;
        #10;
        $display("ADD: %0d + %0d = %0d (expected 15)", a, b, result);

        // Test SUB: 20 - 8 = 12
        op = 4'b0001; a = 16'd20; b = 16'd8;
        #10;
        $display("SUB: %0d - %0d = %0d (expected 12)", a, b, result);

        // Test MUL: 3 x 4 = 12
        op = 4'b0010; a = 16'd3; b = 16'd4;
        #10;
        $display("MUL: %0d x %0d = %0d (expected 12)", a, b, result);

        // Test AND: 0b1100 & 0b1010 = 0b1000 = 8
        op = 4'b0011; a = 16'b1100; b = 16'b1010;
        #10;
        $display("AND: %0d & %0d = %0d (expected 8)", a, b, result);

        // Test OR: 0b1100 | 0b1010 = 0b1110 = 14
        op = 4'b0100; a = 16'b1100; b = 16'b1010;
        #10;
        $display("OR:  %0d | %0d = %0d (expected 14)", a, b, result);

        $display("=== ALU TEST DONE ===");
        $finish;
    end

endmodule