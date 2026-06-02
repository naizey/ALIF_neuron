"""one_neuron_alif.py
Single-neuron ALIF model suitable as the starting point for FPGA design.

This Python script implements a single Adaptive Leaky Integrate-and-Fire
(ALIF) neuron with a fixed time step and explicit update equations.
It can be used as a callable function or executed as a script.
"""

import numpy as np
import matplotlib.pyplot as plt


def simulate_single_alif(
    DT=0.05,
    T=200.0,
    C=1.0,
    G_L=0.1,
    E_L=-65.0,
    V_TH=-50.0,
    V_RESET=-68.0,
    E_K=-80.0,
    TAU_A=100.0,
    DELTA_A=0.05,
    I_EXT=3.0,
    I_syn=0.0,
    plot_result=True,
):
    """Simulate one ALIF neuron and optionally plot the membrane voltage.

    Returns:
        t: time vector (ms)
        V_hist: membrane voltage history (mV)
        spike_times: list of spike times (ms)
    """

    t = np.arange(0.0, T, DT)
    Nt = len(t)

    V = E_L
    a = 0.0

    V_hist = np.zeros(Nt, dtype=np.float32)
    spike_times = []

    for k in range(Nt):
        V_hist[k] = V
        #-g_l * (v-e_l) leaky, pulls V back toward e_l
        dV = (-G_L * (V - E_L) - a * (V - E_K) + I_EXT + I_syn) / C
        V = V + dV * DT

        da = -a / TAU_A #adaptive part 
        a = a + da * DT

        if V >= V_TH: #fire (IF), when V hits -50, spike fired, and V reset to -68
            spike_times.append(t[k])
            V = V_RESET
            a = a + DELTA_A

    if plot_result:
        plt.figure(figsize=(8, 3))
        plt.plot(t, V_hist, label='V (mV)')
        plt.axhline(V_TH, color='r', linestyle='--', label='Threshold')
        plt.xlabel('Time (ms)')
        plt.ylabel('Membrane voltage (mV)')
        plt.title('Single ALIF neuron')
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.show()

    return t, V_hist, spike_times


if __name__ == '__main__':
    t, V_hist, spike_times = simulate_single_alif(plot_result=True)
    print(f'Num spikes: {len(spike_times)}')
    print('Spike times (ms):', spike_times)
