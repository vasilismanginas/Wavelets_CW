function [SR_image] = Main_SR
% *************************************************************************
% Wavelets and Applications Course - Dr. P.L. Dragotti
% MATLAB mini-project 'Sampling Signals with Finite Rate of Innovation'
% Exercice 6
% *************************************************************************
% 
% FOR STUDENTS
%
% This function runs a complete super-resolution algorithm based on the
% continuous moments analysis. The set of images is 'LR_Tiger_xx.tif' where
% xx is a number between 01 and 40. Each image is 64 x 64 pixels. The
% output super-resolved image 'SR_image' is 512 x 512 pixels.
%
% Author:   Loic Baboulaz
% Date:     August 2006
%
% Imperial College London
% *************************************************************************

% 0.61 0.45 0.29 -> 24.70

for red_thresh = 0.61:0.01:0.61
    for green_thresh = 0.45:0.01:0.45
        for blue_thresh = 0.29:0.01:0.29
            % Register images
            [Tx_RGB Ty_RGB] = ImageRegistration(red_thresh, green_thresh, blue_thresh);
            
            % Compute super-resolved image
            [SR_image] = ImageFusion(Tx_RGB, Ty_RGB);
        
            fid = fopen('PSNR.txt', 'at');
            fprintf(fid, 'r=%2.2f, g=%2.2f, b=%2.2f\n', red_thresh, green_thresh, blue_thresh);
            fclose(fid);
        end
    end
end

r = "what the fuck is going on?"
pause(2)
