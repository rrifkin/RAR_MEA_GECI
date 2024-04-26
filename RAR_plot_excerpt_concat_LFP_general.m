% plots a subset of channels, but over the entire length of multiple files
% for LFP only
% makes a 0.1 vertical_scale x 1 minute scale bar (intended to be 
% repositioned and labeled in a graphics program)
% 
% varargin = multiple .mat files in order
% channels = vector of channels to plot, e.g. 1:4 

function RAR_plot_excerpt_concat_LFP_general (channels, lines, seconds_per_inch, vertical_scale, varargin)

	% parameters
	% vertical_scale = 15000; % units per inch, e.g. 10,000 uV per inch
	sample_rate = 2000; % LFP usually downsampled to 2000 Hz
	offset = 0; % vertical offset, set to 0 for LFP
	% minutes_per_inch = 5; %10 % determines horizontal scale
	channels_per_inch = 5; % determines vertical increment
	vertical_increment = vertical_scale / channels_per_inch;
	pad = 0.25; % padding around axes in inches
	line_width = 0.5;

	colors = ["#EDB120", "#7E2F8E", "#77AC30", "#A2142F"];

	% Concatenate LFP data into a single array
	concatenated_LFP_data = [];
    for i = 1:numel(varargin)
		current_LFP_data = importdata(varargin{i});
		concatenated_LFP_data = [concatenated_LFP_data, current_LFP_data];
    end

    % Determine the final output PDF filename
    current_filename = varargin{1};
    PDF_filename = current_filename(1:end-4);
    for i = 2:numel(varargin)
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        split_products = split(current_filename, ",");
        current_suffix = char(split_products(end));
        PDF_filename = strcat(PDF_filename, "," , current_suffix);
    end
    
	str_channels = string(channels);
	str_channels = strjoin(str_channels,',');
	str_seconds_per_inch = string(seconds_per_inch);
	PDF_filename = strcat (PDF_filename, "_concat_excerpt_ch_", str_channels, "_", str_seconds_per_inch, "_seconds_per_inch.pdf");

	% Determine the length of the excerpted LFP data and make an array
	% representing each sample
	excerpt = concatenated_LFP_data(channels,:);
	[num_channels , num_samples] = size(excerpt);
	samples = [1:num_samples];

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% calculate x-axis properties
	seconds = num_samples / sample_rate;
	ax_width = seconds / seconds_per_inch; 

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment;
	y_maximum = (num_channels * vertical_increment);
	ax_height = num_channels / channels_per_inch ;

	% set x-axis properties
	ax.XLim =[0, num_samples];
	ax.XAxis.Visible = 'off';

	% set y-axis properties
	ax.YLim = [y_minimum,y_maximum];
	ax.YAxis.Visible = 'off';

	% set general axis properties
	ax.FontSize = 6;
	ax.Units = 'inches';
	ax.Position = [pad, pad, ax_width, ax_height]; % location of axes within figure, and size of axes

	% set figure properties
	fig.Visible = 'off';
	fig.Renderer = 'painters';
	fig.Units = 'inches'; 
	fig.Position = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure
	
	% set 'paper' properties
	fig.PaperPositionMode = 'manual';
	fig.PaperUnits = 'inches';
	fig.PaperPosition = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure within paper
	fig.PaperSize = [ax_width + (2 * pad), ax_height + (2 * pad)]; % size of paper

	hold (ax, 'on'); 

	% plot sequential traces in ascending order
	for index = 1:num_channels 
		y_offset = excerpt(index,:) + offset ;
		plot(samples, y_offset, 'LineWidth', line_width, 'Color', colors(index));
        offset = offset + vertical_increment;
    end

	% make scalebar
	vertical_scalebar = 0.1 * vertical_scale;
	line([0, (sample_rate * 60)],[0,0], 'Color', 'black');
	line([0, 0],[0, vertical_scalebar], 'Color', 'black');
	text(3 * sample_rate, 0.5 * vertical_increment, string(vertical_scalebar), 'FontSize', 5);
	text(3 * sample_rate, -0.5 * vertical_increment, '1 minute', 'FontSize', 5);

	% make drug lines
	line_height = y_maximum - 300;
	for index = 1:size(lines,1)
		line_name = lines{index,1};
		start_line = sample_rate * lines{index,2};
		stop_line = sample_rate * lines{index,3};
		line_length = stop_line - start_line;
		line_center = (0.5 * line_length) + start_line;
		line([start_line, stop_line],[line_height,line_height], 'Color', 'black');
		text(line_center, line_height + 250, line_name, 'FontSize', 5);
		line_height = line_height - 300;
	end

	hold (ax, 'off'); 

	print('-painters', '-dpdf', fig, PDF_filename);

end