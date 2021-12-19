function [Tx_RGB Ty_RGB]= ImageRegistration(red_thresh, green_thresh, blue_thresh)
% *************************************************************************
% Wavelets and Applications Course - Dr. P.L. Dragotti
% MATLAB mini-project 'Sampling Signals with Finite Rate of Innovation'
% Exercice 6
% *************************************************************************
% 
% FOR STUDENTS
%
% This function registers the set of 40 low-resolution images
% 'LR_Tiger_xx.tif' and returns the shifts for each image and each layer
% Red, Green and Blue. The shifts are calculated relatively to the first
% image 'LR_Tiger_01.tif'. Each low-resolution image is 64 x64 pixels.
%
%
% OUTPUT:   Tx_RGB: horizontal shifts, a 40x3 matrix
%           Ty_RGB: vertical shifts, a 40x3 matrix
%
% NOTE: _Tx_RGB(1,:) = Ty_RGB(1,:) = (0 0 0) by definition.
%       _Tx_RGB(20,2) is the horizontal shift of the Green layer of the
%       20th image relatively to the Green layer of the firs image.
%
%
% OUTLINE OF THE ALGORITHM:
%
% 1.The first step is to compute the continuous moments m_00, m_01 and m_10
% of each low-resolution image using the .mat file called:
% PolynomialReproduction_coef.mat. This file contains three matrices
% 'Coef_0_0', 'Coef_1_0' and 'Coef_0_1' used to calculate the continuous
% moments.
%
% 2.The second step consists in calculating the barycenters of the Red,
% Green and Blue layers of the low-resolution images.
%
% 3.By computing the difference between the barycenters of corresponding 
% layers between two images, the horizontal and vertical shifts can be 
% retrieved for each layer.
%
%
% Author:   Loic Baboulaz
% Date:     August 2006
%
% Imperial College London
% *************************************************************************


% Load the coefficients for polynomial reproduction
load('PolynomialReproduction_coef.mat','Coef_0_0','Coef_1_0','Coef_0_1');

image_list = dir('*.tif');

[ref_barycenter_red, ref_barycenter_green, ref_barycenter_blue] = get_barycenter_from_image("LR_Tiger_01.tif", red_thresh, green_thresh, blue_thresh);

Tx_RGB = zeros(40, 3);
Ty_RGB = zeros(40, 3);

for k = 1 : length(image_list)
    current_image_name = image_list(k).name;
    
    if current_image_name ~= "HR_Tiger_01.tif"
        [barycenter_red, barycenter_green, barycenter_blue] = get_barycenter_from_image(current_image_name, red_thresh, green_thresh, blue_thresh);
        difference_red = barycenter_red - ref_barycenter_red;
        difference_green = barycenter_green - ref_barycenter_green;
        difference_blue = barycenter_blue - ref_barycenter_blue;

        dx_rgb = [difference_red(1) difference_green(1) difference_blue(1)];
        dy_rgb = [difference_red(2) difference_green(2) difference_blue(2)];

        Tx_RGB(k-1,:) = dx_rgb;
        Ty_RGB(k-1,:) = dy_rgb;
    end
end