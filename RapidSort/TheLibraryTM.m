function spikes = TheLibraryTM(spikes, varargin)
%   second optional argument is a number to override the default Z
%   threshold of 1.5

try
    parpool; % Initialize the parallel pool
catch
end


disp('Starting TheLibraryTM...')
f = load('mu_sd_waveform_bank.mat');
allMu = f.allMu;
allSD = f.allSD;


% Create a DataQueue object
progressQueue = parallel.pool.DataQueue();


% Define a listener function to display progress
n = length(spikes);
counter = 0;
afterEach(progressQueue, @(~) updateProgress());

% Update progress function
function updateProgress()
    counter = counter + 1;
    fprintf('Completed: %d/%d\n', counter, n);
end

parfor p = 1:n
    spikes(p).waveforms;
    if isempty(spikes(p).waveforms)
        spikes(p).worstZS = [];
    else
        spikes(p).worstZS = TheLibrary_SingleMatrix(spikes(p).waveforms, allMu, allSD);
    end

    send(progressQueue, p); % Send a signal to the DataQueue
end


%%% ----- Iterate through spikes and flag waves above a certain Z score cutoff

if nargin > 1
    Z_thresh = varargin{1};
    disp(['Using specified Z threshold of ' num2str(Z_thresh)])
else 
    disp('No Z threshold specified. Defaulting to 1.5 SD.')
    Z_thresh = 1.5;
end

for p = 1:n
    if isempty(spikes(p).worstZS)
        spikes(p).badZS = [];
    else
        spikes(p).badZS = find(spikes(p).worstZS > Z_thresh);
    end

end



delete(gcp('nocreate')); % Close the parallel pool

end




