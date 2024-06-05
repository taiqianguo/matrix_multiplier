// here's the mac module with two 8 bit signed input and 19 bit output without overflow protection.




module mac(

input wire clk,
input wire macc_clear,
input wire signed [7:0] A,
input wire signed [7:0] B,
output reg signed [18:0] C=0
);



//wire [15:0]AB;// 16 bit for multiply result
//assign AB=$signed ( A*B);
//wire [18:0]AB_ex;
//assign AB_ex=$signed ( {{3{AB[15]}},AB});// the is the explicit signed extension from 8 bit to 19 bit alinged with output bit width. 


always @ (posedge clk)
if(macc_clear)// this if else will be synthesized to the switch in diagram
C<=A*B;

else 
C<=C+A*B;// normal mac function


endmodule