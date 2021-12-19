
diracs = zeros(1, 2048);
diracs(500) = 30;
diracs(1200) = 50;
K = 2;

daubechies = ["db5", "db6", "db7", "db8"];

tks_ann = zeros(length(daubechies), 2);
tks_TLS = zeros(length(daubechies), 2);
tks_cTLS = zeros(length(daubechies), 2);
aks_ann = zeros(length(daubechies), 2);
aks_TLS = zeros(length(daubechies), 2);
aks_cTLS = zeros(length(daubechies), 2);

for current_daubechies = 1:4

    [phi_T, psi_T, xval] = wavefun(daubechies(current_daubechies), 6);
    phi_T(end) = [];
    x = 0:2047;
    max_degree = current_daubechies+4;
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
    
    var = 2.5;
    noise = sqrt(var) * randn(1, length(moments));
    noisy_moments = moments + noise;
    N = length(noisy_moments) - 1;
    
    x = noisy_moments;
    y = noisy_moments;
    z = noisy_moments;
    
    [h, tk, ak] = annihilating_filter(noisy_moments);
    tk = tk + 1;
    ak;
    tks_ann(current_daubechies,:) = tk;
    aks_ann(current_daubechies,:) = ak;
    
    [hTLS, tkTLS, akTLS] = TLS(noisy_moments, false, N, K);
    tkTLS = tkTLS + 1;
    akTLS;
    tks_TLS(current_daubechies,:) = tkTLS;
    aks_TLS(current_daubechies,:) = akTLS;
    
    [hcTLS, tkcTLS, akcTLS] = TLS(noisy_moments, true, N, K);
    tkcTLS = tkcTLS + 1;
    akcTLS;
    tks_cTLS(current_daubechies,:) = tkcTLS;
    aks_cTLS(current_daubechies,:) = akcTLS;
end


tks_ann
tks_TLS
tks_cTLS

aks_ann
aks_TLS
aks_cTLS