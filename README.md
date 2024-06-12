# BenchMark_STLControlSyn4HS
This repository contains benchmark examples for the paper accepted by FM 2024, titled “Switching Controller Synthesis for Hybrid Systems Against STL Formulas.”

## File Description

- *guard_syn.ipynb*: Synthesizes switching controllers for HS with constant dynamics by exactly calculating state-time sets. Includes the benchmarks **Reactor**, **WaterTank**, and **CarSeq**.
- *guard_syn_approxi.ipynb*: Synthesizes switching controllers for HS with unsolvable dynamics by approximating state-time sets. Includes the benchmarks **Oscillator** and **Temperature**.
- *StateApprox.m*: Approximates the state-time sets using the SDP solver in MATLAB. The *guard_syn_approxi.ipynb* notebook will call this file using the *matlab.engine* package in Python.


## Set Up
- Python Version:
- Essential Python Packages: matlab.engine, z3

 

