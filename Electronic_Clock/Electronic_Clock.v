module Electronic_Clock(clk,rst_n,sm_seg,sm_bit);

input clk;//
input rst_n;
output reg[7:0] sm_seg;
output reg[5:0] sm_bit;

wire clk1;
wire [7:0]op0,op1,op2,op3,op4,op5;

//定义状态机
parameter IDLE=7'b111111_0,
          SA=7'b111110_1,
			 SB=7'b111101_1,
			 SC=7'b111011_1,
			 SD=7'b110111_1,
			 SE=7'b101111_1,
			 SF=7'b011111_1;
reg[6:0] state;
reg[3:0] Num;

clk_divice M1(
  .clk(clk),
  .rst_n(rst_n),
  .clk_out(clk1)
);

clk_dis1_count M2(
  .clk1(clk1),
  .rst_n(rst_n),
  .op0(op0),
  .op1(op1),
  .op2(op2),
  .op3(op3),
  .op4(op4),
  .op5(op5)
);

always@(posedge clk1 or negedge rst_n)
begin
 if(!rst_n)
   state<=IDLE;
 else
   begin
	case(state)//数码管片选电平为0时数码管点亮，这里设计一个状态机，
	//设计一个IDLE状态和六个输出状态在对应数码管点亮时输出对应位置的数据，然后切换到下一个输出状态。
	    IDLE:state<=SA;
		 SA:
		   begin
			  sm_bit<=6'b011111;
			  Num<=op0;
			  state<=SB;
			end
		 SB:
		   begin
			  sm_bit<=6'b101111;
			  Num<=op1;
			  state<=SC;
			end
		 SC:
		   begin
			  sm_bit<=6'b110111;
			  Num<=op2;
			  state<=SD;
			end
		 SD:
		   begin
			  sm_bit<=6'b111011;
			  Num<=op3;
			  state<=SE;
			end
		 SE:
		   begin
			  sm_bit<=6'b111101;
			  Num<=op4;
			  state<=SF;
			end
		 SF:
		   begin
			  sm_bit<=6'b111110;
			  Num<=op5;
			  state<=SA;
			end
		default state <= IDLE;
	endcase
  end
end

always@(Num)
 begin
   case(Num)//在FPGA开发板上面的数码管建立一个查询表，设计过程用case(Num)语句改变输出；
	  4'h0:sm_seg=8'hc0;//0
	  4'h1:sm_seg=8'hf9;//1
	  4'h2:sm_seg=8'ha4;//2
	  4'h3:sm_seg=8'hb0;//3
	  4'h4:sm_seg=8'h99;//4
	  4'h5:sm_seg=8'h92;//5
	  4'h6:sm_seg=8'h82;//6
	  4'h7:sm_seg=8'hf8;//7
	  4'h8:sm_seg=8'h80;//8
	  4'h9:sm_seg=8'h90;//9
	  4'ha:sm_seg=8'h88;//a
	  4'hb:sm_seg=8'h83;//b
	  4'hc:sm_seg=8'hc6;//c
	  4'hd:sm_seg=8'ha0;//d
	  4'he:sm_seg=8'h86;//e
	  4'hf:sm_seg=8'h8d;//f
	endcase
 end
 
endmodule
			  