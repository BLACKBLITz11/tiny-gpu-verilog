module tb_reg_pc;

    reg clk, rst, we, jump;
    reg [2:0]  r_addr1, r_addr2, w_addr;
    reg [15:0] w_data;
    reg [7:0]  jump_addr;

    wire [15:0] r_data1, r_data2;
    wire [7:0]  pc;

    // connect register file
    reg_file rf (
        .clk(clk), .we(we),
        .r_addr1(r_addr1), .r_addr2(r_addr2),
        .w_addr(w_addr), .w_data(w_data),
        .r_data1(r_data1), .r_data2(r_data2)
    );

    // connect program counter
    prog_counter pc_inst (
        .clk(clk), .rst(rst),
        .jump(jump), .jump_addr(jump_addr),
        .pc(pc)
    );

    // generate clock: flips every 5 time units
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== REG FILE + PC TEST START ===");

        // reset
        rst = 1; we = 0; jump = 0;
        jump_addr = 0; w_data = 0;
        w_addr = 0; r_addr1 = 0; r_addr2 = 0;
        #10;

        // release reset, check PC increments
        rst = 0;
        #10; $display("PC after 1 cycle: %0d (expected 1)", pc);
        #10; $display("PC after 2 cycles: %0d (expected 2)", pc);
        #10; $display("PC after 3 cycles: %0d (expected 3)", pc);

        // write 42 into register 3
        we = 1; w_addr = 3; w_data = 16'd42;
        #10;

        // write 99 into register 5
        w_addr = 5; w_data = 16'd99;
        #10;

        // read back register 3 and 5
        we = 0;
        r_addr1 = 3; r_addr2 = 5;
        #10;
        $display("REG[3] = %0d (expected 42)", r_data1);
        $display("REG[5] = %0d (expected 99)", r_data2);

        // test jump
        jump = 1; jump_addr = 8'd20;
        #10;
        $display("PC after jump: %0d (expected 20)", pc);

        jump = 0;
        #10;
        $display("PC after jump+1: %0d (expected 21)", pc);

        $display("=== TEST DONE ===");
        $finish;
    end

endmodule