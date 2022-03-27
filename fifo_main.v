`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:59:59 02/06/2022 
// Design Name: 
// Module Name:    fifo_main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_main(clk,rst,
			  wr_en_i, data_i, full_o,
			  rd_en_i, data_o, empty_o
    );
	 parameter data_width = 8, depth = 16,addr_width= 4;           // address bit = log₂( fifo depth)
	 input clk,rst,wr_en_i,rd_en_i;
	 input [data_width-1:0] data_i ;
	 output full_o,empty_o ;
	 output reg [data_width-1:0] data_o ;
	 
	 reg [addr_width-1:0] wr_ptr, rd_ptr ;
	 reg [data_width-1:0] mem [depth-1:0];                 //fifo memory
	 reg [addr_width:0] count ;
	 
		assign full_o = (count == depth) ;
		assign empty_o = (count == 0) ;
		
		// write operation
		always @(posedge clk,negedge rst)begin
			if (!rst)
				wr_ptr <= 0;                               // asynchronous reset
			else
				begin
					if(wr_en_i)begin
						mem[wr_ptr] <= data_i ;    // data is stored in fifo
						wr_ptr <= wr_ptr + 1 ;     // write pointer increament 
						end
						
				end
				
			end
			
		// read operation
		always @(posedge clk,negedge rst)begin
			if (!rst)                                            // asynchronous reset
				rd_ptr <= 0;
			else
				begin
					if(rd_en_i)begin
						data_o <= mem[rd_ptr] ;      // data from fifo is put on output
						rd_ptr <= rd_ptr + 1 ;
						end
						
				end
				
			end
	
	// count operation
	
	always @(posedge clk,negedge rst)begin
			if (!rst)
				count <= 4'b0;
			else
				begin
					case({wr_en_i,rd_en_i})                 // when both read and write happen on same clock or no read and write happen count will not change
						2'b10: count <= count + 1 ;     // for 1 read and no write 
						2'b01: count <= count - 1 ;     // for 1 write and no read
					endcase
						
				end
				
			end
	
	


endmodule
