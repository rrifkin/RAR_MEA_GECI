function SEM = RAR_sem (data)

	SEM = std(data,'omitnan')/sqrt(length(data));   

end