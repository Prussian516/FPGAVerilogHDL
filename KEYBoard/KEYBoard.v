module KEYBoard
(
input clk, //System clock 50MHz on board
input [3:0] key, //Input 4 key signal,when the keydown,the light will be lighting.
output [3:0] led  //LED dissplay,when the signal high,LED light 
);

reg[3:0] led_r; 
//定义第一个寄存器数据
reg[3:0] led_r1; 
//定义第二个寄存器数据，两个寄存器构成双非逻辑电路
always@(posedge clk)
begin
 led_r<=~key;
 //当keydown时，则按键触发低电平，则命令led_r也触发低电平 
end

always@(posedge clk)
begin
 led_r1<=led_r; 
 //当第一个寄存器的信号开始出现低电平，则触发第二个寄存器也触发低电平，就形成
 //从input key到output led的电路接通
end

assign led=led_r1;//双非逻辑电路

endmodule
