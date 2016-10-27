// Just a clk generator

module vga_tb();
  
reg clk;
  reg reset;
  wire rgb;
  wire vsync;
  wire hsync;
  
  vga dut(.clk(clk),
          .reset(reset),
          .rgb(rgb),
          .vsync(vsync),
          .hsync(hsync)
         );
  
  initial begin
    clk = 1'b0;
    reset = 1'b1;
    #3 reset = 1'b0;
  end
  
  initial begin
    #0 $dumpfile("dump.vcd"); $dumpvars;
    #400 $finish;
  end
  
 always #1 clk = ~clk;
endmodule