# Tiny GPU — Massively Parallel Compute Core in Verilog

> A minimal but functional GPU architecture implemented in synthesizable Verilog HDL.  
> 4 shader cores | 8 threads | 16-bit RISC ISA | Open-source EDA tools

---

##  Project Overview

This project implements a simplified but architecturally accurate GPU in Verilog HDL,
demonstrating key concepts from real-world GPU design:

- **4 parallel shader cores** running simultaneously
- **SIMD execution** — all cores execute the same instruction on different data
- **Thread dispatch** — 8 threads scheduled across 4 cores in 2 batches
- **Shared memory** — 256×16-bit memory with round-robin arbitration
- **Custom 16-bit ISA** — supports ADD, SUB, MUL, AND, OR operations

---

##  Architecture

```
         ┌─────────────────────────────────────┐
         │              gpu_top                │
         │                                     │
         │         ┌──────────────┐            │
         │         │dispatch_unit │            │
         │         └──────┬───────┘            │
         │    ┌───────────┼───────────┐        │
         │  core0       core1       core2    core3
         │  (ALU +      (ALU +      (ALU +   (ALU +
         │  RegFile +   RegFile +   RegFile+ RegFile+
         │  PC + FSM)   PC + FSM)   PC+FSM)  PC+FSM)
         │    └───────────┼───────────┘        │
         │         ┌──────┴───────┐            │
         │         │   mem_ctrl   │            │
         │         │ 256×16-bit   │            │
         │         │ round-robin  │            │
         │         └──────────────┘            │
         └─────────────────────────────────────┘
```

---

##  File Structure

```
tiny-gpu-verilog/
│
├── alu.v               # Arithmetic Logic Unit (ADD/SUB/MUL/AND/OR)
├── reg_file.v          # 8×16-bit register file per core
├── prog_counter.v      # 8-bit program counter with jump support
├── shader_core.v       # 4-stage FSM shader core (FETCH→DECODE→EXECUTE→WRITEBACK)
├── mem_ctrl.v          # Shared memory controller with round-robin arbitration
├── dispatch_unit.v     # Thread scheduler (8 threads, 4 cores)
├── gpu_top.v           # Top-level integration module
│
├── tb_alu.v            # ALU testbench
├── tb_reg_pc.v         # Register file + PC testbench
├── tb_shader_core.v    # Shader core testbench
├── tb_mem_ctrl.v       # Memory controller testbench
├── tb_dispatch.v       # Dispatch unit testbench
├── tb_gpu_top.v        # GPU top testbench
├── tb_gpu.v            # Full GPU testbench (3 kernels)
│
├── gpu.vcd             # VCD waveform dump
├── yosys_report.txt    # Yosys synthesis report
├── screenshots/        # Waveform screenshots
└── report/             # Project report PDF
```

---

##  Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| Icarus Verilog | 12.0 | RTL Simulation |
| Yosys | 0.52 | Logic Synthesis |
| GTKWave / vc.drom.io | 3.3.126 | Waveform Viewing |
| WSL2 + Ubuntu | 24 | Linux environment on Windows |
| VS Code | Latest | Code Editor |

All tools are **100% free and open-source**.

---

## 🚀 How to Run

### Prerequisites
```bash
sudo apt install iverilog gtkwave yosys
```

### Clone the repository
```bash
git clone https://github.com/yourusername/tiny-gpu-verilog.git
cd tiny-gpu-verilog
```

### Run full GPU simulation
```bash
iverilog -g2005-sv -o gpu_full tb_gpu.v gpu_top.v dispatch_unit.v shader_core.v mem_ctrl.v alu.v reg_file.v prog_counter.v && vvp gpu_full
```

### View waveforms
```bash
gtkwave gpu.vcd
```

### Run Yosys synthesis
```bash
yosys -p "read_verilog gpu_top.v alu.v reg_file.v prog_counter.v shader_core.v mem_ctrl.v dispatch_unit.v; synth -top gpu_top; stat"
```

---

##  Simulation Results

```
=== TINY GPU VECTOR ADD TEST ===
Running 8 threads across 4 cores...
  Threads 0-3: Batch 1 executed on cores 0,1,2,3
  Threads 4-7: Batch 2 executed on cores 0,1,2,3

All done: 1
=====================================
  SUCCESS: Tiny GPU completed!
  8 threads executed in parallel
  across 4 shader cores
=====================================
SUB kernel all_done: 1 (expected 1)
OR  kernel all_done: 1 (expected 1)
=== ALL TESTS COMPLETE ===
```

---

##  Synthesis Report (Yosys)

| Metric | Value |
|--------|-------|
| Total Cells | 141 |
| Flip-flops (DFF) | 43 |
| Logic Gates | 98 |
| Total Wires | 148 |
| Synthesis Problems | 0 |
| Synthesis Time | 8.6 seconds |
| Peak Memory | 85.32 MB |

---

## 📖 Instruction Set Architecture

| Opcode | Mnemonic | Operation |
|--------|----------|-----------|
| 0000 | ADD | rd = rs1 + rs2 |
| 0001 | SUB | rd = rs1 - rs2 |
| 0010 | MUL | rd = rs1 × rs2 |
| 0011 | AND | rd = rs1 & rs2 |
| 0100 | OR  | rd = rs1 \| rs2 |

**Instruction format (16-bit):**
```
[15:12] opcode | [11:9] rd | [8:6] rs1 | [5:3] rs2 | [2:0] unused
```

---

##  Author

**Samarth A Khadakabhavi**  
Branch: Electronics & Telecommunication Engineering  
College: College of Engineering Pune (COEP)  

---

##  References

- [Tiny GPU Reference](https://github.com/adam-maj/tiny-gpu) — Adam Maj
- [Icarus Verilog](https://iverilog.icarus.com)
- [Yosys Synthesis Suite](https://yosyshq.net)
- IEEE 1364-2005 Verilog Standard
