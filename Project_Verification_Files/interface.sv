`ifndef INTERFACE_SV
    `define INTERFACE_SV

interface hough_if(input clk,input rst);
    
    logic [9 : 0] width_i;
    logic [9 : 0] height_i;
    logic [7 : 0] threshold;
    logic [9 : 0] rho_i;
    logic         start; 
    logic         ready; 
    logic         reset;

endinterface

interface bram_if(input clk);

    logic [16 : 0] addr_i; // Add a correct number of bits for an bram address, what is its size?
    logic [7  : 0] data_i; // Her to input pre-generated pixel values (golden vectors)
    logic          we_b;   // Enable signal for Bram

     
endinterface

`endif
