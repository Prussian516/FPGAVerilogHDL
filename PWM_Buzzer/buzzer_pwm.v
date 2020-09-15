module buzzer_pwm
#(
  parameter N=16//可给外部调用的参数，即在实例化时可传递参数
)
(clk,rst_n,period,duty,pwm_out);

input clk;
input rst_n;
input [N-1:0] period;//用于控制计数的速度，从而控制PWM的频率
input [N-1:0] duty;//用于控制比较值，从而控制脉宽
output pwm_out;

reg[N-1:0] period_r;
reg[N-1:0] duty_r;
reg[N-1:0] period_cnt;//PWM计数器
reg pwm_r;

assign pwm_out=pwm_r;

always@(posedge clk or negedge rst_n)
begin
  if(rst_n==0)
  begin
    period_r<={N{1'b0}};
	 duty_r<={N{1'b0}};
  end
  else
  begin
    period_r<=period;//实时更新PWM效率
	 duty_r<=duty;//实时更新PWM脉宽
  end
end

always@(posedge clk or negedge rst_n)
begin
  if(rst_n==0)
    period_cnt<={N{1'b0}};
  else
    period_cnt<=period_cnt+period_r;//PWM计数器，每个时钟上升沿以设定速度(period_r)计数
end

always@(posedge clk or negedge rst_n)
begin
  if(rst_n==0)
  begin
    pwm_r<=1'b0;
  end
  else
  begin
    if(period_cnt>=duty_r)//输出PWM
	   pwm_r<=1'b1;//计数器数值大于比较值时输出1电平
	 else
	   pwm_r<=1'b0;//计数器数值小于比较值时输出0电平
  end
end

endmodule 
	
	 