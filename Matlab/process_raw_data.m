function [scaled_signal, Fs, tm] = process_raw_data(raw_data, Fs, baseline, gain)
    % process_raw_data: Scales raw input data using a single baseline and gain value.
    %
    % Inputs:
    %   raw_data - NxM matrix of raw data (N samples, M channels)
    %   Fs - Sampling frequency in Hz
    %   baseline - Single value for baseline offset
    %   gain - Single value for gain
    %
    % Outputs:
    %   scaled_signal - NxM matrix of scaled signal data
    %   Fs - Sampling frequency in Hz
    %   tm - Nx1 time vector

    % Validate input arguments
    if nargin < 3
        baseline = 0;  % Default baseline value
    end
    if nargin < 4
        gain = 1;  % Default gain value
    end
    i = 1;
    % Scale the raw data
    while(i<length(raw_data))
        scaled_signal (i)= (double(raw_data(i))- baseline)/gain;
        i = i+1;
    end

    % Generate time vector
    N = size(raw_data, 1);  % Number of samples
    tm = (0:N-1)' / Fs;

    % Output
    disp('Data scaled successfully.');
end
