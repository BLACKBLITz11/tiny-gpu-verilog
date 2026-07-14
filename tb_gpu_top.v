module tb_gpu_top;

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
        $display("=== GPU TOP TEST START ===");

        // reset
        rst = 1;
        instruction = 16'h0;
        #20; rst = 0;

        // load a simple ADD instruction
        // opcode=0000(ADD), rd=001, rs1=000, rs2=000
        instruction = 16'b0000_001_000_000_000;

        // wait for all 8 threads to complete
        #500;

        $display("All done signal: %0d (expected 1)", all_done);

        if (all_done)
            $display("SUCCESS: GPU completed all threads!");
        else
            $display("PENDING: GPU still running...");

        $display("=== GPU TOP TEST DONE ===");
        $finish;
    end

endmodule