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

## Key Features

* RV32I RISC-V Processor Core
* Reinforcement Learning Controller
* Q-Learning Adaptation Logic
* Adaptive AI Accelerator
* Processing Element (PE) Array
* Performance Monitoring Unit
* Modular SystemVerilog Design
* Comprehensive Verification Testbenches
* FPGA Implementation using Xilinx Vivado

---

## System Architecture

The SoC integrates a traditional RV32I processor with an RL-based adaptive hardware subsystem.

<p align="center">
  <img src="images/rtl_architecture.png" alt="RTL Architecture" width="900"/>
</p>

### Major Components

| Component            | Purpose                  |
| -------------------- | ------------------------ |
| RV32I Core           | Instruction execution    |
| RL Controller        | Adaptive decision making |
| Q-Learning Engine    | Policy updates           |
| Adaptive Accelerator | AI workload acceleration |
| PE Array             | Parallel computation     |
| Performance Monitor  | Runtime statistics       |

---

## Project Structure

```text
RL-Adaptive-RISCV-AI-SoC/
├── images/
│   ├── rtl_architecture.png
│   ├── simulation_waveform.png
│   ├── resource_utilization.png
│   ├── timing_summary.png
│   ├── rl_training_reward.png
│   ├── processor_cycle_count.png
│   └── pe_utilization_training.png
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

## RTL Modules

| Module                         | Function                      |
| ------------------------------ | ----------------------------- |
| `ras_riscv_core.sv`            | RV32I Processor               |
| `ras_control_unit.sv`          | Instruction control           |
| `ras_instruction_decoder.sv`   | Instruction decoding          |
| `ras_register_file.sv`         | Register storage              |
| `ras_alu.sv`                   | Arithmetic Logic Unit         |
| `ras_program_counter.sv`       | Program sequencing            |
| `ras_q_learning_controller.sv` | Q-learning controller         |
| `ras_rl_controller.sv`         | Reinforcement learning logic  |
| `ras_adaptive_accelerator.sv`  | Adaptive AI accelerator       |
| `ras_pe_array_controller.sv`   | Processing element management |
| `ras_performance_monitor.sv`   | Performance monitoring        |

---

## Verification

The project includes extensive SystemVerilog verification for both individual modules and integrated system behavior.

### Verified Modules

* ALU
* Register File
* Instruction Decoder
* Instruction Memory
* Program Counter
* Processing Element
* PE Array
* RL Controller
* Q-Learning Controller
* Adaptive Accelerator
* Integrated Stress Testing

---

## Simulation Results

Behavioral simulation was performed in **Xilinx Vivado** to verify processor execution, accelerator activation, and reinforcement learning adaptation.

<p align="center">
  <img src="images/simulation_waveform.png" alt="Simulation Waveform" width="900"/>
</p>

**Simulation verifies:**

* Processor execution flow
* Accelerator activation
* RL-based adaptation
* Memory interaction
* Control signal correctness

---

# FPGA Implementation Results

The complete design was synthesized and implemented in **Xilinx Vivado**.

## Resource Utilization

| Resource        | Utilization |
| --------------- | ----------: |
| Slice LUTs      |      10,632 |
| Slice Registers |       9,945 |
| F7 Muxes        |       1,184 |
| F8 Muxes        |         544 |
| Bonded IOB      |           6 |
| BUFGCTRL        |           1 |

<p align="center">
  <img src="images/resource_utilization.png" alt="Resource Utilization" width="900"/>
</p>

The implementation utilizes approximately **17%** of available Slice LUT resources while maintaining an efficient register and routing footprint.

---

## Timing Performance

All specified timing constraints were successfully met.

| Metric                     | Result       |
| -------------------------- | ------------ |
| Worst Negative Slack (WNS) | **0.221 ns** |
| Total Negative Slack (TNS) | **0 ns**     |
| Worst Hold Slack (WHS)     | **0.106 ns** |
| Hold Violations            | **0**        |
| Failing Endpoints          | **0**        |

<p align="center">
  <img src="images/timing_summary.png" alt="Timing Summary" width="900"/>
</p>

This indicates successful FPGA implementation without timing violations.

---

# Reinforcement Learning Performance

The reinforcement learning subsystem was evaluated using long-duration training runs to observe convergence behavior and hardware adaptation.

## Training Reward

The moving average reward steadily converges toward approximately **14–15**, demonstrating stable learning behavior.

<p align="center">
  <img src="images/rl_training_reward.png" alt="Training Reward" width="900"/>
</p>

**Observations**

* Stable convergence
* Reduced reward variance
* Improved policy consistency

---

## Processor Cycle Count

The processor dynamically adapts execution behavior throughout training.

<p align="center">
  <img src="images/processor_cycle_count.png" alt="Processor Cycle Count" width="900"/>
</p>

The decreasing variability indicates increasingly efficient workload execution as the RL controller learns improved scheduling strategies.

---

## Processing Element Utilization

The RL controller dynamically adjusts Processing Element (PE) utilization based on workload demands.

<p align="center">
  <img src="images/pe_utilization_training.png" alt="PE Utilization" width="900"/>
</p>

### Key Insights

* Utilization ranges approximately between **560–1000 active units**
* High sustained accelerator engagement
* Dynamic hardware resource allocation
* Efficient adaptive scheduling during training

This demonstrates that the RL controller actively balances computational resources instead of operating with fixed hardware allocation.

---

# Technology Stack

| Category        | Technology                |
| --------------- | ------------------------- |
| HDL             | SystemVerilog             |
| Architecture    | RV32I RISC-V              |
| FPGA Tool       | Xilinx Vivado             |
| Verification    | SystemVerilog Testbenches |
| AI Technique    | Q-Learning                |
| Hardware Target | FPGA                      |

---

# Future Improvements

* Artix-7 hardware deployment
* Multi-core adaptive architecture
* Advanced RL policies
* Dynamic voltage and frequency scaling
* Power-aware scheduling
* Larger Processing Element arrays

---

# Author

**Akshaj Gandi**

Electronics and Communication Engineering

SRM Institute of Science and Technology, Tiruchirappalli

GitHub: **akshajsaigandi-ux**

---

## Repository Highlights

* Modular SystemVerilog implementation
* Complete RTL architecture
* FPGA synthesis and implementation
* Verified timing closure
* Reinforcement Learning hardware adaptation
* Processing Element utilization analysis
* Comprehensive simulation and verification
