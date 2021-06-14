function RAR_show_tif (filename)

	[X,map] = imread (filename);
	imshow(X,map);
	imcontrast

end