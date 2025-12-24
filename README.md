# Design and Verification of a Pipelined RISC Processor

A complete implementation of a **32-bit 5-stage pipelined RISC processor** written in **Verilog HDL**, developed as part of the **ENCS4370 – Computer Architecture** course at **Birzeit University**.

---

##  Project Overview
This project presents the design, implementation, and verification of a custom RISC processor following classic RISC principles:
- Fixed 32-bit instruction format
- Load/store architecture
- Separate instruction and data memories
- Fully pipelined execution

The processor was first implemented as a **single-cycle datapath** to verify correctness, then extended into a **5-stage pipelined architecture** with full hazard handling and exception support.

---

##  Processor Architecture

### Pipeline Stages
1. **Instruction Fetch (IF)**  
2. **Instruction Decode (ID)**  
3. **Execution (EX)**  
4. **Memory Access (MEM)**  
5. **Write Back (WB)**  

### Architectural Features
- 32-bit fixed-length instructions  
- 16 general-purpose registers (R0–R15)  
- R15 used as Program Counter (PC)  
- R14 used as Return Address register (CALL)  
- Separate instruction and data memory  
- Word-aligned memory access  

---

##  Instruction Set Architecture (ISA)

### Supported Instructions

| Arithmetic | Logical | Memory | Control Flow |
|----------|---------|--------|--------------|
| ADD      | OR      | LW     | BZ           |
| SUB      | ORI     | SW     | BGZ          |
| ADDI     |         | LDW    | BLZ          |
| CMP      |         | SDW    | JR           |
|          |         |        | J            |
|          |         |        | CLL          |

### Instruction Format (32-bit)
