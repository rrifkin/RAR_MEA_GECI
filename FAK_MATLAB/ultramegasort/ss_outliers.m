function spikes = ss_outliers(spikes, cutoff, reps)

% SS_OUTLIERS  K-means based outlier detection. (Adjusted from spiky, back
% into UMS, by Ed.)
%     SPIKES = SS_OUTLIERS(SPIKES) takes and returns a spike-sorting object
%     SPIKES.  It identifies likely outliers in the SPIKES.WAVEFORMS and moves
%     them from the (initially M x N) SPIKES.WAVEFORMS matrix to a (P x N)
%     SPIKES.OUTLIERS.WAVEFORMS (usually P << M), removing them the original
%     SPIKES.WAVEFORMS matrix.  If the SPIKES.OUTLIERS.WAVEFORMS matrix already
%     exists, new outliers are added to the existing matrix.
%
%     Outlier spike timestamps are recorded in SPIKES.OUTLIERS.SPIKETIMES
%     (these event times are removed from SPIKES.SPIKETIMES).  The cell matrix
%     SPIKES.OUTLIERS.WHY stores a string describing the reasons that the
%     corresponding waveforms was marked as an outlier.
% 
%     The SS_OUTLIERS function identifies outliers using an ad hoc heuristic
%     based on a k-means clustering; waveforms that end up very far from their 
%     assigned centroid are likely outliers.   The scale for this determination
%     comes from the average of the covariance matrices of each cluster (i.e.,
%     1/(N-1) times the (N x N) within-group sum of squares matrix).  We take
%     this as an approximation to the noise covariance in outlier-free clusters 
%     and note that if the noise were locally Gaussian, then the waveform Mahalanobis
%     distances to assigned cluster means should be roughly Chi^2 distributed
%     (actually, F-distributed but we ignore the refinement for now).
%     NOTE: Outliers damage the k-means solution; the clustering is not robust to
%            gross violations of its (local) Gaussian assumption.  Repeat clustering  
%            on the cleaned data will thus yield a new solution ... which might
%            uncover further outliers.  This function attempts 3 cluster/clean
%            iterations (rule of thumb; tradeoff btw cleaning and run-time),
%            although it stops after any iteration that does not find an outlier.
%
%     SPIKES = SS_OUTLIERS(SPIKES, CUTOFF) specifies the Chi^2 CDF cutoff.
%     The default value is (1 - 1/M), i.e., spikes with Mahalanobis distance
%     such that their Chi^2 are likely to appear less than once by chance are
%     treated as outliers.
%
%     SPIKES = SS_OUTLIERS(SPIKES, CUTOFF, REPS) performs REPS cluster/clean
%     iterations (default: 3).  To specify REPS while using the default CUTOFF,
%     pass in [] for the second argument.
%
%     NOTE: This function performs a k-means clustering and thus overwrites
%           existing k-means assignments in the SPIKES object.
%
% Last Modified: sbm, 10/03/03

%%%%% ARGUMENT CHECKING
if (~isfield(spikes, 'waveforms') || (size(spikes.waveforms, 1) < 1))
    error('SS:waveforms_undefined', 'The SS object does not contain any waveforms!');
end

d = diag(spikes.info.pca.s);
r = find( cumsum(d)/sum(d) >.95,1);
%waves = spikes.info.pca.scores(:,1:r);
waves = spikes.waveforms(:,:) * spikes.info.pca.v(:,1:r);


[M,N] = size(waves);
if ((nargin < 2) || isempty(cutoff))
    cutoff = (1 - (1/M));
end
if (nargin < 3)
    reps = 3;
end

% Initialize the outliers sub-structure
if (~isfield(spikes, 'outliers'))
    spikes.outliers.waveforms = [];
    spikes.outliers.spiketimes = [];
    spikes.outliers.unwrapped_times = [];
    spikes.outliers.trials = [];
    
    spikes.outliers.goodinds = (1:M)';  % We need these to re-insert the outlier 'cluster'
    spikes.outliers.badinds = [];      % into the waveforms matrix after sorting.
end

for cleaning = 1:reps   % Cluster/clean then rinse/repeat.  3 reps does a good job w/o taking too much time
    %%%%% PERFORM A K-MEANS CLUSTERING OF THE DATA
    opts.mse_converge = 0.001;        % rough clustering is fine
    opts.progress = 0;
    spikes = ss_kmeans(spikes, opts);
    
    %%%%% MAHALANOBIS DISTANCES:   (x - x_mean)' * S^-1 * (x - x_mean)
    vectors_to_centers = waves - spikes.info.kmeans.centroids(spikes.info.kmeans.assigns,:);
    mahaldists = sum((vectors_to_centers .* (spikes.info.kmeans.W \ vectors_to_centers')'), 2)';
    
    %%%%% SPLIT OFF OUTLIERS
    bad = find(mahaldists > chi2inv(cutoff, N));   % find putative outliers
    
    if (isempty(bad))
        break;              % didn't find anything ... no sense continuing
    else
        %%%%% ADD OUTLIERS TO SS OBJECT AND REMOVE FROM MAIN LIST
        spikes.outliers.waveforms = cat(1, spikes.outliers.waveforms, spikes.waveforms(bad,:));
        spikes.outliers.badinds = cat(1, spikes.outliers.badinds, spikes.outliers.goodinds(bad(:)));

        spikes.outliers.spiketimes = [spikes.outliers.spiketimes spikes.spiketimes(bad)];
        spikes.spiketimes(bad) = [];
        
        spikes.outliers.unwrapped_times = [spikes.outliers.unwrapped_times spikes.unwrapped_times(bad)];
        spikes.unwrapped_times(bad) = [];
        
        spikes.outliers.trials = [spikes.outliers.trials spikes.trials(bad)];
        spikes.trials(bad) = [];
        
        spikes.outliers.goodinds(bad) = [];
        spikes.waveforms(bad,:) = [];
        
        waves(bad,:) = [];
    end
end