module matrix_mux1(
input clk,
input reset,
input start,
output reg done,
output [11:0]clock_count
);


wire [7:0] dataa;
wire [5:0] addra;
reg wea=0 ;
wire signed [7:0] A;

    // Instantiate the RAM
 single_port_ram_a RAMOUTPUTA (
	  .data(dataa),
	  .addr(addra),
	  .we(wea),
	  .clk(clk),
	  .A(A)
 );

wire [7:0] datab;
wire [5:0] addrb;
reg web=0 ;
wire signed [7:0]B; 
 
single_port_ram_b RAMOUTPUTB (
	  .data(datab),
	  .addr(addrb),
	  .we(web),
	  .clk(clk),
	  .B(B)
 );

 
wire [18:0] datac;
wire [5:0] addrc;
wire wec ;
wire signed [18:0]C; 
 
single_port_ram_c RAMOUTPUT (
	  .data(datac),
	  .addr(addrc),
	  .we(wec),
	  .clk(clk),
	  .C(C)
 );

 
 reg [1:0]state;
  //00 for wait, 01 for processing after start signal asserted, 10 for done
 reg [11:0]counter=0;
 assign clock_count=counter;


//finite state machine
always@(posedge clk)
begin

case(state)
2'b00:
		begin
		if(start) state<=2'b01;
		else state<=state;
		end
2'b01:
		begin
		if(reset) state<=2'b00;
		else if(done) state<=2'b10;
		else state<=state;
		end
2'b10:
		begin
		if(reset) state<=2'b00;
		else state<=state;
		end
default: state<=2'b00;
endcase
end

//counter processing

always@(posedge clk)
if(reset) counter<=0;
else if(start || state==2'b01) counter<=counter+1;
else counter<=counter;// this is the done state;


// instantiate MAC

wire macc_clear;

mac mac1(
.clk(clk),
.macc_clear(macc_clear),
.A(A),
.B(B),
.C(datac)
);

assign wec=(counter[2:0]==3'b001)?1:0;// this indicate one element in C finished and write to matrix
assign macc_clear=(counter[2:0]==3'b001)?1:0;// this is clean mac when finish one element calculation

assign addra={counter[8:6],counter[2:0]} ;
assign addrb={counter[2:0],counter[5:3]};// row access of B
assign addrc=counter[8:3]-1;

always @(posedge clk)
if(reset)
done<=0;
else if(counter==12'b001000000001)
done<=1;
else 
done<=done;


 
endmodule
