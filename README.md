# Design-and-Verification-of-a-Pipelined-RISC-Processor
# Pipelined RISC Processor Implementation

![Processor Architecture Diagram](https://via.placeholder.com/800x400?text=Pipelined+RISC+Processor+Architecture)

This repository contains a complete implementation of a 5-stage pipelined RISC processor in Verilog, developed for the ENCS4370 Computer Architecture course at Birzeit University. The processor features a custom 32-bit RISC ISA with support for arithmetic, logical, memory, and control flow instructions.

## Key Features

- **5-Stage Pipeline Architecture**:
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execution (EX)
  - Memory Access (MEM)
  - Write Back (WB)
  
- **Advanced Hazard Handling**:
  - Data forwarding for RAW hazards
  - Pipeline stalling for load-use hazards
  - Branch prediction with 1-cycle penalty
  - Exception handling for invalid operations

- **Comprehensive Instruction Support**:
  | Arithmetic | Logical | Memory | Control Flow |
  |------------|---------|--------|--------------|
  | ADD        | OR      | LW     | BZ           |
  | SUB        | ORI     | SW     | BGZ          |
  | ADDI       |         | LDW    | BLZ          |
  |            |         | SDW    | JR           |
  |            |         |        | J            |
  |            |         |        | CALL         |

## Repository Structure
