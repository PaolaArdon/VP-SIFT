close all;clear all;
I = imread('C:\Users\PaolaAlejandra\Documents\II Semester\VP\LAB\04 -LAB04\Image_base.jpg');
% Creating a smaller image of size 2000 x 2000
im1 = I(2000:3000, 1750:4000, :);
% Creating the reference image of size 750 x 500 
im2 = I(250:750, 750:1500, :);

%% Generating rotation sequence
% Working with the crop of the middle of the image
[ sequence3Homographies ] = rotation( im1,im2 );
% Checking the homography matrix of the zoom
Image_0a = imread([pwd '/SEQUENCE3/Image_01a.png']);
Image_4a = imread([pwd '/SEQUENCE3/Image_04a.png']);

p_00 = [316 290 1];
p_04 = sequence3Homographies(4).H * p_00';

figure; imshow(Image_0a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'gx','Linewidth',8);
title('Rotation')

figure; imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'rx','Linewidth',8);
title('Rotation')

%% Generating zoom sequence
% Working with the crop of the middle of the image
smallImg =im1; largeImg =im2;
[ sequence2Homographies ] = zoom( im1,im2);

% Checking the homography matrix of the zoom
Image_0a = imread([pwd '/SEQUENCE2/Image_0a.png']);
Image_4a = imread([pwd '/SEQUENCE2/Image_4a.png']);

p_00 = [316 290 1];
p_04 = sequence2Homographies(4).H * p_00';

figure; imshow(Image_0a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'gx','Linewidth',8);
title('Zoom')

figure; imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'rx','Linewidth',8);
title('Zoom')

%% Implement a testing system for SEQUENCE1
% path = [pwd '/SEQUENCE1/Sequence1Homographies.mat'];
% sequence =1; setSize =16; type ='SIFT';
% [time] = plottingSequence( path, sequence, setSize, type );

%% Implement a testing system for SEQUENCE2
path = [pwd '/SEQUENCE2/Sequence2Homographies.mat'];
sequence =2; setSize =9; type ='SIFT';
[timeSequence2] = plottingSequence( path, sequence, setSize, type );

%% Implement a testing system for SEQUENCE3
 path = [pwd '/SEQUENCE3/Sequence3Homographies.mat'];
 sequence =3; setSize =18; type ='SIFT';
 [timeSequence3] = plottingSequence( path, sequence, setSize, type );
