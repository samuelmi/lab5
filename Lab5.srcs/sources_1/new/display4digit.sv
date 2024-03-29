//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 2/19/2021 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module display4digit(
    input wire [15:0] val,
    input wire clk, 					// 100 MHz clock
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );

	logic [31:0] c = 0;					// Used for round-robin digit selection on display
	wire [1:0] toptwo;
	wire [3:0] value4bit;
	
	always_ff @(posedge clk)
		c <= c + 1'b 1;
	
	assign toptwo[1:0] = c[18:17];		// Used for round-robin digit selection on display
	// assign toptwo[1:0] = c[23:22];   // Try this instead to slow things down!

	
	assign digitselect[7:0] = ~ (  			// Note inversion
					   toptwo == 2'b00 ? 8'b 00010000  
				     : toptwo == 2'b01 ? 8'b 00100000
				     : toptwo == 2'b10 ? 8'b 01000000
				     : 8'b 10000000 );

	assign digitselect[7:4] = ~ 4'b 0000;      // Since we are not using half of the display
		
	assign value4bit   =   (
				  toptwo == 2'b00 ? val[3:0]
				: toptwo == 2'b01 ? val[7:4]
				: toptwo == 2'b10 ? val[11:8]
				: val[15:12] );
	
	hexto7seg myhexencoder(value4bit, segments);

endmodule
