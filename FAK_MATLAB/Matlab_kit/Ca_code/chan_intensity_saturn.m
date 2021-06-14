function Z = chan_intensity_saturn(img,r,f,coord)
%chan_intensity_saturn calculates the average intensity of the pixels in a 
% circle of radius r, around the 96 microelectrodes of the Utah array for a
% calcium imaging video.
%
% For speed, it temporarily copies the tif stack to /scratch/global/ then
% deletes that copy once done. Clearly, this is only designed to be used on
% saturn2.
%
%   img     =   the image stack
%   r       =   radius
%   f       =   frame
%   coord   =   array of coordinates for the electrodes on the microarray 
%               with X and Y coordinates in columns 1 and 2 resepctively
%               (each channel is represented along the rows).

% Copy the image file to scratch space
[~,nm,ext] = fileparts(img);
oldImg = img;
img = ['/scratch/global/' nm ext];
[suc,msg] = copyfile(oldImg,img);
if ~suc
    disp(['Issue copying file:' 10 msg])
    disp([9 'Returning with no calculations done'])
    Z = [];
    return;
end

mask = cell(1,96);
Z = NaN(96,f);
% Loop over each channel on each frame, only building the mask on the first
% frame to save procesing time:
for i = 1:f
    X1 = imread(img,i);
    if i == 1
        [xgrid, ygrid] = meshgrid(1:size(X1,2), 1:size(X1,1));
    end
    for l = 1:96
        if i == 1
            mask{l} = ((xgrid-(coord(l,1))).^2 + (ygrid-(coord(l,2))).^2) <= r.^2;
        end
        Z(l,i) = nanmean(X1(mask{l}));
    end
end
% Delete the copy of the image from /scratch
if strcmp(img,['/scratch/global/' nm ext])
    delete(img);
else
    warning('Something weird happened with the copy to scratch, not risking deleting anything!')
end