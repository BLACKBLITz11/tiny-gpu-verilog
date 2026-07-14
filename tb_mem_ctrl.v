module tb_mem_ctrl;

    reg clk, rst;
    reg [3:0]  req, we;
    reg [7:0]  addr0, addr1, addr2, addr3;
    reg [15:0] wdata0, wdata1, wdata2, wdata3;
    wire [15:0] rdata0, rdata1, rdata2, rdata3;
    wire [3:0]  grant;

    mem_ctrl uut (
        .clk(clk), .rst(rst),
        .req(req), .we(we),
        .addr0(addr0), .addr1(addr1),
        .addr2(addr2), .addr3(addr3),
        .wdata0(wdata0), .wdata1(wdata1),
        .wdata2(wdata2), .wdata3(wdata3),
        .rdata0(rdata0), .rdata1(rdata1),
        .rdata2(rdata2), .rdata3(rdata3),
        .grant(grant)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== MEM CTRL TEST START ===");

        // reset
        rst = 1;
        req = 0; we = 0;
        addr0=0; addr1=0; addr2=0; addr3=0;
        wdata0=0; wdata1=0; wdata2=0; wdata3=0;
        #30; rst = 0;

        // core 0 writes 42 to address 10
        // current=0 after reset, so core 0 will be served first
        req = 4'b0001; we = 4'b0001;
        addr0 = 8'd10; wdata0 = 16'd42;
        #40; // give enough cycles
        $display("Core 0 write done (grant was: %b)", grant);

        // reset round robin back to 0 by resetting
        rst = 1; #20; rst = 0;

        // core 1 writes 99 to address 20
        // after reset current=0, core 0 not requesting so moves to core 1
        req = 4'b0010; we = 4'b0010;
        addr1 = 8'd20; wdata1 = 16'd99;
        #40;
        $display("Core 1 write done (grant was: %b)", grant);

        // reset again
        rst = 1; #20; rst = 0;

        // core 0 reads back address 10
        req = 4'b0001; we = 4'b0000;
        addr0 = 8'd10;
        #40;
        $display("Core 0 read addr 10: %0d (expected 42)", rdata0);

        // reset again
        rst = 1; #20; rst = 0;

        // core 1 reads back address 20
        req = 4'b0010; we = 4'b0000;
        addr1 = 8'd20;
        #40;
        $display("Core 1 read addr 20: %0d (expected 99)", rdata1);

        $display("=== MEM CTRL TEST DONE ===");
        $finish;
    end

endmodule