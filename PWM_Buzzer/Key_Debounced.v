module Key_Debounced(clk,rst_n,key,key_flag,key_value);

input clk;//外部50MHz时钟
input rst_n;//外部复位信号，低有效
input[2:0]key;//外部按键输入，按下后为0电平
output reg key_flag;//按键数据有效信号，即表示延时结束，按键已稳定
output reg[2:0] key_value;

//reg define
reg[19:0] delay_cnt;//消抖延时的计数器
reg[2:0] key_reg;//按键值存储

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)
  begin
    key_reg<=3'b111;//按键值复位，全为1电平
	 delay_cnt<=19'd0;//计数器清零
  end
  else
  begin
    key_reg<=key;//非阻塞赋值，因此下行if判断中的key_reg仍为前一次的数据，而非此次的key
	 if(key_reg!=key)//一旦检测到按键状态发生变化（有按键被按下即释放）
	   delay_cnt<=19'd1_000_000;//给延时计数器重新装载初始值（计数时间20ms）
		else if(key_reg==key)
		begin//在按键状态稳定时，计数器递减，开始20ms倒计时
		  if(delay_cnt>19'd0)
		    delay_cnt<=delay_cnt-1'b1;
		  else
		    delay_cnt<=delay_cnt;
		end
	end
end

always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
	 begin
	   key_flag<=1'b0;
		key_value<=3'b111;
	 end
	 else
	 begin
	   if(delay_cnt==19'd1)//减到1而不是0的原因是：复位情况和无按键按下时按下时cnt恒为0，则key_flag会一直为1
	     begin
		    key_flag<=1'b1;//此时消抖过程结束，给出一个时钟周期的标志信号
			 key_value<=key;//并寄存到此时按键的数值
		  end
		  else
		  begin
		    key_flag<=1'b0;//延时未到，不给出有效信号
			 key_value<=key_value;
		  end
	end
end

endmodule
		  
		  
