`timescale 100ps / 100ps
`include "vga.v"
module testbench;

    // Parameters
    parameter CLK_PERIOD = 250; // Clock period in ns
    
    // Inputs
    reg clk;
    reg reset;
    
    // Outputs
    wire h_sync;
    wire v_sync;
    
    // Instantiate VGA module
    vga uut (
        .pixel_clk(clk),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );
    
    // Clock generation
    always #((CLK_PERIOD / 2)) clk <= ~clk;
    
    // Initial reset
    initial begin
        clk = 0;
        reset = 1;
        #1
        reset = 0;
        #10
        reset = 1;
    end
    
    /* Monitor signals
    always @(posedge clk) begin
        $display("Time: %0t, h_sync: %b, v_sync: %b", $time, h_sync, v_sync);
    end
    */
    // Dump VCD file
    initial begin
        $dumpfile("vga_simulation.vcd");
        $dumpvars(0, testbench);
    end
    
    // End simulation after a certain time
    initial begin
        #160000000; // Adjust simulation time as needed
        $finish;
    end
    
endmodule
