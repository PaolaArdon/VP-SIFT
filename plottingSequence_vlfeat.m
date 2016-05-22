function [Roc1, Roc2] = plottingSequence_vlfeat( path, sequence, setSize)

addpath([cd '/vlfeat-0.9.20/toolbox']);
vl_setup

load (path);

% Load the original image

FilePath = ['/SEQUENCE' num2str(sequence) '/Image_0a.png'];
Im_Or = imread( FilePath );

% Find the keypoints on the original image for the two subwindow size

[f1_1,d1_1] = vl_sift( im2single(rgb2gray(Im_Or)), 'WindowSize', 2 ) ;
[f1_2,d1_2] = vl_sift( im2single(rgb2gray(Im_Or)), 'WindowSize', 2.5 ) ;

% Initialization

cmap = hsv(8);
Roc1 = zeros(setSize,2,4);
Roc2 = zeros(setSize,2,4);
noises = ['a' 'b' 'c' 'd'];
figure;


for i = 1: 4 % For each noise
    for j = 1: setSize % For each different transformation
        
        % Load a image depending of its transformation and noise 
        
        Im = ['/SEQUENCE' num2str(sequence) '/Image_' num2str(j) noises(i) '.png'];
        Im = imread(Im);
        
        % Load the homogeinity matrix
        
        if sequence == 1
            Homo = Sequence1Homographies(j).H;
        elseif sequence == 2
            Homo = Sequence2Homographies(j).H;
        elseif sequence == 3
            Homo = Sequence3Homographies(j).H;
        end
        
        Roc1(j,1,i) = j;
        Roc2(j,1,i) = j;
        
        % Find the keypoints on the transformed image for both subwindow size
        
        [f2_1,d2_1] = vl_sift( im2single(rgb2gray(Im)), 'WindowSize', 2 );
        [f2_2,d2_2] = vl_sift( im2single(rgb2gray(Im)), 'WindowSize', 2.5 ) ;
        
        % Find matches between keypoints for both subwindow size
        
        [Matches_1, ~] = vl_ubcmatch(d1_1,d2_1);
        [Matches_2, ~] = vl_ubcmatch(d1_2,d2_2) ;
        
        % Get the index of the matches 
        
        mx1 = Matches_1(1,:);
        my1 = Matches_1(2,:);
        
        mx2 = Matches_2(1,:);
        my2 = Matches_2(2,:);
        
        %Get the location of the keypoints for default subwindow size
        
        f1_match1 = [f1_1(1:2,mx1) ; ones(1,size(mx1,2))];
        f2_match1 = [f2_1(1:2,my1) ; ones(1,size(my1,2))];
        
        %Get the location of the keypoints for default subwindow size
        
        f1_match2 = [f1_2(1:2,mx2) ; ones(1,size(mx2,2))];
        f2_match2 = [f2_2(1:2,my2) ; ones(1,size(my2,2))];
        
        % Get the correspondances points , if sequence 1, normalize the
        % homogeinity matrix
        
        f2_H1 = Homo  * f1_match1;
        if sequence == 1
            for m =1:size(f2_H1,2)
                f2_H1(:,m) = f2_H1(:,m)/f2_H1(3,m);
            end
        end

        f2_H2 = Homo  * f1_match2;
        if sequence == 1
            for m =1:size(f2_H2,2)
                f2_H2(:,m) = f2_H2(:,m)/f2_H2(3,m);
            end 
        end
        
        % Get the distance differece
        
        Difference_1 = (f2_match1 - f2_H1 )';
        Test_1 = sqrt(sum(Difference_1.^2 ,2 ));
        
        Difference_2 = (f2_match2 - f2_H2 )';
        Test_2 = sqrt(sum(Difference_2.^2 ,2 ));
        
        % Get the correct matches
        
        Corrects_1 = nnz(Test_1 < 1 );
        Corrects_2 = nnz(Test_2 < 1 );
        
        % Convert to a ratio
        
        Roc1(j,2, i ) = Corrects_1 * 100  / size( Matches_1,2) ;
        Roc2(j,2, i ) = Corrects_2 * 100  / size( Matches_2,2) ;
        
        
    end

    plot( Roc1(:,1,i), Roc1(:,2,i), '-s','Color', cmap(i,:) ); hold on;
    plot( Roc2(:,1,i), Roc2(:,2,i), '-s','Color', cmap(i+4,:) ); hold on;
    
end

legend('Without noise-4x4','Without noise-5x5', 'Noise: std 3 -4x4','Noise: std 3 -5x5', 'Noise: std 6 -4x4','Noise: std 6 -5x5', 'Noise: std 18 -4x4','Noise: std 18 -5x5',  'Location', 'southwest');
title(['SEQUENCE 0' num2str(sequence) 'with a 5x5 subwindowing']);

ylabel('Correctly matched(%)');
ylim([0,100]);
hold off;




end