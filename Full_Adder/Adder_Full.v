module Adder_Full(
input Pin_Ain,
input Pin_Bin,
input Pin_Come,
output Pin_Coutof,
output Sum
);

wire wire1;
wire wire2;
wire wire3;
  Logic_Door u1(.Pin_A(Pin_Ain),.Pin_B(Pin_Bin),.Pin_Cin(Pin_Come),.Pin_Cout(Pin_Coutof),.Pin_S(Sum));

endmodule
