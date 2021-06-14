
for i = 1:length(pc)
    b(i,:) = length(merged.units(pc(i)).times)/1800;
end

avg_b = mean(b);
