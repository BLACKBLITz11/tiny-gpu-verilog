module gpu_top (
    input         clk,
    input         rst,
    input  [15:0] instruction,
    output        all_done
);

    // wires between dispatch and cores
    wire [3:0] core_enable;
    wire [3:0] core_done;

    // flattened thread_id wires
wire [7:0] thread_id_0, thread_id_1, thread_id_2, thread_id_3;

    // wires for memory controller
    wire [3:0]  mem_req;
    wire [3:0]  mem_we;
    wire [7:0]  mem_addr0, mem_addr1, mem_addr2, mem_addr3;
    wire [15:0] mem_wdata0, mem_wdata1, mem_wdata2, mem_wdata3;
    wire [15:0] mem_rdata0, mem_rdata1, mem_rdata2, mem_rdata3;
    wire [3:0]  mem_grant;

    // instantiate dispatch unit
dispatch_unit dispatch (
        .clk(clk), .rst(rst),
        .core_done(core_done),
        .core_enable(core_enable),
        .thread_id_0(thread_id_0),
        .thread_id_1(thread_id_1),
        .thread_id_2(thread_id_2),
        .thread_id_3(thread_id_3),
        .all_done(all_done)
    );

    // instantiate 4 shader cores
    shader_core core0 (
        .clk(clk), .rst(rst | ~core_enable[0]),
        .instruction(instruction),
        .done(core_done[0])
    );

    shader_core core1 (
        .clk(clk), .rst(rst | ~core_enable[1]),
        .instruction(instruction),
        .done(core_done[1])
    );

    shader_core core2 (
        .clk(clk), .rst(rst | ~core_enable[2]),
        .instruction(instruction),
        .done(core_done[2])
    );

    shader_core core3 (
        .clk(clk), .rst(rst | ~core_enable[3]),
        .instruction(instruction),
        .done(core_done[3])
    );

    // instantiate memory controller
    mem_ctrl mem (
        .clk(clk), .rst(rst),
        .req(mem_req), .we(mem_we),
        .addr0(mem_addr0), .addr1(mem_addr1),
        .addr2(mem_addr2), .addr3(mem_addr3),
        .wdata0(mem_wdata0), .wdata1(mem_wdata1),
        .wdata2(mem_wdata2), .wdata3(mem_wdata3),
        .rdata0(mem_rdata0), .rdata1(mem_rdata1),
        .rdata2(mem_rdata2), .rdata3(mem_rdata3),
        .grant(mem_grant)
    );

    // memory not connected to cores yet
    assign mem_req    = 4'b0000;
    assign mem_we     = 4'b0000;
    assign mem_addr0  = 8'h0;
    assign mem_addr1  = 8'h0;
    assign mem_addr2  = 8'h0;
    assign mem_addr3  = 8'h0;
    assign mem_wdata0 = 16'h0;
    assign mem_wdata1 = 16'h0;
    assign mem_wdata2 = 16'h0;
    assign mem_wdata3 = 16'h0;

endmodule