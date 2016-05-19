function [time] = plottingSequence( path, sequence, setSize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 load(path);
    noises = ['a' 'b' 'c' 'd'];
    results = [1: setSize];    
    time = [];
    for i = 1: 4
        ratio = [];
        for j = 1: setSize
            image1 = [pwd '/SEQUENCE' num2str(sequence) '/Image_0a.png'];
            image2 = [pwd '/SEQUENCE' num2str(sequence) '/Image_' num2str(j) noises(i) '.png'];

            tic
                       
            if sequence == 1
                [num, ratio] = match(image1, image2, Sequence1Homographies(j).H);
            elseif sequence == 2
                [num, ratio] = match(image1, image2, Sequence2Homographies(j).H);
            elseif sequence == 3
                [num, ratio] = match(image1, image2, Sequence3Homographies(j).H);
            end                
                    
            elapsed_time = toc;           
            time = [time elapsed_time];            
            ratio = [ratio ratio];
        end            
        time = [time;];
        display(results);
        display(ratio)
        results = [results; ratio];
    end
    figure;hold on;
    axis([results(1, 1) results(1, end) 0 100]);

    plot(results(1, :), results(2, :), 'y*-','LineWidth',5);
    plot(results(1, :), results(3, :), 'm*-','LineWidth',5);
    plot(results(1, :), results(4, :), 'c*-','LineWidth',5);
    plot(results(1, :), results(5, :), 'r*-','LineWidth',5);

    title(['SEQUENCE 0' num2str(sequence)]);
    legend('Without Noise', 'Gaussian Noise with 3 Grayscale', 'Gaussian Noise with 6 Grayscale', 'Gaussian Noise with 18 Grayscale', 'Location', 'southwest');

end

