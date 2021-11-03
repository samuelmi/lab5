`timescale 1ns / 1ps
`default_nettype none

module counter4digit(
    input wire clk,
    output wire [7:0] segments,
    output wire [7:0] digitselect
);
    logic [38:0] c = 0;

    always_ff @(posedge clk)
		c <= c + 1'b 1;
		
	display4digit d4(c[38:23], clk, segments, digitselect);

endmodule