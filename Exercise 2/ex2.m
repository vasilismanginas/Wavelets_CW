b0 = ones(1, 64);
b1 = (1/64) * conv(b0, b0);
b2 = (1/64) * conv(b0, b1);
b3 = (1/64) * conv(b0, b2);
b4 = (1/64) * conv(b0, b3);

h0 = (sqrt(2) / 256) * [-5 20 -1 -96 70 280 70 -96 -1 20 -5];
num_of_upsamples = 5;
phi_tilde_approximation = h0;

for index = 1:num_of_upsamples
    upsampled_h0 = upsample(h0);
    phi_tilde_approximation = conv(phi_tilde_approximation, upsampled_h0);
    h0 = upsampled_h0;
end

i = num_of_upsamples + 1;
phi_tilde_approximation = phi_tilde_approximation * 2^(i/2);
phi_tilde_approximation = phi_tilde_approximation(58:end);

% figure
% plot(phi_tilde_approximation, 'DisplayName', 'Scaling function dual');
% title('Reconstruction errors', 'FontSize', 13)
% xlim([0 2048])
% legend('FontSize', 11)
% plot(phi_tilde_approximation);



x = 0:2047;
max_degree = 3;
n = 32;
L = 10;
errors = zeros(max_degree+1, 2048);

for power = 0:max_degree

    polynomial = x .^ power;
    signal = zeros(1, 2048);

    figure

    for index = 0:n-L
        phi = zeros(1, 2048);
        phi_tilde = zeros(1, 2048);
        start_index = index * 64 + 1;
        end_index = index * 64 + length(b3);
        end_index_tilde = index * 64 + length(phi_tilde_approximation);
        phi(start_index : end_index) = b3;
        phi_tilde(start_index : end_index_tilde) = phi_tilde_approximation;
        
        current_coefficient = (1/64) * phi_tilde * polynomial';
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

x = linspace(0,2048,2048);

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