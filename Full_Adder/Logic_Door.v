module Logic_Door(
 input wire Pin_A,
 input wire Pin_B,
 input wire Pin_Cin,
 output reg Pin_Cout,
 output reg Pin_S
 );
 
 always@(*)
  begin
     Pin_Cout=~(~(Pin_A&Pin_B)|((Pin_Cin&(~(~Pin_A&Pin_B)|(Pin_A&~Pin_B)))));
	  Pin_S=(~((~Pin_A&Pin_B)|(Pin_A&~Pin_B))&Pin_Cin)|(((~Pin_A&Pin_B)|(Pin_A&~Pin_B))&(~Pin_Cin));
  end
endmodule
  
 