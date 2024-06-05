module matrix_mux2(
input clk,
input reset,
input start,
output reg done,
output  [11:0]clock_count
);


wire [7:0] dataa1;
wire [7:0] dataa2;
wire [5:0] addra1;
wire [5:0] addra2;
reg wea=0 ;
wire signed [7:0] A1;
wire signed [7:0] A2;

    // Instantiate the RAM
 dual_port_ram_a RAMOUTPUTA (
	  .data1(dataa1),
	  .addr1(addra1),
	  .data2(dataa2),
	  .addr2(addra2),
	  .we(wea),
	  .clk(clk),
	  .A1(A1),
	  .A2(A2)
	  
 );

wire [7:0] datab1;
wire [7:0] datab2;
wire [5:0] addrb1;
wire [5:0] addrb2;
reg web=0 ;
wire signed [7:0] B1;
wire signed [7:0] B2;

    // Instantiate the RAM
 dual_port_ram_b RAMOUTPUTB (
	  .data1(datab1),
	  .addr1(addrb1),
	  .data2(datab2),
	  .addr2(addrb2),
	  .we(web),
	  .clk(clk),
	  .B1(B1),
	  .B2(B2)
	  
 );
 
wire [18:0] datac1;
wire [18:0] datac2;
reg [5:0] addrc;
wire wec ;
reg signed [18:0]datac=0; 
reg temp_wec=0;
wire [18:0]C;
single_port_ram_c RAMOUTPUT (
	  .data(datac),
	  .addr(addrc),
	  .we(temp_wec),
	  .clk(clk),
	  .C(C)
 );

 
 reg [1:0]state=0;
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

mac mac2(
.clk(clk),
.macc_clear(macc_clear),
.A(A1),
.B(B1),
.C(datac1)
);

mac mac3(
.clk(clk),
.macc_clear(macc_clear),
.A(A2),
.B(B2),
.C(datac2)
);



assign wec=(counter[2:0]==3'b001)?1:0;// this indicate one element in C finished and write to matrix
assign macc_clear=(counter[2:0]==3'b001)?1:0;// this is clean mac when finish one element calculation

assign addra1={counter[7:5],counter[2:0]} ;
assign addra2={counter[7:5],counter[2:0]} ;
assign addrb1={counter[2:0],counter[4:3],1'b0};// row access of B1
assign addrb2={counter[2:0],counter[4:3],1'b1};// row access of B2


always @(posedge clk)
if(reset)
done<=0;
else if(counter==12'b000100000011)
done<=1;
else 
done<=done;



//define buffer
reg [1:0] state1=0;

reg [18:0] temp=0;
reg [18:0] temp_addr=0;

    always @(posedge clk ) begin
        if (reset) begin
            state1 <= 2'b00;
        end 
		  else begin
            case (state1)
                2'b00: 
                    if (wec)
								begin
                        state1 <= 2'b01;
								temp<=datac2;
								datac<=datac1;
								temp_wec<=1;
								addrc<={counter[7:3]-1,1'b0};
								end
							else state1<=state1;
                2'b01: begin //wirte cycle1
								datac<=temp;
								addrc<={counter[7:3]-1,1'b1}; 
								state1 <= 2'b10;
								temp_wec<=1;
								end
								
					 2'b10:begin//write cycle 2
								temp_wec<=0;
								state1<=2'b00;
							 end
					 
                default:state1 <= 2'b00;

            endcase
        end
    end

 
endmodule

