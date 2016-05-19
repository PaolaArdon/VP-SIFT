function [ ratio ] = brisk_surf_freak( I_1, I_2, homography, type)
%match_FREAK Summary of this function goes here

    I_1 = rgb2gray(imread(I_1));
    I_2 = rgb2gray(imread(I_2));

    if strcmp(type, 'BRISK')
        
        points_1 = detectBRISKFeatures(I_1);
        points_2 = detectBRISKFeatures(I_2);
        
    elseif strcmp(type, 'FREAK')
        
        points_1 = detectFASTFeatures(I_1);
        points_2 = detectFASTFeatures(I_2);
        
    elseif strcmp(type, 'SURF')
        
        points_1 = detectSURFFeatures(I_1);
        points_2 = detectSURFFeatures(I_2);
        
    end

    [features_1, valid_points_1] = extractFeatures(I_1, points_1);
    [features_2, valid_points_2] = extractFeatures(I_2, points_2);

    % match the features
    index_pairs = matchFeatures(features_1, features_2);

    % get the location of the matched descriptors according to the index pairs
    matched_points_1 = valid_points_1(index_pairs(1: end, 1));
    matched_points_2 = valid_points_2(index_pairs(1: end, 2));

    %{
    figure;
    showMatchedFeatures(I_1, I_2, matched_points_1, matched_points_2, 'montage');
    title('Candidate point matches');
    legend('Matched points 1', 'Matched points 2');
    %}

    p_original_arr = matched_points_1.Location;
    l_final_arr    = matched_points_2.Location;

    ratio = 0;

    for i = 1: size(p_original_arr, 1);

        p_original = p_original_arr(i, :);
        p_final    = homography * [p_original_arr(i, :) 1]';
        p_final    = p_final / p_final(3);

        l_final    = [l_final_arr(i, 1); l_final_arr(i, 2); 1];
        
        % check the distnace between points
        if sqrt((p_final(1) - l_final(1))^2 + (p_final(2) - l_final(2))^2) <= 1.0

            ratio = ratio + 1;

        end

    end

    ratio = ratio * 100 / size(p_original_arr, 1);
end

