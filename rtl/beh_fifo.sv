/*
  Dual-clock asynchronous FIFO behavioral model in SystemVerilog
  Based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
  http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

  Copyright (C) 2015 Jason Yu (http://www.verilogpro.com)

*/

module beh_fifo(rdata, wfull, rempty, wdata,
               	winc, wclk, wrst_n, rinc, rclk, rrst_n);
  parameter DSIZE = 8;
  parameter ASIZE = 4;
  output logic [DSIZE-1 : 0] rdata;
  output wfull;
  output rempty;
  input [DSIZE-1:0] wdata;
  input winc, wclk, wrst_n;
  input rinc, rclk, rrst_n;
  
  logic [ASIZE:0] wptr, wrptr1, wrptr2, wrptr3;
  logic [ASIZE:0] rptr, rwptr1, rwptr2, rwptr3;
  
  parameter MEMDEPTH = 1<<ASIZE;
  
  logic [DSIZE-1: 0] ex_mem [MEMDEPTH];
  
  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wptr <= 0;
  	else if(winc && !wfull) begin
    ex_mem[wptr[ASIZE-1:0]] <= wdata;
    wptr <= wptr + 1;
  end
  
  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wrptr3, wrptr2,wrptr1} <= 0;
  else {wrptr3, wrptr2,wrptr1} <= {wrptr2,wrptr1,rptr};
  
  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rptr <= 0;
  else if(rinc && !rempty) rptr <= rptr + 1;
  	
  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
    {rwptr3, rwptr2,rwptr1} <= 0;
    else
    {rwptr3, rwptr2,rwptr1} <= {rwptr2,rwptr1,wptr};
  
  always_ff @(posedge rclk)
    if (rinc && !rempty) rdata <= ex_mem[rptr[ASIZE-1:0]];
  
  
  assign rempty = (rptr == rwptr3);
  assign wfull = ((wptr[ASIZE-1:0] == wrptr3[ASIZE-1:0]) && (wptr[ASIZE] != wrptr3[ASIZE]));
  
endmodule