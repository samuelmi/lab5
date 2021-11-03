`timescale 1ns / 1ps
`default_nettype none

module counter8digit(
    input wire clk,
    output wire [7:0] segments,
    output wire [7:0] digitselect
);
    logic [50:0] c = 0;

    always_ff @(posedge clk)
		c <= c + 1'b 1;
		
	display8digit d4(c[50:19], clk, segments, digitselect);

endmodule