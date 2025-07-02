% MATLAB Version: 2021b
%
% **Note:** 
% - The dataset 'pv_ds.mat' could be constructed fisrt using 'gene_pv_ds.m'
% - The dataset 'pv_ds.mat' and the decoding function 'mydecode.m'
%   must be placed in the current folder before running 'main.m' script.
%
% This 'main.m' script is an implementation of Algorithm 2. It generates a list of 
% corresponding parameter vectors (cp_list) based on input values of 'f' 
% (fundamental frequency) and 'delta' (velocity difference). The parameter 
% vectors can be used to generate vibration acceleration profiles with a velocity
% difference close to 'delta'.
%
% - 'pv_ds.mat' is a dataset constructed by Algorithm 1. It has a size of
%   42,467,328 × 2, where:
%   - The first column contains velocity differences (stored as single precision).
%   - The second column contains integers representing eight amplitude and
%     initial phase parameters, which correspond to the velocity differences
%     in the first column. These integers are compressed using an index-based encoding.
%   - The dataset has been sorted in ascending order based on velocity differences
%     for easier searching and usage.
%
% - 'gene_pv_ds.m' is an implementation of Algorithm 1 for constructing the 'pv_ds.mat'. 
%   It systematically varies the amplitude and initial phase parameters, computes
%   the velocity difference for each combination, and finally encodes each
%   parameter vector into a compressed integer format. The results are then stored 
%   in 'pv_ds.mat'
%
% - 'myencode.m' is the encoding function that compresses eight amplitude
%   and initial phase parameters into a single integer, which is stored in 'pv_ds.mat'.
%
% - 'mydecode.m' is the decoding function used to extract the eight amplitude
%   and initial phase parameters from the compressed indices stored in 'pv_ds.mat'.

% Input Parameters
f0 = 75;            % Fundamental frequency (Hz)
delta = -30e-3;     % Velocity difference (m/s)

% Output: cp_list (list of corresponding parameter vectors)

% Configurable Parameters
delta_max = 40e-3;     % Maximum velocity difference (m/s)
max_num_cpv = 50;      % Maximum number of corresponding parameter vectors

% Initialization
cp_list = zeros(max_num_cpv, 9); % Initialize parameter vector list
delta_max = delta_max * (f0 / 75); % Scale based on frequency
delta = delta * (f0 / 75);
delta_max_0 = 2.8111e-3; % Maximum velocity difference when f = 75 Hz and k = 1 (m/s)
k = delta_max / delta_max_0; % Scaling factor

% Load precomputed parameter-velocity difference dataset
load("pv_ds.mat"); % The dataset is sorted in ascending order by velocity difference

% Binary Search for 'cp_list'
target = delta / k; % Target velocity difference (normalized)
idx = find(pv_ds(:, 1) >= floor(target * 1e5) / 1e5, 1, 'first');
window_size = max_num_cpv * 2; % Extend window size to ensure sufficient candidates
start_idx = max(1, idx - window_size);
end_idx = min(size(pv_ds, 1), idx + window_size);
candidates = pv_ds(start_idx:end_idx, :);
diff_candidates = abs(k * candidates(:, 1) - delta);
[~, sorted_indices] = sort(diff_candidates);
selected_indices = sorted_indices(1:min(max_num_cpv, numel(sorted_indices)));% Select the top-N closest candidates
for i = 1:length(selected_indices)
    pv = mydecode(candidates(selected_indices(i), 2)); % Decode parameter vector
    cp_list(i, :) = [f0, k * pv(1:4), pv(5:end)];
end

%% (An example ) Generate acceleration profiles using the above generated cp_list
%**Note:** each line in the figure indicate an acceleration profile with the velocity
% difference 'delta'

vds = zeros(size(cp_list,1),1); % Store velocity differences for verification
fs = 48000; % sampling frequency (Hz)
t = 0:1/fs:1; % time vector (s)
figure;
hold on;
set(gca, 'FontSize', 10, 'FontName', 'Arial');
ax = gca;
ax.XLim = [0.2, 0.3];
ax.XTick = 0.2:0.02:0.3;
ax.YTick = -100:25:100;
ax.YLim = [-100 100];
box on
grid on;
ax.GridColor = [0.7, 0.7, 0.7];
ax.GridLineStyle = '-';
ax.GridAlpha = 0.5; 
xlabel('Time [s]');
ylabel('Acceleration [m/s^2]');
[~,tt] = title(strcat("Acceleration profiles with f_0 = ",num2str(f0), "Hz, ", ...
    " \delta =" , num2str(delta*1e3), 'mm/s' ),...
    "**Note:** each line in the figure indicate an acceleration profile");
tt.FontAngle = 'italic';

for i = 1:size(cp_list, 1)
    % Extract parameters
    f02 = cp_list(i, 1);
    k_vals = cp_list(i, 2:5);
    p_vals = cp_list(i, 6:end);
    % Initialize waveforms
    a = zeros(size(t));
    v = zeros(size(t));
    x = zeros(size(t));
    % Compute acceleration and velocity waveforms
    for j = 1:length(k_vals)
        a = a + k_vals(j) * cos(2 * pi * j * f02 * t + p_vals(j));
        v = v + k_vals(j) * (2 * pi * j * f02)^-1 * sin(2 * pi * j * f02 * t + p_vals(j));
        x = x + k_vals(j) * -(2 * pi * j * f02)^-2 * cos(2 * pi * j * f02 * t + p_vals(j));
    end
    % Plot acceleration waveform
    plot(t,a); 
    
    % Compute velocity difference and store it
    vds(i) = abs(max(v)) - abs(min(v));
end

disp((min(vds)-delta)*1000)



