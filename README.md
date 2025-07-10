# SOC Neural Network Hardware 

## Overview

This repository documents the initial progress of the SoC project focused on implementing neural network hardware using VHDL. The aim is to design basic digital components and gradually move toward building hardware-efficient neural network blocks.

## Week 1

- Understood basic VHDL structure: entity and architecture.
- Implemented a basic inverter using behavioral modeling.
- Explored structural modeling by building an AND gate using two NAND gates.
- Learned component declaration, instantiation, and port mapping.

## Week 2 and Week 3

- Studied types of digital circuits: combinational and sequential.
- Implemented D flip-flops with asynchronous set and reset.
- Understood the differences between structural, behavioral, and dataflow modeling styles.
- Designed a sequence generator combining structural and dataflow styles.
- Built a Mealy FSM-based string detector that identifies predefined word sequences from a stream of 5-bit encoded characters.

## Files

- `inverter.vhd`, `and_using_nand.vhd`: Basic VHDL modeling examples.
- `sequence_generator.vhd`: Sequence generator using D flip-flops.
- `word_detection.vhd`: FSM-based word detection using Mealy machines.

## Project
# Neural Network Hardware Accelerator
**Verilog Implementation of a 3-4-2 Fully Connected Neural Network**

## Overview
This project implements a custom hardware accelerator for neural network inference in Verilog. The design features:
- 3-layer fully connected neural network (3-4-2 architecture)
- Parallel MAC execution with sequential input feeding
- 8-state FSM controller for precise timing
- Saturation-handling ReLU activation
- Automated testbench verification

## Key Features
### Hardware Architecture
- **3-4-2 Network Structure**:
  - Input layer: 3 neurons
  - Hidden layer: 4 neurons with ReLU activation
  - Output layer: 2 neurons with ReLU activation
- **Pre-trained 8-bit Weights**:
  ```verilog
  // Hidden layer weights
  W1[0] = [2, 3, 1]; b1[0] = 1
  W1[1] = [3, 1, 2]; b1[1] = 1
  W1[2] = [1, 2, 3]; b1[2] = 1
  W1[3] = [2, 1, 3]; b1[3] = 1
  
  // Output layer weights
  W2[0] = [1, 2, 1, 2]; b2[0] = 1
  W2[1] = [2, 1, 2, 1]; b2[1] = 1
