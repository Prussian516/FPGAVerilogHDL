module clk_divice(
input clk,
input rst_n,
output clk_out//由于FPGA工作频率很高，我的板子上时钟是50MHz，数码管显示的最佳扫描频率是1KHz，
);
//模块是做的一个50K的分频电路，是一个整数分频
parameter N2=50000;

reg clk3=1'b0;
reg[16:0] count3=17'd0;
assign clk_out=clk3;

always@(posedge clk or negedge rst_n)
 begin
   if(!rst_n)
	  begin
	    count3<=17'd0;
		 clk3<=1'b0;
	  end
	else
	  if(count3<N2-1)
	    begin
		   count3<=count3+1'b1;
			if(count3<(N2/2-1))
			  clk3<=1'b0;
			else
			  clk3<=1'd1;
		 end
	  else
	  begin
	    count3<=17'd0;
		 clk3<=1'b0;
	  end
 end
endmodule
