clear all;
close all;

full_image = imread('Image_base_050.jpg');
x0 = 2500;
y0 = 2500;
x_size = 500;
y_size = 750;
I = full_image(x0:x0+x_size-1, y0:y0+y_size-1, :);

% Define test points to calculate transform
p = [ 0,          0;      
      size(I, 2), 0;
      size(I, 2), size(I, 1);
      0,          size(I, 1)];

% Arrays to store images and homographies
my_path = 'C:\Users\Duncan\Documents\MATLAB\Visual Perception\SIFT\SEQUENCE1\';
j = 1;
  
% Delta value for turning the rect into trapezoid
for d = 50:50:200

    % Define changes to make trapezoidal test points
    delta(:,:,1) = [[-d; d; 0; 0], zeros(4,1)];
    delta(:,:,2) = [[0; 0; d; -d], zeros(4,1)];
    delta(:,:,3) = [zeros(4,1),    [-d; 0; 0; d]];
    delta(:,:,4) = [zeros(4,1),    [0; -d; d; 0]];

    for i = 1:size(delta,3)
        [I_proj, H] = make_projection(I, p, delta(:,:,i));
        
        Sequence1Homographies(j) = struct('H', H.T);
        
        for n = 'a':'d'
            % Add noise to images
            switch n
                case 'a'
                    d_noise = zeros(size(I_proj));
                case 'b'
                    d_noise = 3*randn(size(I_proj));
                case 'c'
                    d_noise = 6*randn(size(I_proj));
                case 'd'
                    d_noise = 18*randn(size(I_proj));
            end  

            img_id = strcat(sprintf('%02d',j), n);
            filename = strcat(my_path, 'Image_', img_id,'.jpg');
            imwrite(I_proj+uint8(d_noise), filename);
        end    
        j = j + 1;
    end
end

save([my_path 'Sequence1Homographies.mat']);