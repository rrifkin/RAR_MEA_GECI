% Determines channels with specific LFP linelength for making excerpts

function RAR_linelength_heatmap (linelength_by_channels_file)

	% parameters
	clims = [0,2000]; %[400,600]; % lower and upper limits to which heatmap is scaled
	numticks = 6;
	colorbarticks = linspace(clims(1), clims(2), numticks);
	colorbarticklabels = string(colorbarticks); 
	fontsize = 30;
	colorbarstring = 'Line Length (µV/s)';
	colormapname = 'hot';

	channel_map = [-1,81,83,85,87,89,91,93,95,-1;
	94,96,65,67,69,71,73,75,77,79;
	74,76,78,80,82,84,86,88,90,92;
	53,55,57,59,61,63,66,68,70,72;
	33,35,37,39,41,43,45,47,49,51;
	46,48,50,52,54,56,58,60,62,64;
	25,27,29,31,34,36,38,40,42,44;
	5,7,9,11,13,15,17,19,21,23;
	18,20,22,24,26,28,30,32,1,3;
	-1,2,4,6,8,10,12,14,16,-1];
	
	heatmap = NaN(10,10);
	
	linelength_by_channels = readmatrix(linelength_by_channels_file);

	for i=1:size(linelength_by_channels,1)
		channel_number = linelength_by_channels(i,1);
		linelength = linelength_by_channels(i,2);
		[row, column] = find(channel_map == channel_number);
		heatmap(row, column) = linelength;
	end

	fig = figure;
	ax = axes(fig);
	colormap(colormapname);
	imagesc(heatmap, clims);
	c = colorbar('westoutside', 'Ticks',colorbarticks, 'TickLabels',colorbarticklabels,'FontSize',fontsize);
	c.Label.String = colorbarstring;
	fig.Visible = 'off';
	ax.Visible = 'off';

    % Output data to .csv file
    csv_file = strcat(linelength_by_channels_file(1:end-4), '_heatmap.csv');
	writematrix(heatmap, csv_file);

	% Output data to .pdf file
	pdf_file = strcat(linelength_by_channels_file(1:end-4), '_heatmap.pdf');
	print('-painters', '-dpdf', pdf_file);

end