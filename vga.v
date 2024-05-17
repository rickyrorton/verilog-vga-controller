// vga controller for 800 x 600 resolution at 60Hz,pixel clk required - 40Mhz
module vga (
    input pixel_clk,reset,
    //input [7:0]colour_in, //3-3-2 8bit colour input
    //output [7:0]red,green,blue, // cannot be directly fed to monitor,
    output reg h_sync,v_sync
    //output [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
    //output [9:0] next_y  // y-coordinate of NEXT pixel that will be drawn
);
    //Horizontal parameters
    parameter h_visible = 10'd799 , h_front = 10'd39 , h_pulse = 10'd127 , h_back = 10'd87 ;
    
    //Verical parameters
    parameter v_visible = 10'd599 , v_front = 10'd0 , v_pulse = 10'd3 , v_back = 10'd22 ;
    
    //States
    parameter h_visible_s = 2'b00 , h_front_s = 2'b01 , h_pulse_s = 2'b10 , h_back_s = 2'b11 ;
    parameter v_visible_s = 2'b00 , v_front_s = 2'b01 , v_pulse_s = 2'b10 , v_back_s = 2'b11 ;

    //Parameters for readability
    parameter LOW = 1'b0 , HIGH = 1'b1 ;

    //registers
    reg [7:0] red_reg,blue_reg,green_reg;
    reg [9:0] h_counter,v_counter;
    reg [1:0] h_state,v_state,h_nstate,v_nstate;
    reg line_done;


    //current state control block
    always @(posedge pixel_clk,negedge reset) begin
        if (!reset)begin
            h_counter <= 10'd0;
            v_counter <= 10'd0;

            h_state <= h_visible_s;
            v_state <= v_visible_s;

            line_done <= HIGH;
        end
    end

    always @(h_nstate,v_nstate) begin
        h_state <= h_nstate;
            v_state <= v_nstate;
    end

    //next state control
    always @(posedge pixel_clk) begin
        //Horizontal next state control
        case (h_state)
            h_visible_s : h_nstate <= (h_counter == h_visible) ? h_front_s : h_visible_s;
            h_front_s   : h_nstate <= (h_counter == h_front) ? h_pulse_s : h_front_s;
            h_pulse_s   : h_nstate <= (h_counter == h_pulse) ? h_back_s : h_pulse_s;
            h_back_s    : h_nstate <= (h_counter == h_back) ? h_visible_s : h_back_s;
            default     : h_nstate <= h_state;
        endcase

        //Vertical next state control
        case (v_state)
            v_visible_s : v_nstate <= (line_done==HIGH) ? ((v_counter==v_visible) ? v_front_s : v_visible_s) : v_visible_s ;
            v_front_s   : v_nstate <= (line_done==HIGH) ? ((v_counter==v_front) ? v_pulse_s : v_front_s) : v_front_s ;
            v_pulse_s   : v_nstate <= (line_done==HIGH) ? ((v_counter==v_pulse) ? v_back_s : v_pulse_s) : v_pulse_s ;
            v_back_s    : v_nstate <= (line_done==HIGH) ? ((v_counter==v_back) ? v_visible_s : v_back_s) : v_back_s ;
            default     : v_nstate <= v_state;
        endcase
    end
    

    //increment counter and output control block
    always @(posedge pixel_clk) begin
        //Horizontal control
        case (h_state)
            h_visible_s : begin
                h_counter <= (h_counter == h_visible) ? 10'd0 : (h_counter + 10'd1);
                h_sync <= HIGH;
                line_done <= LOW;
            end

            h_front_s   : begin
                h_counter <= (h_counter == h_front) ? 10'd0 : (h_counter + 10'd1);
                h_sync <= HIGH;
                line_done <= LOW;
            end

            h_pulse_s   : begin
                h_counter <= (h_counter == h_pulse) ? 10'd0 : (h_counter + 10'd1);
                h_sync <= LOW;
                line_done <= LOW;
            end

            h_back_s    : begin
                h_counter <= (h_counter == h_back) ? 10'd0 : (h_counter + 10'd1);
                h_sync <= HIGH;
                line_done <= (h_counter == (h_back-1))? HIGH : LOW;
            end
            default     : begin
                h_counter <= 10'b0;
                h_sync <= HIGH;
                line_done <= LOW;
            end
        endcase

        //Vertical control
        case (v_state)
            v_visible_s :begin
                v_counter<=(line_done==HIGH) ? ((v_counter==v_visible) ? 10'd0 : (v_counter+10'd1)) : v_counter ;
                v_sync <= HIGH;
            end

            v_front_s   :begin
                v_counter<=(line_done==HIGH) ? ((v_counter==v_front) ? 10'd0 : (v_counter+10'd1)) : v_counter ;
                v_sync <= HIGH;
            end

            v_pulse_s   :begin
                v_counter<=(line_done==HIGH) ? ((v_counter==v_pulse) ? 10'd0 : (v_counter+10'd1)) : v_counter ;
                v_sync <= LOW;
            end

            v_back_s    :begin
                v_counter<=(line_done==HIGH) ? ((v_counter==v_back) ? 10'd0 : (v_counter+10'd1)) : v_counter ;
                v_sync <= HIGH;
            end

            default     :begin
                v_counter <= 10'b0;
                v_sync <= HIGH;
            end
        endcase
    end


            //red_reg <= ((v_state == v_visible_s) && (h_state == h_visible_s))? {colour_in[7:5],5'd0} : 8'd0 ;
            //green_reg <= ((v_state == v_visible_s) && (h_state == h_visible_s))? {colour_in[4:2],5'd0} : 8'd0;
            //blue_reg <= ((v_state == v_visible_s) && (h_state == h_visible_s))? {colour_in[1:0],5'd0} : 8'd0;
    // The x/y coordinates that should be available on the NEXT cycle
    //assign next_x = (h_state==h_visible_s)?h_counter:10'd_0 ;
    //assign next_y = (v_state==v_visible_s)?v_counter:10'd_0 ;    
endmodule