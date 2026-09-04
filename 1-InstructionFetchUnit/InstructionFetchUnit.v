`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Kamil, Ian, Macabe
// Equal effort. 33% for each one, we all contributed to different parts of the project, we divided the file creation and combined everything together.
// 
// ECE369A - Computer Architecture
// Laboratory 3 (PostLab)
// Module - InstructionFetchUnit.v
// Description - Fetches the instruction from the instruction memory based on 
//               the program counter (PC) value.
// INPUTS:-
// Reset: 1-Bit input signal. 
// Clk: Input clock signal.
//
// OUTPUTS:-
// Instruction: 32-Bit output instruction from the instruction memory. 
//              Decimal value diplayed 
// PCResult: 32-Bit output PCResult from the program counter. 
//              Decimal value diplayed 
// FUNCTIONALITY:-
// Please connect up the following implemented modules to create this
// 'InstructionFetchUnit':-
//   (a) ProgramCounter.v
//   (b) PCAdder.v
//   (c) InstructionMemory.v
// Connect the modules together in a testbench so that the instruction memory
// outputs the contents of the next instruction indicated by the memory location
// in the PC at every clock cycle. Please initialize the instruction memory with
// some preliminary values for debugging purposes.
//
// @@ The 'Reset' input control signal is connected to the program counter (PC) 
// register which initializes the unit to output the first instruction in 
// instruction memory.
// @@ The 'Instruction' output port holds the output value from the instruction
// memory module.
// @@ The 'Clk' input signal is connected to the program counter (PC) register 
// which generates a continuous clock pulse into the module.
////////////////////////////////////////////////////////////////////////////////

module InstructionFetchUnit(Instruction, PCResult, Reset, Clk);

//We are connecting everything together following the diagram
    wire [31:0] PCAddResult; //We declare wires because it is a physical connection that is going from module to module, PCAddResult goes to Program Counter
    output wire [31:0] Instruction; //Instruction is an output that is why it is also a wire since it leaves Instruction memory
    output wire [31:0] PCResult; //PCResult is also a wire since it goes from program counter to pcadder and instruction memory
    input Reset;
    input Clk;
    
    PCAdder a1(PCResult,PCAddResult); //PC Result connects to Instruction Memory and PCAdder to produce PCAddResult and Instruction
    ProgramCounter a2(PCAddResult, PCResult, Reset, Clk);
    InstructionMemory a3(PCResult, Instruction);
     //Everything is connected and the outputs will connect to 2 other modules in a top module.
    
endmodule

