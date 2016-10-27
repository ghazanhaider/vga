# vga

Basic VGA driver
In the future it will poll dual port memory and/or a bitmap file from serial flash

Rules:
- none of the state clock timings should be below 1
- 10-bit x and y resolution can go up to 1024x1024. Increase variables for higher res.
- feed clock at the correct 25.762MHz at clk
- Adjust rgb width on hardware setup

Todo:
- Logic to draw SOMETHING
- dual port memory to be fed by mcu/arduino/picoblaze
