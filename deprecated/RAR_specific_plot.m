	% plot
	plot(Times_sec, final_product);
	xlim([1200 1300]);
	ylim([1 2]);
	y = 1.8;
	line([901,1800],[y,y]);
	saveas(gcf,'slice3_1200-1300seconds.pdf')