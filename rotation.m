function [ Sequence3Homographies ] = rotation( Window, Im_Rot )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Index = 0;
  
 for Angle = -45 : 90/17 : 45
 
     Index = Index + 1;
     Window_Rot = imrotate(Window, Angle,'crop');
     %Im_Rot = Window_Rot(250:750, 750:1500, :);
     Im_Rot1  = imnoise(Im_Rot, 'gaussian', 0, (3 / 255) ^2 );
     Im_Rot2  = imnoise(Im_Rot, 'gaussian', 0, (6 / 255) ^2 );
     Im_Rot3  = imnoise(Im_Rot, 'gaussian', 0, (18 / 255) ^2 );
     Translation = [1, 0, -375 ;0, 1, -250;  0, 0, 1];
     Rotation = [cosd(Angle) -sind(Angle) 0 ; sind(Angle) cosd(Angle) 0; 0 0 1];
     H = inv(Translation) * Rotation * Translation;
     
     Sequence3Homographies(Index) = struct('H', H,'deg', Angle);    
end
save('Sequence3Homographies.mat','Sequence3Homographies');
end

