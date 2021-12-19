
step = 50;
num_of_locations = floor(2048 / step);

tk_error = zeros(1, num_of_locations);
ak_error = zeros(1, num_of_locations);

[phi_T, psi_T, xval] = wavefun('dB5', 6);
phi_T(end) = [];
x = 0:2047;
max_degree = 4;
n = 32;
L = xval(end);


figure
hold on
base_variance = 10;
for exponent = 0:4
    if exponent == 0
        variance = 0;
    else
        variance = base_variance ^ (exponent);
    end
    variance

    for current_location = 0:num_of_locations

        diracs = zeros(1, 2048);
        location1 = 1000;
        amplitude1 = 30;
        location2 = current_location * step + 1;
        amplitude2 = 50;
        diracs(location1) = amplitude1;
        diracs(location2) = amplitude2;
        
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
        
        noise = sqrt(variance) * randn(1, length(moments));
        noisy_moments = moments + noise;

        [h, tk, ak] = annihilating_filter(noisy_moments);
        tk = round(tk) + 1;
        ak;
    
    
        if location2 < location1
            tk_error(current_location+1) = abs(location2 - tk(1));
        else
            tk_error(current_location+1) = abs(location2 - tk(2));
        end
    
%         if location2 < location1
%             ak_error(current_location+1) = abs(amplitude2 - ak(1));
%         else
%             ak_error(current_location+1) = abs(amplitude2 - ak(2));
%         end
    
    end
    
    x_axis = linspace(0, 2048, num_of_locations+1);
    plot(x_axis , tk_error, 'LineWidth', 2, 'DisplayName', strcat('Variance =', " ", num2str(variance)));
    xlim([0 2048])
    ylim([-100 1000])
    title('Error in extraction of locations tk', 'FontSize', 13)
    xlabel('Location of second Dirac')
    ylabel('tk error')
    legend('FontSize', 11);
    
%     x_axis = linspace(0, 2048, num_of_locations+1);
%     plot(x_axis , ak_error, 'LineWidth', 2, 'DisplayName', strcat('Variance =', " ", num2str(variance)))
%     xlim([0 2048])
%     ylim([-10 1000])
%     title('Error in extraction of amplitudes ak', 'FontSize', 13)
%     xlabel('Location of second Dirac')
%     ylabel('ak error')
%     legend('FontSize', 11);

end