module dual_port_ram_a(
    input [7:0] data1,
	 input [7:0] data2,
    input [5:0] addr1,
	 input [5:0] addr2,
    input we, clk,
    output reg [7:0] A1,
	 output reg [7:0] A2
	 
);
    // RAM storage
    reg signed [7:0] mem[63:0];

	 initial
	begin
		$readmemb("ram_a_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr1] <= data1;
				mem[addr2] <= data2;
        end
        A1 <= mem[addr1];
		  A2 <= mem[addr2];// here we did not specific write or read first , by default it will be read first
    end
endmodule



module dual_port_ram_b(
    input [7:0] data1,
	 input [7:0] data2,
    input [5:0] addr1,
	 input [5:0] addr2,
    input we, clk,
    output reg [7:0] B1,
	 output reg [7:0] B2
	 
);
    // RAM storage
    reg signed [7:0] mem[63:0];

	 initial
	begin
		$readmemb("ram_b_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr1] <= data1;
				mem[addr2] <= data2;
        end
        B1 <= mem[addr1];
		  B2 <= mem[addr2];// here we did not specific write or read first , by default it will be read first
    end
endmodule


module single_port_ram_c(
    input [18:0] data,
    input [5:0] addr,
    input we, clk,
    output reg [18:0] C
);
    // RAM storage
    reg signed [18:0] mem[63:0];

	 
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        C <= mem[addr];// here we did not specific write or read first , by default it will be read first
    end
endmodule



module single_port_ram_a(
    input [7:0] data,
    input [5:0] addr,
    input we, clk,
    output reg [7:0] A
);
    // RAM storage
    reg [7:0] mem[63:0];

	 initial
	begin
		$readmemb("ram_a_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        A <= mem[addr];// here we did not specific write or read first , by default it will be read first
    end
endmodule


module single_port_ram_b(
    input [7:0] data,
    input [5:0] addr,
    input we, clk,
    output reg [7:0] B
);
    // RAM storage
    reg signed [7:0] mem[63:0];

	 initial
	begin
		$readmemb("ram_b_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        B <= mem[addr];
    end
endmodule

















module single_port_ram_row(
    input [6:0] data,
    input [4:0] addr,
    input we, clk,
    output reg [6:0] data_out
);
    // RAM storage
    reg [6:0] mem[31:0];// 17 points

	 initial
	begin
		$readmemb("ram_row_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        data_out <= mem[addr];// here we did not specific write or read first , by default it will be read first
    end
endmodule


module single_port_ram_column(
    input [3:0] data,//0-15
    input [5:0] addr,//0-63
    input we, clk,
    output reg [3:0] data_out
);
    // RAM storage
    reg [3:0] mem[63:0];// 64 points max

	 initial
	begin
		$readmemb("ram_column_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        data_out <= mem[addr];
    end
endmodule

module single_port_ram_S (
    input [7:0] data,
    input [5:0] addr,//0-63
    input we, clk,
    output reg [7:0] data_out
);
    // RAM storage
    reg [7:0] mem[63:0];

	 initial
	begin
		$readmemb("ram_S_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        data_out <= mem[addr];
    end
endmodule


module single_port_ram_vector(
    input [7:0] data,
    input [3:0] addr,//0-15
    input we, clk,
    output reg [7:0] data_out
);
    // RAM storage
    reg [7:0] mem[15:0];

	 initial
	begin
		$readmemb("ram_v_init.txt", mem);
	end
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        data_out <= mem[addr];
    end
endmodule



module single_port_ram_d(
    input [18:0] data,
    input [5:0] addr,//0-63
    input we, clk,
    output reg [18:0] data_out
);
    // RAM storage
    reg [18:0] mem[15:0];

	 
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        data_out <= mem[addr];
    end
endmodule




