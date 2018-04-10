*******************************************************************************
** © Copyright 2010 Xilinx, Inc. All rights reserved.
** This file contains confidential and proprietary information of Xilinx, Inc. and 
** is protected under U.S. and international copyright and other intellectual property laws.
*******************************************************************************
**   ____  ____ 
**  /   /\/   / 
** /___/  \  /   Vendor: Xilinx 
** \   \   \/    
**  \   \        readme.txt Version: 1.0  
**  /   /        Date Last Modified:  
** /___/   /\    Date Created: 07 APR 2010
** \   \  /  \   Associated Filename: xapp882.zip
**  \___\/\___\ 
** 
**  Device: Virtex-6
**  Purpose:
**    Readme file for contents of XAPP882.ZIP. These files are associated with 
**    the SERDES Framer Interface Level 5 (SFI-5) reference design outlined in XAPP882.
**      1. Implementation details:
**        a. Synthesis/Place & Route software used to develop 
**           reference design. Specific software settings also mentioned here
**           if appropriate.
**        b. Platform used for hardware verification testing
**      2. Source code file descriptions
**      3. General notes 
**  Reference: 
**      XAPP882.pdf 
**  Revision History: 
**      Rev 1.0 - First created, Vasud, 04/07/2010
**         
*******************************************************************************
**
**  Disclaimer: 
**
**		This disclaimer is not a license and does not grant any rights to the materials 
**              distributed herewith. Except as otherwise provided in a valid license issued to you 
**              by Xilinx, and to the maximum extent permitted by applicable law: 
**              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
**              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
**              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
**              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
**              or tort, including negligence, or under any other theory of liability) for any loss or damage 
**              of any kind or nature related to, arising under or in connection with these materials, 
**              including for any direct, or any indirect, special, incidental, or consequential loss 
**              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
**              as a result of any action brought by a third party) even if such damage or loss was 
**              reasonably foreseeable or Xilinx had been advised of the possibility of the same.


**  Critical Applications:
**
**		Xilinx products are not designed or intended to be fail-safe, or for use in any application 
**		requiring fail-safe performance, such as life-support or safety devices or systems, 
**		Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
**		or any other applications that could lead to death, personal injury, or severe property or 
**		environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
**		the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
**		to applicable laws and regulations governing limitations on product liability.

**  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.

*******************************************************************************

*******************************************************************************
** Implementation Details
*******************************************************************************

HDL Language(s)                - Verilog
Synthesis                      - XST, ISE 12.1 (M.52.0)
Place/Route:                   - ISE 12.1 (M.52.0)
Hardware Verification:
  Platform                     - ML623 Board
  Target Part                  - XC6VLX240T-FF1156-1
  
*******************************************************************************
** File Descriptions and Design Hierarchy
*******************************************************************************

The xapp882.zip archive includes the following subdirectories. The specific 
contents of each subdirectory below:
  \Design   - Contains the Interface design files in verilog
  \Hardware_Testbench   - Hardware testbench files to test the Interface design
  \Chipscope - Chip Scope modules to monitor and drive the signals of Hardware Testbench
  \Bitfile - Bit file being generated and tested on ML623 Board
  \Implementation - ISE implementation scripts to generate the bit file
  \Simulation - files required for running a simulation

*******************************************************************************
** Running Implementation/Simulation
*******************************************************************************
To run the implementation:
  Type "./run_syn" in the terminal under \Implemenation folder.

To run the simulatiom
  Type "vsim -do run_sim.do" in the terminal under \Simulation\sim folder. 
