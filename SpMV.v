

// sparse matrix vector multiplication based on CSR format
//S*v = d

module matrix_mux(
input clk,
input reset,
input start,
output wire done,
output [11:0]clock_count

);



//initialize row index mem
reg [5:0]row_index_addr=0;// 16 rows in total, 17 data points 
reg wer=0;//row mem write enable
wire [6:0]des_address;// based on the 25%  sparsity constrain the max value in row index is 16*4=64, notice not 63.
reg [6:0]base_address=0;// used as column index and V address.

wire [6:0]data_in1;
single_port_ram_row row_index(
.data(data_in1),
.addr(row_index_addr),
.we(wer),
.clk(clk),
.data_out(des_address)
);

reg [1:0]state=0;
  //00 for wait, 01 for processing after start signal asserted, 10 for row finish, 11 for done 
reg [11:0]counter=0;
assign clock_count=counter;

always @(posedge clk)

if(reset)
begin
base_address<=0;
row_index_addr<=1;// in the next cycle des_address will be give, which is the first cycle after reset
end
else if(state==2'b01 && base_address==(des_address-1))
begin
row_index_addr=row_index_addr+1;
base_address<=des_address;// equvalent to base_address+1
end
else if(state==2'b01)
begin
row_index_addr=row_index_addr;
base_address<=base_address+1;
end
else 
begin//reset but not start , or done 
row_index_addr=row_index_addr;
base_address<=base_address;
end

wire macc_clear;// Sv=d
assign macc_clear = (base_address==des_address-1);



assign done= ((row_index_addr==16) &&( base_address==des_address-1));


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
else if(start || state==2'b01) counter<=counter+1;//when couner=1 , state=2'b01, the colum and S start fetching
else counter<=counter;// this is the done state;



//initialize S ,column_index, v , mac ,d 

reg we=0;

// Data and address lines for each module
wire [3:0] data_column;
wire [7:0] data_vector;
wire [5:0] addr_column;
wire [5:0] addr_S;
assign addr_column=base_address[5:0];
assign addr_S=addr_column;


wire [3:0] data_out_column;
wire [7:0] data_out_S;
wire [7:0] data_out_vector;
wire [18:0] datac4;
wire [5:0]addrd;
assign addrd=row_index_addr-2;

reg [7:0]S_temp=0;


// delay buffer 
always@( posedge clk)
if(state==2'b01)
S_temp<=data_out_S;


wire [3:0]data_in2;
// Instantiate single_port_ram_column
single_port_ram_column column_index (
    .data(data_in2),
    .addr(addr_column),
    .we(we),
    .clk(clk),
    .data_out(data_out_column)
);

wire [7:0]data_in3;
// Instantiate single_port_ram_S
single_port_ram_S Sp (
    .data(data_in3),
    .addr(addr_S),
    .we(we),
    .clk(clk),
    .data_out(data_out_S)
);

single_port_ram_vector vector_in (
    .data(sata_in3),
    .addr(data_out_column),
    .we(we),
    .clk(clk),
    .data_out(data_out_vector)
);

mac mac4(
.clk(clk),
.macc_clear(macc_clear || (state==2'b00)),
.A(S_temp),
.B(data_out_vector),
.C(datac4)
);

wire [18:0]result_out;
single_port_ram_d d_result_vector (
    .data(datac4),
    .addr(addrd),
    .we(macc_clear_delay),
    .clk(clk),
    .data_out(result_out)
);





endmodule












