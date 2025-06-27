# SoC Neural Network Hardware – Midterm Report

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

## Next Steps

- Implement basic neuron logic blocks.
- Explore combinational implementations of activation functions.
- Begin integration of components for larger neural architectures.
