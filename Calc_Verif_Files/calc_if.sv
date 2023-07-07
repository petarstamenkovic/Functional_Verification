`ifndef CALC_IF_SV
 `define CALC_IF_SV

//interface calc_if (input clk, logic [6 : 0] rst);

//   parameter DATA_WIDTH = 32;
//   parameter RESP_WIDTH = 2;
//   parameter CMD_WIDTH = 4;

//   logic [DATA_WIDTH - 1 : 0]  out_data1;
//   logic [DATA_WIDTH - 1 : 0]  out_data2;
//   logic [DATA_WIDTH - 1 : 0]  out_data3;
//   logic [DATA_WIDTH - 1 : 0]  out_data4;
//   logic [RESP_WIDTH - 1 : 0]  out_resp1;
//   logic [RESP_WIDTH - 1 : 0]  out_resp2;
//   logic [RESP_WIDTH - 1 : 0]  out_resp3;
//   logic [RESP_WIDTH - 1 : 0]  out_resp4;
//   logic [CMD_WIDTH - 1 : 0]   req1_cmd_in;
//   logic [DATA_WIDTH - 1 : 0]  req1_data_in;
//   logic [CMD_WIDTH - 1 : 0]   req2_cmd_in;
//   logic [DATA_WIDTH - 1 : 0]  req2_data_in;
//   logic [CMD_WIDTH - 1 : 0]   req3_cmd_in;
//   logic [DATA_WIDTH - 1 : 0]  req3_data_in;
//   logic [CMD_WIDTH - 1 : 0]   req4_cmd_in;
//   logic [DATA_WIDTH - 1 : 0]  req4_data_in;

//endinterface : calc_if

interface calc_if (input clk, logic [6 : 0] rst);

   parameter DATA_WIDTH = 32;
   parameter RESP_WIDTH = 2;
   parameter CMD_WIDTH = 4;

   logic [DATA_WIDTH - 1 : 0]  out_data;
   logic [RESP_WIDTH - 1 : 0]  out_resp;
   logic [CMD_WIDTH - 1 : 0]   req_cmd_in;
   logic [DATA_WIDTH - 1 : 0]  req_data_in;
 

endinterface : calc_if

`endif
