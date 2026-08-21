# RL-Adaptive RISC-V AI SoC

<p align="center">
  <img src="images/rtl_architecture.png" alt="RL-Adaptive RISC-V AI SoC Architecture" width="900"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SystemVerilog-HDL-blue?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Xilinx-Vivado-red?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/RISC--V-RV32I-green?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Reinforcement-Learning-orange?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/FPGA-Implementation-purple?style=for-the-badge"/>
</p>

---

## Overview

**RL-Adaptive RISC-V AI SoC** is a **SystemVerilog-based FPGA implementation** of an adaptive AI-enabled RISC-V System-on-Chip that combines an **RV32I processor**, a **Reinforcement Learning controller**, and an **adaptive accelerator** capable of dynamically optimizing hardware behavior based on workload characteristics.

The project demonstrates how reinforcement learning techniques can be integrated directly into hardware architecture to improve accelerator utilization, execution efficiency, and adaptive decision-making.

---

## Quick Results

| Metric | Result |
|--------|-------:|
| RL Training | **5,000 Episodes** |
| Slice LUT Utilization | **10,632 (≈17%)** |
| Worst Negative Slack | **0.221 ns** |
| Total Negative Slack | **0 ns** |
| Worst Hold Slack | **0.106 ns** |
| Adaptive PE Modes | **2, 4, and 8 PE** |

---

## Key Features

- RV32I RISC-V Processor Core
- Reinforcement Learning Controller
- Q-Learning Adaptation Logic
- Adaptive AI Accelerator
- Processing Element (PE) Array
- Performance Monitoring Unit
- Modular SystemVerilog Design
- Comprehensive Verification Testbenches
- FPGA Implementation using Xilinx Vivado

---

# System Architecture

The SoC integrates a traditional RV32I processor with an RL-based adaptive hardware subsystem.

<p align="center">
  <img src="images/rtl_architecture.png" alt="RTL Architecture" width="900"/>
</p>

## Major Components

| Component | Purpose |
|-----------|---------|
| RV32I Core | Instruction execution |
| RL Controller | Adaptive decision making |
| Q-Learning Engine | Policy updates |
| Adaptive Accelerator | AI workload acceleration |
| PE Array | Parallel computation |
| Performance Monitor | Runtime statistics |

---

# Project Structure

```text
RL-Adaptive-RISCV-AI-SoC/
├── images/
│   ├── rtl_architecture.png
│   ├── simulation_waveform.png
│   ├── resource_utilization.png
│   ├── timing_summary.png
│   ├── rl_training_reward.png
│   ├── processor_cycle_count.png
│   ├── pe_utilization_training.png
│   ├── rl_pe_selection.png
│   ├── avg_cycle_comparison.png
│   ├── max_cycle_comparison.png
│   └── pe_selection_distribution.png
│
├── RL_Adaptive_RISCV_AI_SoC.srcs/
│   ├── sources_1/
│   ├── sim_1/
│   └── constrs_1/
│
├── Python/
├── Results/
├── README.md
├── LICENSE
└── .gitignore
```

---

# RTL Modules

| Module | Function |
|--------|----------|
| `ras_riscv_core.sv` | RV32I Processor |
| `ras_control_unit.sv` | Instruction control |
| `ras_instruction_decoder.sv` | Instruction decoding |
| `ras_register_file.sv` | Register storage |
| `ras_alu.sv` | Arithmetic Logic Unit |
| `ras_program_counter.sv` | Program sequencing |
| `ras_q_learning_controller.sv` | Q-learning controller |
| `ras_rl_controller.sv` | Reinforcement learning logic |
| `ras_adaptive_accelerator.sv` | Adaptive AI accelerator |
| `ras_pe_array_controller.sv` | Processing element management |
| `ras_performance_monitor.sv` | Performance monitoring |

---

# Verification

The project includes extensive SystemVerilog verification for both individual modules and integrated system behavior.

## Verified Modules

- ALU
- Register File
- Instruction Decoder
- Instruction Memory
- Program Counter
- Processing Element
- PE Array
- RL Controller
- Q-Learning Controller
- Adaptive Accelerator
- Integrated Stress Testing

---

# Simulation Results

Behavioral simulation was performed in **Xilinx Vivado** to verify processor execution, accelerator activation, and reinforcement learning adaptation.

<p align="center">
  <img src="images/simulation_waveform.png" alt="Simulation Waveform" width="900"/>
</p>

### Simulation verifies

- Processor execution flow
- Accelerator activation
- RL-based adaptation
- Memory interaction
- Control signal correctness

---

# FPGA Implementation Results

The complete design was synthesized and implemented in **Xilinx Vivado**.

## Resource Utilization

| Resource | Utilization |
|----------|------------:|
| Slice LUTs | 10,632 |
| Slice Registers | 9,945 |
| F7 Muxes | 1,184 |
| F8 Muxes | 544 |
| Bonded IOB | 6 |
| BUFGCTRL | 1 |

<p align="center">
  <img src="images/resource_utilization.png" alt="Resource Utilization" width="900"/>
