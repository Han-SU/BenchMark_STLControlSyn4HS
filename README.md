# BenchMark_STLControlSyn4HS
This repository contains benchmark examples for the paper accepted by FM 2024, titled “Switching Controller Synthesis for Hybrid Systems Against STL Formulas.”

## File Description

- *guard_syn.ipynb*: Synthesizes switching controllers for HS with constant dynamics by exactly calculating state-time sets. Includes the benchmarks **Reactor**, **WaterTank**, and **CarSeq**.
- *guard_syn_approxi.ipynb*: Synthesizes switching controllers for HS with unsolvable dynamics by approximating state-time sets. Includes the benchmarks **Oscillator** and **Temperature**.
- *StateApprox.m*: Approximates the state-time sets using the SDP solver in MATLAB. The *guard_syn_approxi.ipynb* notebook will call this file using the *matlab.engine* package in Python.


## Dependencies
- Python Version: 3.10.14
- Essential Python Packages: matlab.engine, z3


 ## Set Up
 1. Install MATLAB 2022b or any later version. Check [here](https://www.mathworks.com/support/requirements/python-compatibility.html)  for the compatible version of Python 3.10 with MATLAB Engine.
 2. Install [MOSEK 10.2](https://docs.mosek.com/latest/toolbox/index.html) and [YALMIP](https://yalmip.github.io/tutorial/installation/) for matlab.
 3. Install the Python package *matlab.engine* and *z3*
 4. Run the two Julia notebook files.

