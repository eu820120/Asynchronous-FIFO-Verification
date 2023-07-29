class transaction
  #(
	parameter DSIZE = 8 //data size
  );
  
  rand bit [DSIZE-1:0] wdata; //randomize data
  bit [DSIZE-1:0] rdata;
  
  constraint datac{
    wdata dist{[0:64] := 10};
  }
  
  function void display(input string s);
    $display("%s: Write data = %d @ %t",s,wdata,$time);
  endfunction
  
  function int compare(input transaction tr);
    return (tr.wdata == this.wdata);
  endfunction
    
endclass

