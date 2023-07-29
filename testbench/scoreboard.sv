class scoreboard;
  
  mailbox #(transaction) drv2sco, rec2sco;
  transaction tr_w, tr_r;
  virtual if_wr if_wr_vi;
  virtual if_rd if_rd_vi;
  virtual if_beh if_beh_vi;
  
  
  function new(virtual if_wr if_wr_vi, virtual if_rd if_rd_vi, virtual if_beh if_beh_vi,mailbox #(transaction) drv2sco, mailbox #(transaction) rec2sco);
    this.if_wr_vi = if_wr_vi;
    this.if_rd_vi = if_rd_vi;
    this.if_beh_vi = if_beh_vi;
    this.drv2sco = drv2sco;
    this.rec2sco = rec2sco;
  endfunction
  
  task monitor_full();
    forever begin
      @(posedge if_wr_vi.wfull) begin
        $display("%dns : scoreboard::FIFO gets full!", $time);
      end     
    end
  endtask
  
  task monitor_empty();
    forever begin  
      @(negedge if_rd_vi.rempty) 
      $display("%dns : scoreboard::FIFO gets out of empty state!", $time);
    end 
  endtask
  
  
  task check();
    fork
    forever begin
      @(posedge if_wr_vi.wclk);
      #1;
      if(if_rd_vi.rdata != if_beh_vi.rdata) $error("read data mismatch!");
      if(if_wr_vi.wfull != if_beh_vi.wfull) $error("full status mismatch!");
    end
    
    forever begin
      @(posedge if_rd_vi.rclk);
      #1
      if(if_rd_vi.rempty != if_beh_vi.rempty) $error("empty status mismatch!");
    end
    join
  endtask
  
  task run();
    fork
      monitor_full();
      monitor_empty();
      check();
    join_none
  endtask
  
endclass