# BenchMark_STLControlSyn4HS
This is the benchmark examples of the paper accepted by FM 2024, named "Switching Controller Synthesis for Hybrid Systems Against STL Formulas
"

## File Description

- [guard_syn.ipynb] : synthesize switching controller for HS with constant dynamics by exactly calculate state-time sets, including the bencmarks $\mathsf{Reactor}$, $\mathsf{WaterTank}$, and $\mathsf{CarSeq}$.
- [guard_syn_approxi.ipynb] : synthesize switching controller for HS with unsolvable sdynamics by approximate state-time sets, including the benchmarks $\mathsf{Oscillator}$, $\mathsf{Temperature}$
- [StateApprox.m] : approximate the state-time sets using SDP solver in matlab. guard_syn_approxi.ipynb will call this file using matlab.engine package in python.

## Set Up

