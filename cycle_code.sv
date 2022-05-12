// ----------------------------------
// definition of calclation 
// 8 cycle
//------------------------------------
//r0
`define Rew 4'b0001
`define Imw 4'b0010
`define Reb 4'b0011 
`define Imb 4'b0100 
`define Rea 4'b0101 
`define Ima 4'b0110
//r_mul
`define RewReb 4'b0001 
`define ImwImb 4'b0010
`define RewImb 4'b0011 
`define ImwReb 4'b0100
//r_add
`define RR_II 4'b0001  // RewReb - ImwImb
`define RI_IR 4'b0010  // RewImb + ImwReb
`define Rey 4'b0011 //Rea + RewReb - ImwImb
`define Imy 4'b0100 // Ima + RewImb + ImwReb
`define Rez 4'b0101 //Rea - (RewReb - ImwImb)
`define Imz 4'b0110 // Ima - (RewImb + ImwReb)