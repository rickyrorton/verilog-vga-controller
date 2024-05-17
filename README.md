# VGA Controller Verilog Implementation

## Overview
This Verilog module implements a VGA (Video Graphics Array) controller that generates video signals compatible with VGA monitors. The controller generates the necessary synchronization signals (HSYNC and VSYNC) along with the pixel data to display images on a VGA monitor.

## Features
- Generates H_SYNC and V_SYNC signals for SVGA 800 x 600 60Hz signal.
- By changing pixel clock frequency, horizontal and vertical parameters, module can output H_SYNC and V_SYNC for different modes given [here](http://www.tinyvga.com/vga-timing).
- Simple interface for connecting to a video memory or other display data source. ```next_x``` and ```next_y``` gives the pixel coordinates and ```colour_in``` can be connected to the data lines to recieve data in 8 bit (3-3-2) colour format
- To connect to a monitor the colour outputs have to be connected through a DAC to convert digital values to 0 - 0.7 V analog signal while the H_SYNC and V_SYNC can be connected directly as they are 0V/5V digital waveforms
## References
- [Timing data](http://www.tinyvga.com/vga-timing/800x600@60Hz)
- [VGA pinout and other data](https://forum.digikey.com/t/vga-controller-vhdl/12794)

## Timing diagram showing H_SYNC AND V_SYNC signals
![43a91de5f1cc2ab380b22c4758b8b408da97e0c2](https://github.com/rickyrorton/verilog-vga-controller/assets/74890659/6a08afb6-63ca-42e7-9886-0484cc3fd654)

## Timing data for horizontal and vertical
![image](https://github.com/rickyrorton/verilog-vga-controller/assets/74890659/b8fca43f-f791-429c-b8da-cb1aa851c0b8)
