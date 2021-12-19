tau = load("tau.mat");
tau = cell2mat(struct2cell(tau));

[h, tk, ak] = annihilating_filter(tau);

tk
% tk = round(tk) + 1
ak