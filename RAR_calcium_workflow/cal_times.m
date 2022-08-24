function [F,T] = cal_times(txtfile)
%UNTITLED Searches the metadata file to find the frame number and
%associated timestamps for further analysis.
%   Only input is the name of the text file.
F = [];
T = [];
%h = [];
fid = fopen(txtfile,'r');
      while ~feof(fid)
      st = fgetl(fid);           
       if  ~isempty(strfind(st,'"FrameIndex":'))
         stread = textscan(st,'%s %f');
          F = [F; stread{2}(1)];
       elseif  ~isempty(strfind(st,'"ElapsedTime-ms":'))
         stread = textscan(st,'%s %f');
          T = [T; stread{2}(1)];
       %elseif ~isempty(strfind(st,'EvtTime'))
        % stread = textscan(st,'%s %s');
         %h = [h; stread{2}{1}];
       end
      end
fclose(fid);
end

