//-------------------------------------------------------------------------
// filename: fft_butterfly calcultion 
// function: finish fft butterfly in 8 cycles
// author: zy1u21
// version:1 // all conbine logic 
// data: 14/4/2022
//-------------------------------------------------------------------------

`include "cycle_code.sv"

module FFT_BUTTERFLY (
    input logic clk,rst,
   // input logic [3:0]cycle, // 8 cycle flag 
    input cal_flag,
 
    // led
    input logic [3:0] addr_led,



    // multiplier control 
    input logic signed [7:0] product, // product output
    input logic reg_MUL, // calculation finished

    // register control 
    input logic reg_en, // enable external input
    input logic [3:0] addr, // address
    input logic signed [7:0] SW, //input 
    output logic reg_finish,reg_add_finish,
    output logic Ready_dis,
    output logic [7:0] led, //led
      // multiplier control 
    output logic MULEN,
    output logic signed [7:0] c,      // product input
    output logic signed [7:0] d,
    
    output logic cycle_finish
 

);

// adder
logic ADDEN;
logic [7:0] a;
logic [7:0] b;
logic signed [7:0] sum; // sum result no consider carry 
logic [7:0] addr_sum; // sum address

// multiplication 
logic [7:0] addr_product; // product address

//register
logic [7:0] r0 [7:0]; // creat one memory 
logic [7:0] r_add [7:0]; //creat register for addition
logic [7:0] r_mul [5:0]; // creat register for multiplication 
logic [1:0] reg_state;
logic [3:0] cycle;
//logic reg_finish1, reg_add_finish1;
//logic increment;
//reg [7:0] rey,imy,rez,imz;


//---------- codes start here --------------------------------------------
// creat output 
/////////////////////////////////////////////////////////////////////////////////////
assign led = r_add[addr_led];

// creat register: loading, calculation,
/////////////////////////////////////////////////////////////////////////////////////// 
always_ff @(posedge clk, negedge rst) begin // store external result
   
    if (~rst) begin reg_finish <= 0; reg_add_finish <= 0; end// default from 1
    else if (reg_en) r0[addr] <= SW; // register for loading
    // register for calculation 
    else if (cycle_finish == 1) begin 
        reg_add_finish <=0; 
        reg_finish <= 0; 
        cycle_finish <= 0; 
        end
    else if ((MULEN|ADDEN)&reg_MUL)  begin
        // store results of addition and multiplication 
	    r_mul[addr_product] <= product;
        r_add[addr_sum] <= sum;
        reg_add_finish <= 1;
        reg_finish <= 1;
        cycle_finish <= 1;
        end
    else if (ADDEN&(~MULEN)) begin	
        // store results of addition 
        r_add[addr_sum] <= sum;
        reg_add_finish <= 1;
        cycle_finish <= 1;
         end
end

// creat fft_butterfly eight cycles
////////////////////////////////////////////////////////////////////////////////////////

always_ff @( posedge clk, negedge rst) begin
    if (~rst) begin 
        cycle <= 0;
 
        end
    else if (cal_flag==1&&cycle == 4'b0000) // start calculation 
           cycle <= 4'b0001;
    else if (cycle == 4'b1000) // start again
           cycle <= 4'b0000;
    else if((cycle_finish)&(cal_flag))begin //increment
 
        cycle <= cycle +1;
    end
end //always_ff


// case 8 cycles 
always_comb begin
        // default
    MULEN = 0;
    ADDEN = 0;
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    addr_product = '0;
    addr_sum = '0;
    sum = '0;
    Ready_dis = 0;
    unique casez(cycle)
    4'b0000: Ready_dis = 0;
    4'b0001: // c1 Reb*Rew 
        begin 
            // multiple 
            c = r0[`Rew]; //Rew 
            d = r0[`Reb]; //Reb 
            MULEN = 1; // multiplication 
            addr_product = `RewReb; // Rew*Reb
        end
    
    4'b0010: // c2 Imb*Imw
        begin 
            // multiple 
            c = r0[`Imw]; //Imw .c
            d = r0[`Imb]; //Imb .d
            MULEN = 1; // multiplication 
            addr_product = `ImwImb; // Imb*Imw
        end

    4'b0011: // c3 Imw*Reb  Reb*Rew - Imb*Imw
        begin 
            // a+b Reb*Rew - Imb*Imw
            ADDEN = 1'b1;
            a = r_mul[`RewReb];
            b = r_mul[`ImwImb];
            sum = a - b;
            addr_sum = `RR_II; // Reb*Rew - Imb*Imw
            // multiple 
            c = r0[`Imw]; //Imw .c
            d = r0[`Reb]; //Reb .d
            MULEN = 1; // multiplication 
            addr_product = `ImwReb; // Imw*Reb
        end

    4'b0100: // c4 Imb*Rew Rea + Reb*Rew - Imb*Imw
        begin 
            // a+b Reb*Rew - Imb*Imw
            a = r0 [`Rea];
            b = r_add [`RR_II];
            sum = a + b;
            ADDEN = 1;
            addr_sum = `Rey; // Reb*Rew - Imb*Imw
            // multiple 
            c = r0[`Imb]; //Imb .c
            d = r0[`Rew]; //Rew .d
            MULEN = 1; // multiplication 
            addr_product = `RewImb; // Imw*Reb
        end
    
    4'b0101: //c5  Rea-(ReBRew-ImbImw)
        begin 
            
            // a+b Rea - (RebRew-ImbImw) 
            a = r0[`Rea];
            b = r_add[`RR_II];
            sum = a - b;
            ADDEN = 1;
            addr_sum = `Rez; // Reb*Rew - Imb*Imw
            // multiple 
        end 


    4'b0110: //c6 RewImb + ImwReb
        begin 

            // a+b RewImb + ImwReb
            a = r_mul[`RewImb];
            b = r_mul[`ImwReb];
            ADDEN = 1;
            sum = a + b;
            addr_sum = `RI_IR; // RewImb + ImwReb
            
        end

    4'b0111: //c7 Ima + (RewImb + ImwReb)
        begin 
            
            // a+b Ima + (RewImb + ImwReb)
            a = r0[`Ima];
            b = r_add[`RI_IR];
            sum = a + b;
            ADDEN = 1;
            addr_sum = `Imy; // Imy
            
        end  

    4'b1000: //c8 Ima - (RewImb + ImwReb)
        begin 
            
            // a+b Ima - (RewImb + ImwReb)
            a = r0[`Ima];
            b = r_add[`RI_IR];
            sum = a - b;
            ADDEN = 1;
            addr_sum = `Imz; // Imy
            // finish calculation 
            Ready_dis = 1;
        end       

    default: begin 
        MULEN = 0;
    ADDEN = 0;
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    addr_product = '0;
    addr_sum = '0;
    sum = '0;
    Ready_dis = 0;
    end
endcase
end// always combine

endmodule
