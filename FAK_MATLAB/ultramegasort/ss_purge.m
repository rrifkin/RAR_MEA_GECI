function ss_purge(filename,fieldout,structname)
% Unlike other ss_* functions, takes a filename (assumes struct is called
% spikes - use 3rd input argument to specify otherwise).
% 1st arg: filename
% 2nd arg: name of field to split out to new file
% 3rd arg: [optional] name of spike struct ('spikes')
%
% E.M. Merricks

if nargin < 2 || isempty(fieldout) || isempty(filename)
    error('Incorrect inputs');
end

if nargin < 3 || isempty(structname)
    structname = 'spikes';
end

temp = load(filename);
if ~isfield(temp,structname)
    error(['No ' structname ' in ' filename]);
end
if ~isfield(temp.(structname),fieldout)
    error(['No ' fieldout ' in spike structure in ' filename])
end

spikes = temp.(structname).(fieldout);
[fp,fn,ex] = fileparts(filename);

save([fp filesep '.' fn '.' fieldout ex],'spikes');

temp.(structname) = rmfield(temp.(structname),fieldout);

save(filename,'-struct','temp');