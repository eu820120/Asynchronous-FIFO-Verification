class clk_config;
  rand int wclkp, rclkp;
  constraint clk_c{
    wclkp inside {[2:100]}; //100Mhz to 5Ghz
    rclkp inside {[2:100]};
    wclkp != rclkp;
  }
endclass

class count;
  rand int write_count, read_count;
  constraint countc{
    write_count inside {[10:50]};
    read_count inside {[10:50]};
  }
  
endclass