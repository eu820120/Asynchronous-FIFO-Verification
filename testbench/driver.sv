class driver;
  
  transaction tr;
  mailbox #(transaction) drv2sco;
  virtual if_wr.DRV if_wr_vi;
  int count;
  event write_end;
  
  function new(mailbox #(transaction) drv2sco, virtual if_wr.DRV if_wr_vi);
    this.if_wr_vi = if_wr_vi;
    this.drv2sco = drv2sco;
  endfunction
  
  task write();
    repeat(count) begin
      
      repeat(2) @(negedge if_wr_vi.wclk);
      
      //generator
      tr = new();
      assert(tr.randomize()) else $error("Randomization failed");
      
      //conditions for writing (into interface)
      #2;
      drv2sco.put(tr); 
      if_wr_vi.wdata <= tr.wdata;
      if_wr_vi.winc <= 1'b1;
      
      if(!if_wr_vi.wfull) $display("%dns : driver::%d is sent to DUT/scoreboard", $time, tr.wdata);
      else $display("%dns : driver::write failed, fifo full", $time);
       
      
      @(negedge if_wr_vi.wclk);
      if_wr_vi.winc <= 1'b0;
      
    
      
    
    end
    ->write_end;
  endtask
  
  
endclass