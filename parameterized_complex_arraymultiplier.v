module half_adder (
    input  a, b,
    output sum, carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule

// Full Adder - Operator Format
module full_adder (
    input  a, b, cin,
    output sum, carry
);
    assign sum   = a ^ b ^ cin;
    assign carry = (a & b) | (cin & (a ^ b));
endmodule


module array_multiplier #(parameter n=16)(
    input signed[n-1:0] a,
    input signed[n-1:0] b,
    output signed[((2*n)-1):0]p
);

wire sign_a;
wire sign_b;
wire sign_p;
assign sign_a = a[n-1];
assign sign_b = b[n-1];
assign sign_p = sign_a ^ sign_b;

wire [n-1:0] a_mag;
wire [n-1:0] b_mag;
assign a_mag = sign_a ? (~a + 1'b1) : a;
assign b_mag = sign_b ? (~b + 1'b1) : b;


wire [(2*n)-1:0] pp[n-1:0];

genvar i,j;
generate
    for(i=0;i<n;i=i+1)
    begin : ROW
        // initialize upper bits to zero
        for(j=0;j<2*n;j=j+1)
        begin : INIT
            assign pp[i][j] =
                (j < n) ?
                (a_mag[j] & b_mag[i]) :
                1'b0;
        end
    end
endgenerate

//shifting all rows
wire [2*n-1:0] shifted_pp[n-1:0];
generate
 for(i=0;i<n;i=i+1) 
 begin:SHIFT
    assign shifted_pp[i] = pp[i] << i;
  end
endgenerate

wire [2*n-1:0] sum [n:0];
assign sum[0] = 0;
generate
for(i=0;i<n;i=i+1)
begin:ADD
assign sum[i+1] = sum[i] + shifted_pp[i];        
end
endgenerate
assign p =
    sign_p ?
    (~sum[n] + 1'b1) :
    sum[n];

endmodule


module complex_multiplier #(parameter n=16)(
    input signed[n-1:0] a_real,
    input signed[n-1:0]a_img,
    input signed[n-1:0] b_real,
    input signed[n-1:0]b_img,
    output signed[(2*n-1):0] real_out,
    output signed[(2*n-1):0] img_out
);
wire signed[(2*n-1):0] m,l,o,p;
array_multiplier #(.n(n)) am1(.a(a_real),.b(b_real),.p(m));
array_multiplier #(.n(n)) am2(.a(a_img),.b(b_img),.p(l));
array_multiplier #(.n(n)) am3(.a(a_real),.b(b_img),.p(o));
array_multiplier #(.n(n)) am4(.a(a_img),.b(b_real),.p(p));

assign real_out=m-l;
assign img_out=o+p;
endmodule


