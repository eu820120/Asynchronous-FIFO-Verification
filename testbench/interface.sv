interface if_wr  
  #(
	parameter DSIZE = 8 //data size
  )
  (
    input logic wclk
  );
  
  logic winc, wrst_n;
  logic [DSIZE-1:0] wdata;
  logic wfull;
  

  modport DUT(input winc, wclk, wrst_n, wdata,
              output wfull);
  
  modport DRV(input wfull,wclk, output wdata, winc, wrst_n);

endinterface: if_wr
    
    

interface if_rd
  #(
	parameter DSIZE = 8 //data size
  )
  (
    input logic rclk
  );
  
  logic rinc, rrst_n;
  logic [DSIZE-1:0] rdata;
  logic rempty;
  
  modport DUT(input rinc, rclk, rrst_n,
              output rdata, rempty);
  
  modport REC(input rdata, rempty,rclk, output rrst_n, rinc);
  
endinterface: if_rd
    


interface if_beh
    #(
	parameter DSIZE = 8 //data size
  )
  (
    input logic rclk, wclk
  );

  logic [DSIZE-1:0] rdata;
  logic rempty,wfull;
  
  modport BEH(input rclk, wclk,
    		  output rdata, rempty, wfull);
  
  
  
  
endinterface