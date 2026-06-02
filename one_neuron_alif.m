function [t, V_hist, spike_times] = one_neuron_alif(plot_result)
% one_neuron_alif.m
% Single-neuron ALIF model suitable as a MATLAB reference for FPGA design.
% Call this function from MATLAB with optional plotting.
%
% Usage:
%   [t, V_hist, spike_times] = one_neuron_alif();
%   [t, V_hist, spike_times] = one_neuron_alif(false);
%
% If plot_result is true or omitted, the membrane voltage is plotted.

if nargin < 1 || isempty(plot_result)
    plot_result = true;
end

% Simulation parameters
DT = 0.05;        % time step (ms)
T  = 200.0;       % total duration (ms)
t = (0:DT:T-DT)'; % time vector
Nt = length(t);

% ALIF neuron parameters
C       = 1.0;    % membrane capacitance
G_L     = 0.1;    % leak conductance
E_L     = -65.0;  % leak reversal potential (mV)
V_TH    = -50.0;  % spike threshold (mV)
V_RESET = -68.0;  % reset voltage after spike (mV)
E_K     = -80.0;  % adaptation reversal potential (mV)

TAU_A   = 100.0;  % adaptation time constant (ms)
DELTA_A = 0.05;   % adaptation increment per spike
I_EXT   = 3.0;    % external drive current

% Initial conditions
V = E_L;         % membrane voltage
a = 0.0;         % adaptation current

V_hist = zeros(Nt, 1);
spike_times = zeros(0, 1);

% There is no synaptic input in the single neuron version.
I_syn = 0.0;

for k = 1:Nt
    V_hist(k) = V;

    % ALIF voltage update
    dV = (-G_L * (V - E_L) - a * (V - E_K) + I_EXT + I_syn) / C;
    V = V + dV * DT;

    % Adaptation decay
    da = -a / TAU_A;
    a = a + da * DT;

    % Spike detection and reset
    if V >= V_TH % a spike is detected if this T
        spike_times(end+1, 1) = t(k); %#ok<AGROW>
        V = V_RESET; % reset v to -68
        a = a + DELTA_A; % increment adaption
    end
end

if plot_result
    fprintf('Num spikes: %d\n', numel(spike_times));
    fprintf('Spike times (ms): ');
    fprintf('%.2f ', spike_times);
    fprintf('\n');

    figure('Name', 'Single ALIF Neuron', 'Color', 'w');
    plot(t, V_hist, 'LineWidth', 1.2);
    hold on;
    plot(t, V_TH * ones(size(t)), 'r--', 'LineWidth', 1);
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    title('Single ALIF neuron');
    legend({'V', 'Threshold'});
    grid on;
end
