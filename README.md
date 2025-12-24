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
Opcode[31:26] | Rd[25:22] | Rs[21:18] | Rt[17:14] | Imm[13:0]


- Immediate field is:
  - **Sign-extended** for arithmetic, memory, and control instructions  
  - **Zero-extended** for logical instructions  
- Branch and jump immediates are PC-relative  

---

##  Pipeline Hazard Handling

### Data Hazards
- Forwarding from **EX/MEM** and **MEM/WB** pipeline stages  
- Load-use hazard detection with pipeline stalling  

### Control Hazards
- Branch decision handled early in the Decode stage  
- Pipeline flushing using kill signals  
- One-cycle branch penalty  

### Structural Hazards
- Avoided using separate instruction and data memories  

### Exception Handling
- Detection of invalid **LDW/SDW** instructions (odd register index)  
- Faulty instructions are safely flushed without affecting program flow  

---

##  Testing and Verification
- Functional verification performed using **Verilog testbenches**
- Multiple assembly test programs executed successfully
- Verification covers:
  - Arithmetic and logical operations
  - Memory access (LW, SW, LDW, SDW)
  - Control flow (branches, jumps, calls)
- Simulation waveforms and register dumps confirm correct pipeline behavior

---
