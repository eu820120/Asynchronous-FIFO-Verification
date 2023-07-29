program automatic test();
  
  virtual if_wr if_wr_vi;
  virtual if_rd if_rd_vi;
  virtual if_beh if_beh_vi;
  
  environment env;
  count cnt;
  
  
  initial begin
    //connect virtual interfaces to tb_top
    if_wr_vi = tb_top.if_w;
    if_rd_vi = tb_top.if_r;
    if_beh_vi = tb_top.if_beh;
    
    env = new(if_wr_vi, if_rd_vi, if_beh_vi);
    cnt = new();
    
    /***********Test Case 1****************/
    $display("Starting of test case 1: checking full condition with only write");
    cnt.write_count = 20;
    cnt.read_count = 0;
    env.run(cnt.write_count,cnt.read_count);
    $display("End of test case 1");
    
    /***********Test Case 2****************/
    $display("\n\n\nStarting of test case 2: checking empty condition with only read");
    cnt.write_count = 0;
    cnt.read_count = 10;
    env.run(cnt.write_count,cnt.read_count);
    $display("End of test case 2");
    
    /***********Test Case 3****************/
    $display("\n\n\nStarting of test case 3: simultaneous write and reads");
    cnt.randomize();
    env.run(cnt.write_count,cnt.read_count);
    $display("End of test case 3");
    
    
  end
  
endprogram
