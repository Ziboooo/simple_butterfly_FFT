`include "cycle_code.sv"

module controller (
    input logic clk, ReadyIn2,rst,
    // control signal 
    input logic Ready_dis,
    input logic reg_finish, // flag when finish register
    input logic reg_add_finish,
    output logic [3 : 0] addra, // register address
    output logic reg_WEN,       // register control 
    //output logic [3:0] cycle,
    // FFT keeps calculating but no storing 
    //control display register
    output logic [3:0] addr_led,
    output logic cal_flag
);
    // each next_state control signals
    enum {Re_w,Im_w, Re_b,Im_b,Re_a,Im_a,Re_y,Im_y,Re_z,Im_z} present_state, next_state; 
    // get one register for storing last ready_in
    logic last_ReadyIn;
    logic ReadyIn1,ReadyIn;

    //---------------------- codes start from here ------------------------------------

    always_ff @(posedge clk, negedge rst ) begin 
    if (~rst)// assert master reset: rst = 0,
    begin 
 // default cycle to 3'b0000, calculating Rew*Reb
        ReadyIn1 <= 1;
        ReadyIn <= 1;
        last_ReadyIn <= 1;  // last readyin default as 1
        present_state <= Re_w;
    end
    else  
	begin 
        present_state <= next_state;
        ReadyIn1 <= ReadyIn2; 
        ReadyIn <= ReadyIn1; // register for asynchronous input
        last_ReadyIn <= ReadyIn;

        end
     end // always_ff

//////////////////////////////////////////////
always_comb 
 // deassert master reset: rst = 1, 
                
    begin   
            next_state = present_state;
	        reg_WEN = 0;
            //addra = '0;
            addr_led = `Imz;
			cal_flag = 0;

        unique casez (present_state)  

        Re_w: begin //when readyIn is 1, to store Re_w
		        addra = `Rew;
              if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //store for ReadyIn == 1 last_ReadyIn=0
                reg_WEN = 1; 
                
                next_state = Im_w;
            end
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;
                
                next_state = Re_w;
            end

        end

        Im_w: begin 
		  addra = `Imw;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //store for ReadyIn == 1 last_ReadyIn=0
                reg_WEN = 1; 
            
                next_state = Re_b;
            end
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;
                 
                next_state = Im_w;
            end
      
            end
// repeated from here
////////////////////////////////////////////////////////
//////////////////////////////////////////////////////
         Re_b: begin 
            addra = `Reb;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                reg_WEN = 1;               
                //waiting for ReadyIn == 1 
                next_state = Im_b;
            end
        
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;
                next_state = Re_b;
            end
       
            end

        Im_b: begin 
		  addra = `Imb;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1 
                reg_WEN = 1;
                next_state = Re_a;
            end
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;
                next_state = Im_b;
            end
         
            end

        Re_a: begin 
		addra = `Rea;

            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1 
                reg_WEN = 1;
                
                next_state = Im_a;
            end
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;
                next_state = Re_a;
            end
            
            end

        Im_a: begin 
		  
             addra = `Ima;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1 
                reg_WEN = 1;
                next_state = Re_y;
            end
            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input 
                reg_WEN = 0;  
                next_state = Im_a;
            end
          
            end
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
        Re_y: begin 
            reg_WEN = 0;
            addr_led = `Rey ;        // stop writing 
            addra = 0;
            if (Ready_dis == 0) 
                begin 
                    cal_flag = 1;//cycle = cycle + (reg_finish&reg_add_finish); // incrment cycle from 3'b001 when finish_register
                    next_state = Re_y;
                  
                end
            else begin //if (Ready_dis == 1) begin 
                cal_flag = 0;
                  // read Rey to led 
                next_state = Im_y;
               //cycle = 0;
            end
        end

        Im_y: begin 
            addra = 0;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1 
                addr_led = `Imy;
                next_state = Re_z;
            end

            else begin //if(ReadyIn == 1 && last_ReadyIn == 0 )
           
            
                addr_led = `Rey;
                next_state = Im_y;
            
            end
             end

        Re_z: begin 
            addra = 0;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1
               addr_led = `Rez; 
                next_state = Im_z;
            end

            else //if(ReadyIn == 1 && last_ReadyIn == 0)
            begin 
                // storing input 
                addr_led = `Imy;  
                next_state = Re_z;
            end
            end

        Im_z: begin 
            addra = 0;
            if  ((ReadyIn == 1) && (last_ReadyIn == 0))
            begin
                //waiting for ReadyIn == 1
                addr_led = `Imz;  
                next_state = Re_b;
            end

            else //if(ReadyIn == 1 && last_ReadyIn == 0 )
            begin 
                // storing input
                 addr_led = `Rez;  
                next_state = Im_z;
            end
            end// imz
		default: begin 
		          reg_WEN = 0;
                          addra = '0;
                          addr_led = '0;
	       	         next_state = Re_w;
		          cal_flag = 0;
			 end
              endcase
      
    end


endmodule