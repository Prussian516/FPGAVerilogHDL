module Key_Buzzer_Test(clk,rst_n,key,buzzer);

input clk;
input rst_n;
input [2:0]key;
output buzzer;

parameter IDLE=0;//蜂鸣器关闭状态
parameter BUZZER=1;//蜂鸣器打开状态

wire [2:0] key_value;//按键值
wire key_flag;//按键有效标志
wire pwm_out;

reg[31:0] period;//PWM技术速度
reg[31:0] duty;//比较值
reg[31:0] timer;//250ms延时定时器
reg state;

assign buzzer=~(pwm_out&(state==BUZZER));//PWM为高电平且蜂鸣器处于打开状态时为蜂鸣器的I/O口输出PWM

always@(posedge clk or negedge rst_n)
begin
  if(rst_n==0)
  begin
    period<=32'd8590;
	 timer<=32'd0;
	 duty<=32'd429496729;
	 state<=IDLE;
  end
  else
  begin
    case(state)
	   IDLE:
		begin
		  if(key_flag&&key_value[0]==0)//KEY1控制音量（PWM脉宽）
		  begin
		    period<=32'd8590;//PWM计数速度固定
			 state<=BUZZER;//打开蜂鸣器
			 duty<=duty+32'd429496729;//比较值增加
		  end
		  else if(key_flag&&key_value[1]==0)//KEY2控制音调（PWM频率）
		  begin
		    period<=period+32'd17180;//PWM计数速度增加，PWM频率增加
			 state<=BUZZER;
			 duty<=32'd429496729;//比较值固定
		  end
		  else;
		end
		BUZZER:
		begin
		  if(timer>=32'd12_499_499)//计时250ms后关闭蜂鸣器
		  begin
		    state<=IDLE;
			 timer<=32'd0;
		  end
		  else
		  begin
		    timer<=timer+32'd1;
		  end
		end
	endcase
  end
end

Key_Debounced u_Key_Debounced
(
  .clk(clk),
  .rst_n(rst_n),
  .key(key),
  .key_flag(key_flag),
  .key_value(key_value)
);

buzzer_pwm#
(
  .N(32)//为模块的常量参数进行参数传递
)
u_buzzer_pwm
(
  .clk(clk),
  .rst_n(rst_n),
  .period(period),
  .duty(duty),
  .pwm_out(pwm_out)
);

endmodule
		 