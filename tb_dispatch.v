module tb_dispatch;

    reg clk, rst;
    reg  [3:0] core_done;
    wire [3:0] core_enable;
    wire [7:0] thread_id [0:3];
    wire       all_done;

    dispatch_unit uut (
        .clk(clk), .rst(rst),
        .core_done(core_done),
        .core_enable(core_enable),
        .thread_id(thread_id),
        .all_done(all_done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== DISPATCH UNIT TEST START ===");

        // reset
        rst = 1; core_done = 0;
        #20; rst = 0;

        // wait for initial thread assignment
        #20;
        $display("Core 0 thread: %0d (expected 0)", thread_id[0]);
        $display("Core 1 thread: %0d (expected 1)", thread_id[1]);
        $display("Core 2 thread: %0d (expected 2)", thread_id[2]);
        $display("Core 3 thread: %0d (expected 3)", thread_id[3]);
        $display("Core enable: %b (expected 1111)", core_enable);

        // simulate all cores finishing their first thread
        #20; core_done = 4'b1111;
        #20;
        $display("After first batch done:");
        $display("Core 0 thread: %0d (expected 4)", thread_id[0]);
        $display("Core 1 thread: %0d (expected 5)", thread_id[1]);
        $display("Core 2 thread: %0d (expected 6)", thread_id[2]);
        $display("Core 3 thread: %0d (expected 7)", thread_id[3]);

        // simulate all cores finishing second batch
        #20; core_done = 4'b1111;
        #30;
        $display("All done: %0d (expected 1)", all_done);

        $display("=== DISPATCH UNIT TEST DONE ===");
        $finish;
    end

endmodule