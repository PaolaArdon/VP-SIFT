close all, clear all 

Im_Init = imread('Image_base_050.jpg');
   
 Window = Im_Init(2000:3000, 1750:4000, :);

 Index = 0;
  
 for Angle = -45 : 90/17 : 45
 
     Index = Index + 1;
     Window_Rot = imrotate(Window, Angle,'crop');
     Im_Rot = Window_Rot(250:750, 750:1500, :);
     
     Im_Rot1  = imnoise(Im_Rot, 'gaussian', 0, (3 / 255) ^2 );
     Im_Rot2  = imnoise(Im_Rot, 'gaussian', 0, (6 / 255) ^2 );
     Im_Rot3  = imnoise(Im_Rot, 'gaussian', 0, (18 / 255) ^2 );
     
%      if( Index < 10 )
%         imwrite(Im_Rot,['SEQUENCE3/Image_0',num2str(Index),'a.png']);
%         imwrite(Im_Rot1,['SEQUENCE3/Image_0',num2str(Index),'b.png']);
%         imwrite(Im_Rot2,['SEQUENCE3/Image_0',num2str(Index),'c.png']);
%         imwrite(Im_Rot3,['SEQUENCE3/Image_0',num2str(Index),'d.png']);
%     
%     else
%         imwrite(Im_Rot,['SEQUENCE3/Image_',num2str(Index),'a.png']);
%         imwrite(Im_Rot1,['SEQUENCE3/Image_',num2str(Index),'b.png']);
%         imwrite(Im_Rot2,['SEQUENCE3/Image_',num2str(Index),'c.png']);
%         imwrite(Im_Rot3,['SEQUENCE3/Image_',num2str(Index),'d.png']);
%     end

    Translation = [1, 0, -375 ;0, 1, -250;  0, 0, 1];
    Rotation = [cosd(Angle) -sind(Angle) 0 ; sind(Angle) cosd(Angle) 0; 0 0 1];
    H = inv(Translation) * Rotation * Translation;
     
    Sequence3Homographies(Index) = struct('H', H,'deg', Angle);
    
end
save('Sequence3Homographies.mat','Sequence3Homographies');