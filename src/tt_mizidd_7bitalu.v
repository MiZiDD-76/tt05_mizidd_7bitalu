`default_nettype none

module tt_um_mizidd_7bitalu (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// Accumulator based ALU
// Pin assignments:
// ui_in[6:0]  ... input operand (immediate data)
// ui_in[7]    ... unused (atm.)
// uo_out[6:0] ... result (current accumulator content)
// uo_out[7]   ... carry flag output
// uio_in[2:0] ... opcode
//      3'b000 : NOP
//      3'b001 : LOAD (accu <= operand)
//      3'b010 : ADD (carry,accu <= accu+operand+carry)
//      3'b011 : SUB (carry,accu <= accu-operand)
//       

wire [6:0] operand ;
assign operand = ui_in[6:0];
reg [6:0] accu ;
reg carry;
assign uo_out[6:0] = accu;
assign uo_out[7] = carry;
wire opcode[2:0];
assign opcode=uio_in[2:0];

always @(posedge clk ) begin
    if (rst_n == 0) begin
        accu<=0;
        carry<=0;        
    end else begin
        case (opcode)
            3'b001: begin
                // LOAD
                accu<=operand;
                carry<=carry;
            end 
            3'b010: begin
                // ADD
                {carry,accu}<=accu + operand + carry;
            end

            default: begin
                accu<=accu;
                carry<=carry;
            end 
        endcase
    end
end


endmodule