</p>

The implementation utilizes approximately **17%** of available Slice LUT resources while maintaining an efficient register and routing footprint.

---

## Timing Performance

All specified timing constraints were successfully met.

| Metric | Result |
|--------|-------:|
| Worst Negative Slack (WNS) | **0.221 ns** |
| Total Negative Slack (TNS) | **0 ns** |
| Worst Hold Slack (WHS) | **0.106 ns** |
| Hold Violations | **0** |
| Failing Endpoints | **0** |

<p align="center">
  <img src="images/timing_summary.png" alt="Timing Summary" width="900"/>
</p>

This indicates successful FPGA implementation without timing violations.

---

# Reinforcement Learning Performance

The reinforcement learning subsystem was evaluated using **5,000 training episodes** to observe convergence behavior, dynamic Processing Element allocation, and processor adaptation.

---

## Training Reward

The moving-average reward demonstrates stable convergence throughout long-duration Q-learning training.

<p align="center">
  <img src="images/rl_training_reward.png" alt="Training Reward" width="900"/>
</p>

### Observations

- Stable reward convergence
- Reduced reward variance
- Improved policy consistency
- Long-duration training over **5,000 episodes**

---

## Processor Cycle Count

The processor dynamically adapts execution behavior throughout training.

<p align="center">
  <img src="images/processor_cycle_count.png" alt="Processor Cycle Count" width="900"/>
</p>

The decreasing cycle-count variability indicates increasingly efficient workload scheduling as the RL controller learns improved policies.

---

## Processing Element Utilization

The RL controller continuously adjusts Processing Element (PE) utilization based on workload demands.

<p align="center">
  <img src="images/pe_utilization_training.png" alt="PE Utilization During Training" width="900"/>
</p>

### Key Insights

- Utilization ranges approximately between **560–1000 active units**
- High sustained accelerator engagement
- Dynamic hardware resource allocation
- Efficient adaptive scheduling

---

## Dynamic PE Selection

The RL controller dynamically selects between **2 PE, 4 PE, and 8 PE** configurations depending on workload characteristics.

<p align="center">
  <img src="images/rl_pe_selection.png" alt="RL PE Selection During Training" width="900"/>
</p>

This demonstrates workload-aware hardware adaptation instead of fixed accelerator allocation.

---

## Average Cycle Count Comparison

The adaptive RL policy was compared against fixed Processing Element configurations.

<p align="center">
  <img src="images/avg_cycle_comparison.png" alt="Average Cycle Count Comparison" width="900"/>
</p>

| Configuration | Average Cycle Count |
|--------------|--------------------:|
| Fixed 2 PE | **12.3** |
| Fixed 4 PE | **6.4** |
| Fixed 8 PE | **3.5** |
| RL Adaptive | **4.7** |

The RL controller substantially reduces execution latency compared with smaller fixed configurations while dynamically balancing hardware resources.

---

## Maximum Cycle Count Comparison

<p align="center">
  <img src="images/max_cycle_comparison.png" alt="Maximum Cycle Count Comparison" width="900"/>
</p>

| Configuration | Maximum Cycle Count |
|--------------|--------------------:|
| Fixed 2 PE | **20** |
| Fixed 4 PE | **10** |
| Fixed 8 PE | **5** |
| RL Adaptive | **7** |

The adaptive controller maintains lower worst-case execution behavior than smaller fixed PE configurations.

---

## PE Selection Distribution

The learned policy frequently switches between different PE configurations depending on workload requirements.

<p align="center">
  <img src="images/pe_selection_distribution.png" alt="PE Selection Distribution" width="700"/>
</p>

| Selected PE | Number of Test Workloads |
|------------|--------------------------:|
| 2 PE | **4** |
| 4 PE | **8** |
| 8 PE | **8** |

The learned policy favors larger PE configurations for higher-performance workloads while still selecting smaller configurations when appropriate, demonstrating adaptive hardware resource management.

---

# Technology Stack

| Category | Technology |
|----------|------------|
| HDL | SystemVerilog |
| Architecture | RV32I RISC-V |
| FPGA Tool | Xilinx Vivado |
| Verification | SystemVerilog Testbenches |
| AI Technique | Q-Learning |
| Hardware Target | FPGA |

---

# Future Improvements

- Artix-7 hardware deployment
- Multi-core adaptive architecture
- Advanced RL policies
- Dynamic voltage and frequency scaling
- Power-aware scheduling
- Larger Processing Element arrays

---

# Author

**Akshaj Gandi**

Electronics and Communication Engineering

SRM Institute of Science and Technology, Tiruchirappalli

GitHub: **akshajsaigandi-ux**

---

# Repository Highlights

- Modular SystemVerilog implementation
- Complete RTL architecture
- RV32I processor with RL-based adaptive controller
- Q-Learning hardware adaptation
- Processing Element (PE) array management
- FPGA synthesis and implementation
- Verified timing closure
- **5,000-episode reinforcement learning evaluation**
- Dynamic **2/4/8 PE selection strategy**
- Comprehensive simulation and verification