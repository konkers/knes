`timescale 1ns / 1ps

// register is used for the X and Y registers.
module register_index(
    inout [7:0] data,
    input load,
    input bus_enable
);

logic [7:0] data_out;

assign data = bus_enable ? data_out : 8'bz;

initial begin
    data_out = 8'b0;
end

always_ff @(posedge load) begin
    data_out <= data;
end

endmodule