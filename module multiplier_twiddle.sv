module multiplier_twiddle #(
    parameter datalength = 8
) (
    input logic EN,clk,
    input logic signed [datalength-1:0] c,
    input logic signed [datalength-1:0] d,
    input logic cycle_finish,
    output logic signed [datalength-1:0] z,
    output logic ready_product
);

logic [2*datalength-1:0] product; // the product of a*b with carry and overflow
enum {cal_start,cal,cal_finish} state;


always_ff @(posedge clk) begin
        case(state)
            cal_start:  begin if (EN)  state <= cal; end
            cal      :  begin state <= cal_finish; end 
            cal_finish: begin if (cycle_finish) 
                                begin 
                                ready_product <= 0; 
                                state <= cal_start; 
                                end 
                              else ready_product <= 1;
                        end
endcase

end
always_comb begin //enable the multiplier
    product = '0;
    z = '0;
        case (state)
            cal_start:  ;
            cal:        begin product = c * d; end
            cal_finish: begin product = c * d; z = product[14:7]; end
		default:        begin product = 0;     z = 0; end
         endcase
 
    end
endmodule