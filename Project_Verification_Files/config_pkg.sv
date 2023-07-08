`ifndef CONFIGURATION_PKG_SV
    `define CONFIGURATION_PKG_SV

    package configuration_pkg;

        *import uvm_pkg::*;        // Import everything from UVM library
        `include "uvm_macros.svh"  // Include the UVM Macros
        `include "hough_config.sv" // Include my config

    endpackage :: configuration_pkg

`endif CONFIGURATION_PKG_SV    