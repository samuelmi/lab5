`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Sammy-Boy Industries
// 
//////////////////////////////////////////////////////////////////////////////////


module io_demo(
    input wire clk,
	input wire ps2_data,
	input wire ps2_clk,
	
	//Sound
    output wire audPWM,
    output wire audEn,
    
    //Accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //Display
    output wire [7:0] segments,
    output wire [7:0] digitselect,
    
    output wire [15:0] LED
    );

    wire [31:0] keyb_char;
 
	keyboard keyb(clk, ps2_clk, ps2_data, keyb_char);
   
	display8digit disp(keyb_char, clk, segments, digitselect);
	
	assign audEn = 1;       // Always on; could be turned off
    
    wire [31:0] period;
    assign period = keyb_char[31:0] == 32'h00000015 ? 382219
                  : keyb_char[31:0] == 32'h0000001d ? 340530
                  : keyb_char[31:0] == 32'h00000024 ? 303370
                  : keyb_char[31:0] == 32'h0000002d ? 286344
                  : keyb_char[31:0] == 32'h0000002c ? 255102
                  : keyb_char[31:0] == 32'h00000035 ? 227273
                  : keyb_char[31:0] == 32'h0000003c ? 202478
                  : keyb_char[31:0] == 32'h00000043 ? 191113
                  : 32'h00000000;
    
    montek_sound_Nexys4 snd(
       clk,             // 100 MHz clock
       period,          // sound period in tens of nanoseconds
                        // period = 1 means 10 ns (i.e., 100 MHz)      
       audPWM);
       
    //Accelerometer data
    wire [8:0] accelX, accelY;      // The accelX and accelY values are 9-bit values, ranging from 9'h 000 to 9'h 1FF
    wire [11:0] accelTmp;           // 12-bit value for temperature
    
    accelerometer accel(clk, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);

	
	assign LED[15:0] = (accelY >= 0 && accelY <= 31) ? 16'b0000000000000001
	                  :(accelY >= 32 && accelY <= 63) ? 16'b0000000000000010
	                  :(accelY >= 64 && accelY <= 95) ? 16'b0000000000000100
	                  :(accelY >= 96 && accelY <= 127) ? 16'b0000000000001000
	                  :(accelY >= 128 && accelY <= 159) ? 16'b0000000000010000
	                  :(accelY >= 160 && accelY <= 191) ? 16'b0000000000100000
	                  :(accelY >= 192 && accelY <= 223) ? 16'b0000000001000000
	                  :(accelY >= 224 && accelY <= 255) ? 16'b0000000010000000
	                  :(accelY >= 256 && accelY <= 287) ? 16'b0000000100000000
	                  :(accelY >= 288 && accelY <= 319) ? 16'b0000001000000000
	                  :(accelY >= 320 && accelY <= 351) ? 16'b0000010000000000
	                  :(accelY >= 352 && accelY <= 383) ? 16'b0000100000000000
	                  :(accelY >= 384 && accelY <= 415) ? 16'b0001000000000000
	                  :(accelY >= 416 && accelY <= 447) ? 16'b0010000000000000
	                  :(accelY >= 448 && accelY <= 479) ? 16'b0100000000000000
	                  : 16'b1000000000000000;
	
endmodule