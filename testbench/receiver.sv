class receiver;
  
  transaction tr;
  mailbox #(transaction) rec2sco;
  virtual if_rd.REC if_rd_vi;
  int count;
  bit [7:0] rdata;
  bit emp;
  event read_end;
  
  function new(mailbox #(transaction) rec2sco, virtual if_rd.REC if_rd_vi);
    this.rec2sco = rec2sco;
    this.if_rd_vi = if_rd_vi;
  endfunction
  
  task read();
    repeat(count) begin
      
      repeat(2) @(negedge if_rd_vi.rclk);
      tr = new();
      
      //conditions for read
      #2;
      if_rd_vi.rinc <= 1'b1;
      emp = if_rd_vi.rempty;
      @(negedge if_rd_vi.rclk);
      tr.rdata = if_rd_vi.rdata;
      if_rd_vi.rinc <= 1'b0;
      
      //send read data to scoreboard
      rec2sco.put(tr);
      if(!emp) $display("%dns : receiver::read %d!",$time, tr.rdata);
      else $display("%dns : receiver::read failed, fifo empty",$time);
      
     
      
    end
    ->read_end;
  endtask
  
endclass