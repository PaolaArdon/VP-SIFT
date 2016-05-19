function [ Sequence2Homographies ] = zoom( smallImg,largeImg )
%UNTITLED Summary of this function goes here
%SEQUENCE 2 (zoom): This sequence has to be composed of a synthetic
% set of images in which, for every image, the distance between the camera
% and the scene has decreased. The sequence will contain 9 images, as a
% result of doing a zoom of the scene from 110% up to a 150% in increments
% of 5%. The homography matrices will be stored on a .mat file which will be
% called Sequence2Homographies.mat, in a structure with the same name of
% the file

% Creating the folder that contains the images and the homography matrix
path = [pwd '/SEQUENCE2'];
if exist(path) == 0
    mkdir(path);
end
Sequence2Homographies = struct();
save([path '/sequence2Homographies.mat']);

% Save the reference image
imwrite(largeImg, [path '/Image_' num2str(00) 'a' '.png']);

% Creating the set of 9 images in each set (a), (b), (c), (d) as a result of
% doing a zoom of the scene from 110% up to a 150% in increments of 5%.
zoom = 1.1;
for i = 1: 9
    % We zoom the image of size 2000 x 2000 and then crop it to size
    % 750 x 500 and save it
    B = imresize(smallImg,zoom);
    
    [m,n,~] = size(B);
    row_c = floor(m/2);
    col_c = floor(n/2);
    rect1 = [500,750];
    a1 =  floor(col_c - rect1(2)/2)+1;
    a2 =  floor(row_c - rect1(1)/2)+1;
    a3 = 750-1;
    a4 = 500-1;
    
    % Creating the set (a) of images without noise
    imageSetA =  imcrop(B, [a1 a2 a3 a4]);
    imwrite(imageSetA, [path '/Image_' num2str(i) 'a' '.png']);
    
    % Creating the set (b) of images that has additive 0-mean Gaussian
    % noise with standard deviation of 3 grayscale values,
    imageSetB = imnoise(imageSetA,'gaussian',0,(3/255)^2);
    imwrite(imageSetB, [path '/Image_' num2str(i) 'b' '.png']);
    
    % Creating the set (c) of images that has additive 0-mean Gaussian
    % noise with standard deviation of 6 grayscale values,
    imageSetC = imnoise(imageSetA,'gaussian',0,(6/255)^2);
    imwrite(imageSetC, [path '/Image_' num2str(i) 'c' '.png']);
    
    % Creating the set (d) of images that has additive 0-mean Gaussian
    % noise with standard deviation of 18 grayscale values,
    im_d = imnoise(imageSetA,'gaussian',0,(18/255)^2);
    imwrite(im_d, [path '/Image_' num2str(i) 'd' '.png']);
    
    % Creating the corresponding homography matrix
    Sequence2Homographies(i).H = inv([1 0 -750/2; 0 1 -500/2; 0 0 1]) * [zoom 0 0; 0 zoom 0; 0 0 1] * [1 0 -750/2; 0 1 -500/2; 0 0 1];
    
    zoom = zoom + 0.05;
end
save([path '/Sequence2Homographies.mat']);


end

