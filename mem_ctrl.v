module mem_ctrl (
    input                  clk,
    input                  rst,

    // request signals from each core
    input  [3:0]   req,
    input  [3:0]   we,

    // address from each core (flattened)
    input  [7:0]   addr0, addr1, addr2, addr3,

    // write data from each core (flattened)
    input  [15:0]  wdata0, wdata1, wdata2, wdata3,

    // read data to each core (flattened)
    output reg [15:0] rdata0, rdata1, rdata2, rdata3,

    output reg [3:0]  grant
);

    // shared memory: 256 x 16 bits
    reg [15:0] mem [0:255];

    // round-robin counter
    reg [1:0] current;

    // flattened arrays for easier access
    reg [7:0]  addr  [0:3];
    reg [15:0] wdata [0:3];

    integer j;
    initial begin
        for (j = 0; j < 256; j = j + 1)
            mem[j] = 16'h0;
    end

    // connect flat inputs to arrays
    always @(*) begin
        addr[0] = addr0; addr[1] = addr1;
        addr[2] = addr2; addr[3] = addr3;
        wdata[0] = wdata0; wdata[1] = wdata1;
        wdata[2] = wdata2; wdata[3] = wdata3;
    end

    always @(posedge clk) begin
        if (rst) begin
            current <= 0;
            grant   <= 0;
        end
        else begin
            grant <= 0;

            if (req[current]) begin
                grant[current] <= 1;

                if (we[current])
                    mem[addr[current]] <= wdata[current];
                else begin
                    case(current)
                        2'd0: rdata0 <= mem[addr[0]];
                        2'd1: rdata1 <= mem[addr[1]];
                        2'd2: rdata2 <= mem[addr[2]];
                        2'd3: rdata3 <= mem[addr[3]];
                    endcase
                end

                current <= current + 1;
            end
            else begin
                current <= current + 1;
            end
        end
    end

endmodule