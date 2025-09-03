# AMBA-APB-Protocol Design

- 1. Protocol Implementation: This project implements the core finite state machine (FSM) of an AMBA Advanced Peripheral Bus (APB) controller, a key interface protocol for low-power peripheral communication in System-on-Chip (SoC) designs. It accurately models the three essential states (IDLE, SETUP, and ACCESS) that manage the handshake between a system controller and its peripherals.

- 2. Core Functionality: The design provides the fundamental operations of reading from and writing to peripheral registers. It features a 32-word memory block that acts as the target peripheral, accepting write data on successful transactions and returning read data upon request, all while generating the appropriate control signals like ready and error.

- 3. Verification Environment: A comprehensive testbench is included to verify the correctness of the APB controller. It automates testing by applying reset sequences, executing back-to-back write and read operations to various addresses, and monitoring the outputs to ensure the design behaves according to the AMBA APB specification.

<img width="2818" height="990" alt="Screenshot 2025-09-03 235053" src="https://github.com/user-attachments/assets/0a8ce32a-bb38-4c0a-ab66-c31c57cbec59" />


The APB operating states have been implemented in Verilog and are available, [here](https://edaplayground.com)
