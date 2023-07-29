`include "transaction.sv"
`include "interface.sv"
`include "driver.sv"
`include "receiver.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "beh_fifo.sv"
`include "configuration.sv"
`include "test.sv"

`timescale 100ps/100ps


module tb_top
  #(
	parameter DSIZE = 8,
	parameter ASIZE = 4,
	parameter DEPTH = 16
  );
  
  logic rclk, wclk;
  environment env;
  clk_config cf;
  
  
  //clock generator
  initial begin 
	wclk = 1'b0;
	rclk = 1'b0;
    cf = new();
    cf.randomize();
			
	fork
		begin
          forever #(cf.wclkp / 2) wclk <= ~wclk;
		end
			
		begin
          #5 forever #(cf.rclkp / 2) rclk <= ~rclk;
		end	
	join_none
    
  end
  
  //declare interfaces
  if_wr  if_w(wclk);
  if_rd  if_r(rclk);
  if_beh  if_beh(.rclk(rclk), .wclk(wclk));
  
  //DUT connection
  async_fifo dut(.winc(if_w.winc), .wclk(wclk), .wrst_n(if_w.wrst_n), .rinc(if_r.rinc), .rclk(rclk), .rrst_n(if_r.rrst_n), .wdata(if_w.wdata),
             .rdata(if_r.rdata), .wfull(if_w.wfull), .rempty(if_r.rempty));
  
  //Behavior model connection
  beh_fifo beh(.winc(if_w.winc), .wclk(wclk), .wrst_n(if_w.wrst_n), .rinc(if_r.rinc), .rclk(rclk),.rrst_n(if_r.rrst_n), .wdata(if_w.wdata),
               .rdata(if_beh.rdata), .wfull(if_beh.wfull), .rempty(if_beh.rempty));
  
  //Test instantiation
  test testcases();
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars;  
  end
  

  
endmodule