samples = load("samples.mat");
samples = cell2mat(struct2cell(samples));


[phi_T, psi_T, xval] = wavefun('dB4', 6);
phi_T(end) = [];
x = 0:2431;
max_degree = 3;
n = 38;
L = xval(end);

moments = zeros(1, max_degree+1);
    
for power = 0:max_degree
    
    polynomial = x .^ power;

    scaled_samples = zeros(1, 25);

    for index = 0:n-L
        phi = zeros(1, 2432);
        start_index = index * 64 + 1;
        end_index = index * 64 + length(phi_T);
        phi(start_index : end_index) = phi_T;
        
        current_coefficient = (1/64) * phi * polynomial';
        scaled_samples(index+1) = current_coefficient * samples(index+1);
    end

    moments(power+1) = sum(scaled_samples);

end

[h, tk, ak] = annihilating_filter(moments);

tk = round(tk) + 1
ak