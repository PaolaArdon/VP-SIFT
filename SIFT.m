close all;clear all;
I = imread('C:\Users\PaolaAlejandra\Documents\II Semester\VP\LAB\04 -LAB04\Image_base.jpg');
I_orig = I(2500:3000, 2500:3250, :);
figure;hold on;
imshow(I_orig);
%figure();imshow(I);

% Creating a smaller image of size 2000 x 2000 in the center of the
% original image
[m,n,~] = size(I);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [2000,2000];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 2000-1;
a4 = 2000-1;
im1 =  imcrop(I, [a1 a2 a3 a4]);
%figure();imshow(im1);

% Creating the reference image of size 750 x 500 in the center of the
% original image
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [500,750];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 750-1;
a4 = 500-1;
im2 =  imcrop(im1, [a1 a2 a3 a4]);
figure;hold on;
imshow(im2);

% Creating the reference image of size 1000 x 500 in the center of the
% original image
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [500,950];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 950-1;
a4 = 500-1;
imx =  imcrop(im1, [a1 a2 a3 a4]);
%figure();imshow(imx);

% Creating the reference image of size 750 x 700 in the center of the
% original image
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [700,750];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 750-1;
a4 = 700-1;
imy =  imcrop(im1, [a1 a2 a3 a4]);
%figure();imshow(imy);

%% Generating zoom sequence
smallImg =im1; largeImg =im2;
[ sequenceToHomographies ] = zoom( smallImg,largeImg);

% Checking the homography matrix of the zoom
Image_0a = imread([pwd '/SEQUENCE2/Image_0a.png']);
Image_4a = imread([pwd '/SEQUENCE2/Image_4a.png']);

p_00 = [316 290 1];
p_04 = sequenceToHomographies(4).H * p_00';

figure; imshow(Image_0a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'gx','Linewidth',8);

figure; imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'rx','Linewidth',8);