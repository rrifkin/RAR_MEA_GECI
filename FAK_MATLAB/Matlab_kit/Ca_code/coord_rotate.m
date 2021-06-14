function [outputArg1,outputArg2] = coord_rotate(inputArg1,inputArg2)
%coord_rotate (UNIFNISHED)
%  Rotates the coordinates of interest from the unrotated picture, so they can apply to the rotated picture. 

P = [5;8];    % coordinates of point
alpha = 45;   % angle for rotation
RotatedIm = imrotate(im,alpha);   % rotation of the main image (im)
RotMatrix = [cosd(alpha) -sind(alpha); sind(alpha) cosd(alpha)]; 
ImCenterA = (size(im)/2)';         % Center of the main image
ImCenterB = (size(RotatedIm )/2)';  % Center of the transformed image
RotatedP = RotMatrix*(P-ImCenterA)+ImCenterB;


end

