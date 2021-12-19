
diracs = zeros(1, 2048);
diracs(500) = 30;
diracs(1200) = 50;

[phi_T, psi_T, xval] = wavefun('dB7', 6);
phi_T(end) = [];
x = 0:2047;
max_degree = 6;
n = 32;
L = xval(end);

moments = zeros(1, max_degree+1);

for power = 0:max_degree
    
    polynomial = x .^ power;

    scaled_samples = zeros(1, 26);

    for index = 0:n-L
        phi = zeros(1, 2048);
        start_index = index * 64 + 1;
        end_index = index * 64 + length(phi_T);
        phi(start_index : end_index) = phi_T;
        
        current_coefficient = (1/64) * phi * polynomial';
        sample = phi * diracs'; 
        scaled_samples(index+1) = current_coefficient * sample;
    end

    moments(power+1) = sum(scaled_samples);

end

[h, tk, ak] = annihilating_filter(moments);

tk = round(tk) + 1
ak

var = 10;
noise = sqrt(var) * randn(1, length(moments));
noisy_moments = moments + noise;

[hn, tkn, akn] = annihilating_filter(noisy_moments);

tkn = round(tkn) + 1
akn