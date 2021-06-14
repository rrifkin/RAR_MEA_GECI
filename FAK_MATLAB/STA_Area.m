
in_input = in_t3s3;
pc_input = pc_t3s3;

x1 = (-50:50)/50;
y1 = [1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1];
x_sub = x1((x1 >= 0 & x1 <= .2));
y_sub = y1((x1 >= 0 & x1 <= .2));

for c = 1:96
    n = 1;
    for i = in_input
        [response, timing] = extract_spks(round(merged.units(i).times*50),calcium_resampled(c,:),-50:50);
        response_temp = mean(response);
        y2 = response_temp(x1 >= 0 & x1 <= .2);
        x2 = x1((x1 >= 0 & x1 <= .2));
        a_in(c,n) = trapz(x2,y2)-trapz(x_sub,y_sub);
        n = n + 1;
    end
    
    clear i n response response_temp timing
    
    n = 1;
    for i = pc_input
        [response, timing] = extract_spks(round(merged.units(i).times*50),calcium_resampled(c,:),-50:50);
        response_temp = mean(response);
        y2 = response_temp(x1 >= 0 & x1 <= .2);
        x2 = x1((x1 >= 0 & x1 <= .2));
        a_pc(c,n) = trapz(x2,y2)-trapz(x_sub,y_sub);
        n = n + 1;
    end
end

for j = 1:length(in_input);
    in_mean_all_chans(1,j) = mean(a_in(:,j));
    in_sum_all_chans(1,j) = sum(a_in(:,j));
end

clear j

for j = 1:length(pc_input);
    pc_mean_all_chans(1,j) = mean(a_pc(:,j));
    pc_sum_all_chans(1,j) = sum(a_pc:,j));
end

total_in_mean = length(find(in_mean_all_chans < 0));
total_pc_mean = length(find(pc_mean_all_chans < 0));

pop_diff = mean(mean(a_pc,2) - mean(a_in,2));

clear c n i j response response_temp timing 
    

