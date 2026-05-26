`timescale 1ns/1ps

module tb_complex_multiplier;

parameter n = 4;

reg  signed [n-1:0] a_real;
reg  signed [n-1:0] a_img;
reg  signed [n-1:0] b_real;
reg  signed [n-1:0] b_img;

wire signed [(2*n)-1:0] real_out;
wire signed [(2*n)-1:0] img_out;

// Expected results
reg signed [(2*n)-1:0] expected_real;
reg signed [(2*n)-1:0] expected_img;

// DUT
complex_multiplier #(.n(n)) dut (
    .a_real(a_real),
    .a_img(a_img),
    .b_real(b_real),
    .b_img(b_img),
    .real_out(real_out),
    .img_out(img_out)
);

integer i, j, k, l;
integer errors;

// ------------------------------------------------------------
// TASK : CHECK OUTPUT
// ------------------------------------------------------------

task check_output;
begin

    expected_real = (a_real * b_real) - (a_img * b_img);
    expected_img  = (a_real * b_img) + (a_img * b_real);

    #1;

    if ((real_out !== expected_real) || (img_out !== expected_img))
    begin
        $display("------------------------------------------------");
        $display("ERROR DETECTED");
        $display("a = %0d + j%0d", a_real, a_img);
        $display("b = %0d + j%0d", b_real, b_img);

        $display("EXPECTED : REAL = %0d  IMG = %0d",
                  expected_real, expected_img);

        $display("GOT      : REAL = %0d  IMG = %0d",
                  real_out, img_out);

        $display("TIME = %0t", $time);
        $display("------------------------------------------------");

        errors = errors + 1;
    end
    else
    begin
        $display("PASS : (%0d + j%0d) * (%0d + j%0d) = %0d + j%0d",
                  a_real, a_img,
                  b_real, b_img,
                  real_out, img_out);
    end

end
endtask

// ------------------------------------------------------------
// TESTBENCH
// ------------------------------------------------------------

initial
begin

    errors = 0;

    $display("\n==============================================");
    $display(" COMPLEX MULTIPLIER VERIFICATION STARTED ");
    $display("==============================================\n");

    // --------------------------------------------------------
    // TEST 1 : ALL ZEROS
    // --------------------------------------------------------

    a_real = 0;
    a_img  = 0;
    b_real = 0;
    b_img  = 0;
    check_output();

    // --------------------------------------------------------
    // TEST 2 : PURELY REAL
    // --------------------------------------------------------

    a_real = 3;
    a_img  = 0;
    b_real = 2;
    b_img  = 0;
    check_output();

    // --------------------------------------------------------
    // TEST 3 : PURELY IMAGINARY
    // --------------------------------------------------------

    a_real = 0;
    a_img  = 2;
    b_real = 0;
    b_img  = 3;
    check_output();

    // --------------------------------------------------------
    // TEST 4 : MIXED COMPLEX
    // --------------------------------------------------------

    a_real = 2;
    a_img  = 3;
    b_real = 1;
    b_img  = 4;
    check_output();

    // --------------------------------------------------------
    // TEST 5 : NEGATIVE VALUES
    // --------------------------------------------------------

    a_real = -2;
    a_img  = 3;
    b_real = 4;
    b_img  = -1;
    check_output();

    // --------------------------------------------------------
    // TEST 6 : MAX POSITIVE VALUES
    // --------------------------------------------------------

    a_real = 7;
    a_img  = 7;
    b_real = 7;
    b_img  = 7;
    check_output();

    // --------------------------------------------------------
    // TEST 7 : MAX NEGATIVE VALUES
    // --------------------------------------------------------

    a_real = -8;
    a_img  = -8;
    b_real = -8;
    b_img  = -8;
    check_output();

    // --------------------------------------------------------
    // TEST 8 : RANDOMIZED TESTING
    // --------------------------------------------------------

    repeat(50)
    begin

        a_real = $random;
        a_img  = $random;
        b_real = $random;
        b_img  = $random;

        check_output();

    end

    // --------------------------------------------------------
    // TEST 9 : EXHAUSTIVE TESTING
    // --------------------------------------------------------
    // Checks ALL POSSIBLE INPUT COMBINATIONS
    // for n = 4
    // Total = 16^4 = 65536 combinations
    // --------------------------------------------------------

    $display("\n==============================================");
    $display(" STARTING EXHAUSTIVE TESTING ");
    $display("==============================================\n");

    for(i = -(2**(n-1)); i < (2**(n-1)); i = i + 1)
    begin
        for(j = -(2**(n-1)); j < (2**(n-1)); j = j + 1)
        begin
            for(k = -(2**(n-1)); k < (2**(n-1)); k = k + 1)
            begin
                for(l = -(2**(n-1)); l < (2**(n-1)); l = l + 1)
                begin

                    a_real = i;
                    a_img  = j;
                    b_real = k;
                    b_img  = l;

                    check_output();

                end
            end
        end
    end

    // --------------------------------------------------------
    // FINAL RESULT
    // --------------------------------------------------------

    $display("\n==============================================");

    if(errors == 0)
    begin
        $display(" ALL TESTS PASSED SUCCESSFULLY ");
    end
    else
    begin
        $display(" TOTAL ERRORS = %0d", errors);
    end

    $display("==============================================\n");

    $finish;

end

// ------------------------------------------------------------
// VCD DUMP
// ------------------------------------------------------------

initial
begin
    $dumpfile("complex_multiplier.vcd");
    $dumpvars(0, tb_complex_multiplier);
end

endmodule