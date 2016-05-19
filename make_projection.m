function [I_proj, H] = make_projection(I, p, delta)
    % Calculate the warped points
    p_new = p + delta;
    
    % Calculate the transform
    H = fitgeotrans(p, p_new, 'projective');
    % Project I using the two transforms
    I_proj = imwarp(I, H);
            
    %figure, imshow(I_proj);
    
    % Crop images back to original size
    dx = max(delta(:,1));
    dy = max(delta(:,2));
    I_proj = I_proj(dy+1:dy+size(I,1), dx+1:dx+size(I,2), :);
    
    %figure, imshow(I_proj);
end