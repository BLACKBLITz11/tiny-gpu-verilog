module reg_file (
    input         clk,        // clock signal
    input         we,         // write enable (1 = write, 0 = read only)
    input  [2:0]  r_addr1,    // read address 1 (which register to read)
    input  [2:0]  r_addr2,    // read address 2
    input  [2:0]  w_addr,     // write address (which register to write to)
    input  [15:0] w_data,     // data to write
    output [15:0] r_data1,    // data read from register 1
    output [15:0] r_data2     // data read from register 2
);

    // 8 registers, each 16 bits wide
    reg [15:0] registers [0:7];

    // initialize all registers to 0
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            registers[i] = 16'h0;
    end

    // write on rising clock edge (if write enable is high)
    always @(posedge clk) begin
        if (we)
            registers[w_addr] <= w_data;
    end

    // read is instant (combinational)
    assign r_data1 = registers[r_addr1];
    assign r_data2 = registers[r_addr2];

endmodule