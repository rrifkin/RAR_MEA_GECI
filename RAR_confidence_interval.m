function CI = RAR_confidence_interval (data)

	SEM = std(data)/sqrt(length(data));               
	ts = tinv([0.025  0.975],length(data)-1);      
	CI = mean(data) + ts*SEM;   

end