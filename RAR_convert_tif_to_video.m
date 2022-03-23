function RAR_convert_tif_to_video (filename)

	[X,map] = imread (filename);
	imshow(X,map);
	imcontrast

end