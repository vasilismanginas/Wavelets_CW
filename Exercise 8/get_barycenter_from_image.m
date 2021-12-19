function [barycenter_red, barycenter_green, barycenter_blue] = get_barycenter_from_image(image_name, red_thresh, green_thresh, blue_thresh)
    load('PolynomialReproduction_coef.mat','Coef_0_0','Coef_1_0','Coef_0_1');
    
    rgb_image = imread(image_name); 
    red =  im2double(rgb_image(:,:,1));
    green = im2double(rgb_image(:,:,2));
    blue = im2double(rgb_image(:,:,3));

    red(red < red_thresh) = 0;
    green(green < green_thresh) = 0;
    blue(blue < blue_thresh) = 0;
    
    m00red = sum(Coef_0_0 .* red, "all");
    m00green = sum(Coef_0_0 .* green, "all");
    m00blue = sum(Coef_0_0 .* blue, "all");

    m10red = sum(Coef_1_0 .* red, "all");
    m10green = sum(Coef_1_0 .* green, "all");
    m10blue = sum(Coef_1_0 .* blue, "all");

    m01red = sum(Coef_0_1 .* red, "all");
    m01green = sum(Coef_0_1 .* green, "all");
    m01blue = sum(Coef_0_1 .* blue, "all");

    barycenter_red = [(m10red/m00red) (m01red/m00red)];
    barycenter_green = [(m10green/m00green) (m01green/m00green)];
    barycenter_blue = [(m10blue/m00blue) (m01blue/m00blue)];
end