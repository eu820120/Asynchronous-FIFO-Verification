class environment;
  mailbox #(transaction) drv2sco, rec2sco;
  virtual if_wr if_wr_vi;
  virtual if_rd if_rd_vi;
  virtual if_beh if_beh_vi;
  driver drv;
  receiver rec;
  scoreboard sco;
  
  
  
  function new(virtual if_wr if_wr_vi, virtual if_rd if_rd_vi, virtual if_beh if_beh_vi);
    this.if_wr_vi = if_wr_vi;
	this.if_rd_vi = if_rd_vi;
    this.if_beh_vi = if_beh_vi;
  endfunction
  
  task build();
    drv2sco = new();
    rec2sco = new();
    drv = new(drv2sco,if_wr_vi.DRV);
    rec = new(rec2sco,if_rd_vi.REC);
    sco = new(if_wr_vi, if_rd_vi,if_beh_vi, drv2sco, rec2sco);
  endtask
  
  task reset();
    if_wr_vi.wdata <= 0;
    if_wr_vi.winc <= 0;
    if_wr_vi.wrst_n <= 0;
    if_rd_vi.rinc <= 0;
    if_rd_vi.rrst_n <= 0;
    
    repeat(12) @if_wr_vi.wclk;
    if_wr_vi.wrst_n <= 1;
    if_rd_vi.rrst_n <= 1;
  endtask
  
  task run(input int write_count, read_count);
    this.build();
    this.reset();
    drv.count = write_count;
    rec.count = read_count;
    fork
      sco.run();
      drv.write();
      rec.read();
    join
  endtask
    
  
  
endclass