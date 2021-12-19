
[phi_T, psi_T, xval] = wavefun('dB4', 6);
phi_T(end) = [];
% figure
% plot(phi_T, 'LineWidth', 2)
% title("Daubechies 4th order scaling function", 'FontSize', 13)
% figure
% plot(psi_T, 'LineWidth', 2)
% title("Daubechies 4th order wavelet", 'FontSize', 13)
x = 0:2047;
max_degree = 3;
n = 32;
L = xval(end);

errors = zeros(max_degree+1, 2048);

for power = 0:max_degree

    polynomial = x .^ power;
    signal = zeros(1, 2048);

    figure

    for index = 0:n-L
        phi = zeros(1, 2048);
        start_index = index * 64 + 1;
        end_index = index * 64 + length(phi_T);
        phi(start_index : end_index) = phi_T;
        
        current_coefficient = (1/64) * phi * polynomial';
        scaled_shifted_phi = current_coefficient * phi;
        signal = signal + scaled_shifted_phi;
        plot(scaled_shifted_phi, 'HandleVisibility', 'off', 'LineWidth', 1)
        hold on
    end

    plot(signal, 'Color', '#000000', 'LineWidth', 2, 'DisplayName', 'Reconstructed signal')
    title('Polynomial Reconstruction', 'FontSize', 13)
    xlim([0 2048])
    legend('FontSize', 11)
    
    errors(power+1, :) = polynomial-signal;

end

figure
plot(errors(1, :), 'LineWidth', 2, 'DisplayName', 'Constant Reconstruction Error')
title('Reconstruction errors', 'FontSize', 13)
xlim([0 2048])
legend('FontSize', 11)
figure
plot(errors(2, :), 'LineWidth', 2, 'DisplayName', 'Linear Reconstruction Error')
title('Reconstruction errors', 'FontSize', 13)
xlim([0 2048])
legend('FontSize', 11)
figure
plot(errors(3, :), 'LineWidth', 2, 'DisplayName', 'Quadratic Reconstruction Error')
title('Reconstruction errors', 'FontSize', 13)
xlim([0 2048])
legend('FontSize', 11)
figure
plot(errors(4, :), 'LineWidth', 2, 'DisplayName', 'Cubic Reconstruction Error')
title('Reconstruction errors', 'FontSize', 13)
xlim([0 2048])
legend('FontSize', 11)