`define vs_state 1
`define vsbp_state 2
`define vsfp_state 3
`define hs_state 4
`define hsbp_state 5
`define hsfp_state 6
`define pixel_state 7
`define vs 1
`define vsbp 1
`define vsfp 1
`define hs 1
`define hsfp 1
`define hsbp 1
`define x_res 10
`define y_res 10

module vga(
  input clk,
  input reset,
  output reg [7:0] rgb,
  output reg vsync,
  output reg hsync
);
 
  reg [9:0] statecounter;
  reg [2:0] state;
  reg [9:0] x_counter;
  reg [9:0] y_counter;

  
  // Initial
  always @ (posedge clk && reset == 1'b1) 
    begin
      statecounter <= `vs;
      rgb <= 8'b0;
      vsync <= 1'b0;
      hsync <= 1'b0;
      state = `vs_state;
      y_counter = `y_res;
    end

  
  
  
  //Start
  always @ (posedge clk && reset == 1'b0)
        begin
          
          statecounter = statecounter - 1;   // RUN STATE SWITCHER
          if (statecounter == 10'b0) 
            begin
              if (state == `vs_state)
                begin
                  state = `vsbp_state;
                  statecounter = `vsbp;
                  y_counter = `y_res;		// Start line counting at the end of vsync
                end
              else if (state == `vsbp_state)
                begin
                  state = `hs_state;
                  statecounter = `hs;
                end
              else if (state == `hs_state)
                begin
                  state = `hsbp_state;
                  statecounter = `hsbp;
                end
              else if (state == `hsbp_state)
                begin
                  state = `pixel_state;
                  statecounter = `x_res;
                end
              else if (state == `pixel_state)
                begin
                  state = `hsfp_state;
                  statecounter = `hsfp;
                end
              else if (state == `hsfp_state)
                begin
  
                  y_counter = y_counter - 1;
                  
                  if (y_counter == 10'b0)	// If this was the last line, vsync
                    begin
                      state = `vsfp_state;
                      statecounter = `vsfp;
                    end
                  else						// else next line
                    begin
                      state = `hs_state;
                      statecounter = `hs;
                    end
                  
                end
              else if (state == `vsfp_state)
                begin
                  state = `vs_state;
                  statecounter = `vs;
                end
            end
          
          
          
  
  		        
          if (state == `vs_state) // vsync pulse, nothing else
    		begin
              vsync = 1'b1;
    		end
          
          if (state == `vsbp_state) // vsync backporch, end vsync pulse, reset line counter
    		begin
              vsync = 1'b0;
              
    		end
          
          if (state == `hs_state) // hsync pulse, nothing else
    		begin
              hsync = 1'b1;
    		end
          
          if (state == `hsbp_state) // hsync backporch, end hsync backporch
    		begin
              hsync = 1'b0;
    		end
          
          if (state == `pixel_state) // pixel, output useful stuff in rgb
    		begin
              rgb = 8'b1;
    		end
          
          if (state == `hsfp_state) // hsync frontporch, disable rgb, do nothing
    		begin
              rgb = 8'b0;
    		end
          
          if (state == `vsfp_state) // vsync frontporch, do nothing
    		begin

    		end
        
          
          
        end

endmodule    



// state order sort of:
//
// vs vsbp (hs, hsbp, (pixel x x_res) ,hsfp  x y_res) vsfp
