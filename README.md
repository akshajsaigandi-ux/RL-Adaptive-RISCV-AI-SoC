# RL-Adaptive RISC-V AI SoC

**Reinforcement Learning-Based Adaptive RISC-V AI System-on-Chip**

A SystemVerilog-based FPGA implementation of an adaptive RISC-V AI SoC that combines an RV32I processor with a reinforcement learning controller to dynamically optimize accelerator behavior based on workload characteristics.

## Features

* RV32I RISC-V Core
* Reinforcement Learning Controller
* Q-Learning Adaptation Logic
* Adaptive AI Accelerator
* Processing Element (PE) Array
* Performance Monitoring Unit
* SystemVerilog Testbenches
* Xilinx Vivado FPGA Flow

## Architecture

> *(Architecture block diagram will be added here.)*

## Project Structure

```text
RL-Adaptive-RISCV-AI-SoC/
├── RL_Adaptive_RISCV_AI_SoC.srcs/
│   ├── sources_1/
│   ├── sim_1/
│   └── constrs_1/
├── RL_Adaptive_RISCV_AI_SoC.xpr
├── README.md
├── LICENSE
└── .gitignore
```

## Key Modules

| Module                         | Function              |
| ------------------------------ | --------------------- |
| `ras_riscv_core.sv`            | RV32I processor       |
| `ras_rl_controller.sv`         | RL decision logic     |
| `ras_q_learning_controller.sv` | Q-learning controller |
| `ras_adaptive_accelerator.sv`  | AI accelerator        |
| `ras_pe_array_controller.sv`   | PE array management   |
| `ras_performance_monitor.sv`   | Runtime monitoring    |

## Verification

The project includes extensive SystemVerilog testbenches covering:

* ALU
* Register File
* Instruction Decoder
* Instruction Memory
* Program Counter
* Processing Element
* PE Array
* RL Controller
* Q-Learning Controller
* Integrated System Tests

## FPGA Implementation

* **Language:** SystemVerilog
* **Tool:** Xilinx Vivado
* **Target:** FPGA implementation and behavioral simulation

## Future Improvements

* Hardware deployment on Artix-7 FPGA
* Advanced RL policies
* Multi-core scalability
* Power-aware adaptive scheduling

## Author

**Akshaj Gandi**

* Electronics and Communication Engineering
* SRM Institute of Science and Technology
* GitHub: `akshajsaigandi-ux`
