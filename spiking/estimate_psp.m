% script to estimate the PSP size in complicated NEURON experiment

U_vals = linspace(0, 1, 101);
nU_vals = length(U_vals);

% define params
tau = 10;
tfac = 400;
trec = 25;
U = 0.1;
f = U;
alpha = 1.5;
beta = 1.5;
gmax_ampa = 0.00925;
erev_ampa = 0;

% initialize
R = 1;
u = 0;
ipi = 9e4;
ampa = 0;
curr = 0;
v = -60;

ampa_vals = zeros(nU_vals, 1);
for ui=1:nU_vals
    
    U = U_vals(ui);

    % calculate eTM part resulting in C
    R = 1 - (1 - R * (1 - u)) * exp(-ipi/trec);
    u = U + (u + f * (1 - u) - U) * exp(-ipi / tfac);
    C = u * R;

    % calculate forward / backward binding rate
    rinf = C * alpha / (C * alpha + beta);
    rtau = 1 / ((C * alpha) + beta);
    r0 = ampa;
    ampa = rinf + (r0 - rinf) * exp(-ipi / rtau);
    ampa_vals(ui) = ampa;

end

% increase conductance
g_ampa = gmax_ampa * ampa;
i = g_ampa * (v - erev_ampa);

% calc current and voltage
curr = curr - curr / tau + i;
v = v - v / tau + curr;
