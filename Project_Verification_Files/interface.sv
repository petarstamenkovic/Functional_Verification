`ifndef INTERFACE_SV
    `define INTERFACE_SV

interface hough_if(input clk,input rst);
    
    logic [8 : 0] width_i;
    logic [8 : 0] height_i;
    logic [7 : 0] threshold;
    logic         start; 
    logic         ready; 

endinterface

interface bram_if(input clk);

    logic [16 : 0] addr_i; // Add a correct number of bits for an bram address, what is its size?
    logic [7  : 0] data_i; // Her to input pre-generated pixel values (golden vectors)
    logic          we_b;   // Enable signal for Bram

     
endinterface

`endif