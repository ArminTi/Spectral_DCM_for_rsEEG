function spm_data = rseeg_pipline(DIRECTORY, sub)

clc

ft_defaults

for subject = sub

    % generate filename
    filename = fullfile(DIRECTORY,...
        ['sub-',sprintf('%02d',subject),'_',...
        'raw_sess3.mat']);
    
    % load source data
    load(filename);

    % line noise removal and filtering 
    preproc_resam = rseeg_preprocess(data);
    
    % segment the data into trials
    segment_data = rseeg_segment(preproc_resam);
    
    % visual inspection and trial/channel rejection
    reject = rseeg_cleaning(segment_data);
    
    % interpolate removed channels
    interp  = rseeg_interp(reject,segment_data);
    
    % ICA cleaning
    comps   = rseeg_ica(interp);
    
    % inspect ica components for rejection - addpath for icacheck
    icacheck   = rseeg_inspectica(comps);
    
    % reject ica components
    postica = rseeg_rejectica(interp,icacheck);
    
    % rereferencing to common average and final checking
    reref   = rseeg_reref(postica);
    save('sub-22.mat', 'reref');
    
    % convert to spm data
    spm_data = rseeg_spmload(subject, reref);
end  

end

