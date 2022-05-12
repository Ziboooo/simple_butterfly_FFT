// file name: fft_test.sv
//function: testbench for fft  
//author:zy1u21
//vertion:1
//date:15/04/2-22
//----------------------------

`timescale 1ns/1ps

module fft_test;

logic [9:0] SW;
logic [7:0] led;
logic clk;
logic signed [7:0] data; 
logic signed [7:0] data_test;

//-------------------instantiation---------------------------
top tt (.clk(clk), .SW(SW),.led(led));
//--------------------------------------
initial 
    begin 
        clk = 0;
        SW = 10'b0000000000;
        forever #2 begin
            clk=~clk;
        end
    end

initial 
    begin 
        // RESSET
        #2 SW[9] = 1;
        #2 SW[9] = 0;
        #2 SW[9] = 1;
        // load
        #20 SW[8] = 0;
        #20//data = 0.75;   // Rew
           SW[7:0] = 8'b01100000;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 //data = -0.25;     //Imw
           SW[7:0] = 8'b11100000;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 //data = 6;       //Reb
           SW[7:0] = 8'b00000110;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 //data = 20;     //Imb
           SW[7:0] = 8'b00010100;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
       #20 //data = 5;     //Rea
           SW[7:0] = 8'b00000101;

        #60  SW[8] = 1;
 
        #20 SW[8] = 0;
        #20 //data = -8;     //Ima
           SW[7:0] = 8'b11111000;
        #60 SW[8] = 1;


        #100 data = $bitstoshortreal(led); // Rey
             data_test = 5+6*0.75-20*(-0.25);
             

        #60 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imy
            data_test =  -8 +6*(-0.25)+20*0.75;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Rez
            data_test = 5 - 6*0.75+20*(-0.25);
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imz
            data_test = -8 -6*(-0.25)-20*0.75;
        #60 SW[8] = 1;
        
	#20 SW[8] = 0;
        #20 //data = 6;       //Reb
           SW[7:0] = 8'b00000000;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 //data = 20;     //Imb
           SW[7:0] = 8'b00000000;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
       #20 //data = 5;     //Rea
           SW[7:0] = 8'b00000000;

        #60  SW[8] = 1;
 
        #20 SW[8] = 0;
        #20 //data = -8;     //Ima
           SW[7:0] = 8'b00000000;
        #60 SW[8] = 1;


        #100 data = $bitstoshortreal(led); // Rey
             data_test = 5+6*0.75-20*(-0.25);
             

        #60 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imy
            data_test =  -8 +6*(-0.25)+20*0.75;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Rez
            data_test = 5 - 6*0.75+20*(-0.25);
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imz
            data_test = -8 -6*(-0.25)-20*0.75;
        #60 SW[8] = 1;
        
         #20 SW[8] = 0;
        #20 //data = 6;       //Reb
           SW[7:0] = 8'b00000001;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 //data = 20;     //Imb
           SW[7:0] = 8'b00000001;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
       #20 //data = 5;     //Rea
           SW[7:0] = 8'b00000001;

        #60  SW[8] = 1;
 
        #20 SW[8] = 0;
        #20 //data = -8;     //Ima
           SW[7:0] = 8'b00000001;
        #60 SW[8] = 1;


        #100 data = $bitstoshortreal(led); // Rey
             data_test = 5+6*0.75-20*(-0.25);
             

        #60 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imy
            data_test =  -8 +6*(-0.25)+20*0.75;
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Rez
            data_test = 5 - 6*0.75+20*(-0.25);
        #60 SW[8] = 1;


        #20 SW[8] = 0;
        #20 data = $bitstoshortreal(led); //Imz
            data_test = -8 -6*(-0.25)-20*0.75;
        #60 SW[8] = 1;
        
    end
    
endmodule

           


        
