module dispatch_unit #(parameter N_CORES = 4, parameter N_THREADS = 8) (
    input                    clk,
    input                    rst,
    input  [N_CORES-1:0]     core_done,
    output reg [N_CORES-1:0] core_enable,
    output reg [7:0]         thread_id_0,
    output reg [7:0]         thread_id_1,
    output reg [7:0]         thread_id_2,
    output reg [7:0]         thread_id_3,
    output reg               all_done
);

    reg [7:0] next_thread;

    always @(posedge clk) begin
        if (rst) begin
            core_enable  <= 0;
            all_done     <= 0;
            next_thread  <= 0;
            thread_id_0  <= 0;
            thread_id_1  <= 1;
            thread_id_2  <= 2;
            thread_id_3  <= 3;
        end
        else begin
            if (all_done) begin
                core_enable <= 0;
            end
            else begin
                if (core_enable == 0 && next_thread == 0) begin
                    thread_id_0  <= 0;
                    thread_id_1  <= 1;
                    thread_id_2  <= 2;
                    thread_id_3  <= 3;
                    core_enable  <= 4'b1111;
                    next_thread  <= 4;
                end
                else if (core_done == 4'b1111 && next_thread < N_THREADS) begin
                    thread_id_0  <= next_thread;
                    thread_id_1  <= next_thread + 1;
                    thread_id_2  <= next_thread + 2;
                    thread_id_3  <= next_thread + 3;
                    core_enable  <= 4'b1111;
                    next_thread  <= next_thread + 4;
                end
                else if (next_thread >= N_THREADS && core_done == 4'b1111) begin
                    all_done    <= 1;
                    core_enable <= 0;
                end
            end
        end
    end

endmodule