module uart_rx
#(
parameter CLK_FRE=50,//clock frequency(MHz)
parameter BAUD_RATE=115200//serial baud rate
)
(
input clk,//clock input
input rst_n,//asynchronous reset input,low active
output reg[7:0] rx_data,//received serial data
output reg rx_data_valid,//received serial data is valid
input rx_data_ready,//data receiver module ready
input rx_pin //serial data input
);
//calculates the clock cycle for baud rate
localparam CYCLE=CLK_FRE*1000000/BAUD_RATE;
//state machine code
localparam S_IDLE=1;
localparam S_START=2;//start bit
localparam S_REC_BYTE=3;//data bits
localparam S_STOP=4;//stop data
localparam S_DATA=5;

reg[2:0] state;
reg[2:0] next_state;
reg rx_d0;//delay 1 clock for rx_pin
reg rx_d1;//delay 1 clock for rx_d0
wire rx_negedge;//negedge of rx_pin
reg[7:0] rx_bits;//temporary storage of received data
reg[15:0] cycle_cnt;//baud counter
reg[2:0] bit_cnt;//bit counter

assign rx_negedge=rx_d1&& ~rx_d0;

always@(posedge clk or negedge rst_n)
begin
 if(rst_n==1'b0)
  begin
    rx_d0<=1'b0;
	 rx_d1<=1'b0;
  end
  else
  begin
    rx_d0<=rx_pin;
	 rx_d1<=rx_d0;
  end
end

always@(*)
begin
 case(state)
    S_IDLE:
	    if(rx_negedge)
		   next_state<=rx_uart