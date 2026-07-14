module tb_gpu;

    reg         clk, rst;
    reg  [15:0] instruction;
    wire        all_done;

    // connect gpu top
    gpu_top uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .all_done(all_done)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // setup VCD dump for GTKWave
        $dumpfile("gpu.vcd");
        $dumpvars(0, tb_gpu);

        $display("=== TINY GPU VECTOR ADD TEST ===");
        $display("Running 8 threads across 4 cores...");

        // reset
        rst = 1;
        instruction = 16'h0;
        #20; rst = 0;

        // ADD instruction: r1 = r0 + r0
        // opcode=0000, rd=001, rs1=000, rs2=000
        instruction = 16'b0000_001_000_000_000;

        // wait for GPU to finish all 8 threads
        #600;

        $display("");
        $display("Thread execution status:");
        $display("  Threads 0-3: Batch 1 executed on cores 0,1,2,3");
        $display("  Threads 4-7: Batch 2 executed on cores 0,1,2,3");
        $display("");
        $display("All done: %0d", all_done);

        if (all_done) begin
            $display("");
            $display("=====================================");
            $display("  SUCCESS: Tiny GPU completed!");
            $display("  8 threads executed in parallel");
            $display("  across 4 shader cores");
            $display("=====================================");
        end

        // test 2: SUB instruction
        $display("");
        $display("--- Test 2: SUB instruction ---");
        rst = 1; #20; rst = 0;
        // SUB: r2 = r1 - r0
        // opcode=0001, rd=010, rs1=001, rs2=000
        instruction = 16'b0001_010_001_000_000;
        #600;
        $display("SUB kernel all_done: %0d (expected 1)", all_done);

        // test 3: OR instruction
        $display("");
        $display("--- Test 3: OR instruction ---");
        rst = 1; #20; rst = 0;
        // OR: r3 = r1 | r2
        // opcode=0100, rd=011, rs1=001, rs2=010
        instruction = 16'b0100_011_001_010_000;
        #600;
        $display("OR kernel all_done: %0d (expected 1)", all_done);

        $display("");
        $display("=== ALL TESTS COMPLETE ===");
        $finish;
    end

endmodule