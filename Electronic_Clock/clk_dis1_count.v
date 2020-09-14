module clk_dis1_count(clk1,rst_n,op0,op1,op2,op3,op4,op5);
input clk1,rst_n; //声明时钟和复位信号，此处时钟为分频后的1KHz信号
output reg[5:0] op0=6'd0;
output reg[5:0] op1=6'd0;
output reg[5:0] op2=6'd0;
output reg[5:0] op3=6'd0;
output reg[5:0] op4=6'd0;
output reg[5:0] op5=6'd0;//op0,op1,op2,op3,op4,op5为数码管显示时钟

//reg[9:0] count_clk1=10'd0;
//parameter N2=50; //1KHz->2Hz,在clk_divice模块中的count3时间计算参数定义
parameter N2=1000;//更改为1Hz,每一秒输出一次,作为电子表使用.十位数可以达到1024,不会数据溢出
  reg clk3=1'b0;//输出clk3,2Hz
  reg[9:0] count_clk1=10'd0;//计数器
  
 always@(posedge clk1 or negedge rst_n)
 begin
   if(!rst_n)
	  begin
	    count_clk1<=10'd0;
		 clk3<=1'b0;
	  end
	else
	  if(count_clk1<N2-1)
	    begin
		   count_clk1<=count_clk1+1'b1;
			if(count_clk1<(N2/2-1))
			  clk3<=1'b0;
			else
			  clk3<=1'b1;
	    end
	  else
	  begin
	    count_clk1<=10'd0;
		 clk3<=1'b0;
	  end
end

always@(posedge clk3 or negedge rst_n)
begin
  if(!rst_n)
    begin
	   op0<='d0;
		op1<='d0;
		op2<='d0;
		op3<='d0;
		op4<='d0;
		op5<='d0;
	 end
  else
  begin
    if(op0<9)
	   op0<=op0+1'b1;//如果秒钟最低位小于9,则加一,否则最低位变为0
	 else
	   begin
		  if(op1<5)
		    op1<=op1+1'b1;//秒钟最低位为9时,十位是否为5,若小于5,十位加一,否则即为59->00,后两位为00分位置加一
		  else
		    begin
			   if(op2<9)
				  op2<=op2+1'b1;//由于分和秒都是60进制,因此方法同上.
				else
				  begin
				    if(op3<5)
					   op3<=op3+1'b1;
					 else
					   begin
						  if(op4<4)
						    op4<=op4+1'b1;//时钟最低位小于4,则加一,否则最低位变为0.
						  else
						    begin
							   if(op5<2)
								  op5<=op5+1'b1;
								else
								  op5<='d0;
								op4<='d0;
						    end
							 op3<='d0;
						  end
						  op2<='d0;
						end
						op1<='d0;
					end
					op0<='d0;
				end
			end
end
endmodule
 