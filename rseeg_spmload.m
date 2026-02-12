
function [spm] = rseeg_spmload(subject, reref)

for i = 1:length(reref)
    n = length(reref(i).time); 
    %m = size(reref(1).time(1));
    
    % Initialize the output matrix
    new_times = {};
    
    % Normalize each epoch
    for j = 1:n
        new_times{j} = linspace(0, 2, 500);
    end
    
    spm(i) = reref(i);
    spm(i).time = new_times;
    
    %spm(i).hdr.chantype(63) = {'EEG'};
    %spm(i).hdr.chantype(64) = {'EEG'};
    %spm(i).hdr.chantype(65) = {'ECG'};
    %spm(i).hdr.chantype(66) = {'EOG'};
    %spm(i).hdr.chantype(67) = {'EOG'};
    %spm(i).hdr.chantype(68) = {'Marker'};
    %spm(i).hdr.chanunit(67) = {'uV'};
    %spm(i).hdr.chanunit() = {'V'};

    % Generate a unique filename for the SPM file (no extension)
    spm_filename = sprintf('sub-%02d_converted_data', subject);
    
    % Convert to SPM object and save
    spm_object = spm_eeg_ft2spm(spm(i), spm_filename);
    load(spm_filename)
    load("fid_default.mat")

    D.sensors = struct('eeg', reref.elec);
    D.fiducials = fid;
    save(spm_filename,'D')

end