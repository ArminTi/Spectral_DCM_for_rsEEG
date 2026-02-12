function [comps] = rseeg_ica(interp)

% Concatenate data structure to allow ICA
%ICA_data    = rseeg_icadata(interp); %if you have more than one session
ICA_data = interp;


% ICA
cfg         = [];
cfg.method  = 'runica';
cfg.channel = 1:91;

comps = ft_componentanalysis(cfg,ICA_data);
end