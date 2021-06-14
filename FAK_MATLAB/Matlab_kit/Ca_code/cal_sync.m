function [cvdata] = cal_sync(delta_chan_int)
%Creates a synchronization index of the roi based calcium data in order to
%identify different regions with a similar pattern of activity and quantify
%their synchrony. The approach is based on the instantaneous phase of the
%time series. 
%   

%Step1: Hilbert transformation of the matrix
A = delta_chan_int;
B = [];
Hilbertmat = [];
for i = 1:96
    B = hilbert(A(i,:));
    Hilbertmat(i,:) = B;
    i=i+1;
end
    
%Step2: Phase angles of the hilbert transformed matrix
C= [];
Phase = [];
for j = 1:96
    C = angle(Hilbertmat(j,:));
    Phase(j,:) = C;
    j=j+1;
end

%Step 3: Calculate absolute phasediff for pairwise channel ROIs and then calculate the circular variance of the distribution of that phase difference with a nested for loop
D = [];
E = [];
F = [];
for l = 1:96
    for m = 1:96
    D = abs((Phase(l,:)-Phase(m,:)));
    E = circ_var(D');
    F(l,m) = E;
    m=m+1;
    end
    l=l+1;
end

cvdata =F;
end

