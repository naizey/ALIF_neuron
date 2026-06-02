# ALIF_neuron

# newdinge_neuron

This folder contains a one-neuron Adaptive Leaky Integrate-and-Fire (ALIF)
reference implementation in both Python and MATLAB.

## Files

- `one_neuron_alif.py` — Python module with a callable function and example script.
- `one_neuron_alif.m` — MATLAB function with optional plotting.

## Purpose

These files are intended as a minimal starting point for FPGA design:
- one neuron only
- fixed time step
- explicit update equations
- no network or synaptic connectivity

## Running

### Python
From the command line:
```bash
python3 newdinge_neuron/one_neuron_alif.py
```

From another Python file or interactive session:
```python
from newdinge_neuron.one_neuron_alif import simulate_single_alif

t, V_hist, spike_times = simulate_single_alif(plot_result=True)
```

To run without plotting:
```python
_, _, spike_times = simulate_single_alif(plot_result=False)
```

### MATLAB
Start MATLAB in the repository root or add the folder to path:
```matlab
addpath('newdinge_neuron')
```

Call the function:
```matlab
[t, V_hist, spike_times] = one_neuron_alif();
```

To call without plotting:
```matlab
[t, V_hist, spike_times] = one_neuron_alif(false);
```

## FPGA translation note

Both scripts use the same ALIF formula:

    C * dV/dt = -G_L (V - E_L) - a (V - E_K) + I_ext + I_syn
    tau_a * da/dt = -a

The discrete Euler update uses:

    V <- V + dV * DT
    a <- a + (-a / tau_a) * DT

Spikes are detected when `V >= V_TH`, and then `V` is reset and `a`
increments by `DELTA_A`.
