`timescale 1ns / 1ps

interface fifo_if(input logic clk,rst);
             logic wr_en;
             logic rd_en;
             logic full;
             logic empty;
             logic [127:0] wr_data;
             logic [127:0] rd_data;

         clocking fifo_driver_cb@(posedge clk);
            default input #1 output #1;
                output wr_en;
                output rd_en;
  	            input   full;
                input  empty;
                output wr_data;
                input  rd_data;
        endclocking

     clocking fifo_monitor_cb@(posedge clk);
          default input #1 output #1;
          input  wr_en;
          input rd_en;
          input  full;
          input  empty;
          input  wr_data;
          input  rd_data;
     endclocking

     modport DRIVER (clocking fifo_driver_cb,input clk);
     modport MONITOR (clocking fifo_monitor_cb,input clk);

  endinterface
