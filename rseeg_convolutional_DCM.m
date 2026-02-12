function DCM = rseeg_convolutional_DCM(directory, mri_dir, subject)

% Observation modesl (cross spectral density) for resting EEG

filename = fullfile(directory,...
        ['SPM_sub-',sprintf('%02d',subject),'_',...
        'ses-01_epoch-01_converted_data_ctbs.mat']);


output_folder = [directory '\DCM_file_CMC'];
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

D = rseeg_source_reconstruction(filename, mri_dir, subject);


% Data filename
%--------------------------------------------------------------------------
DCM = struct();
%DCM.xY.Dfile    = ['SPM_sub-',sprintf('%02d',subject),'_',...
%        'converted_data.mat'];

DCM.xY.Dfile    = filename;
DCM.name        = ['DCM_cmc_',sprintf('%02d',subject)];
% Parameters and options used for setting up model
%--------------------------------------------------------------------------
DCM.options.analysis = 'CSD'; 
DCM.options.model    = 'CMC'; % Neuronal model
DCM.options.trials   = 1; 
DCM.options.Tdcm(1)  = 0;     % start of peri-stimulus time to be modelled
DCM.options.Tdcm(2)  = 2000;  % end of peri-stimulus time to be modelled    % [start endtime] 
DCM.options.Fdcm(1)  = 1;
DCM.options.Fdcm(2)  = 40;    % frequency range 
DCM.options.Nmodes   = 8;     %> nr of modes for data selection 
DCM.options.h        = 1;     % nr of DCT components
DCM.options.D        = 1;     % downsampling
DCM.options.spatial  = 'IMG'; % spatial model


% Data and spatial model
%----------------------------------------------------------------------
DCM  = spm_dcm_erp_data(DCM);
%DCM = spm_dcm_csd_data(DCM);

% Location priors for dipoles
%--------------------------------------------------------------------------
DCM.Lpos  = [[-46; -66; 30] [49; -63; 33] [0; -58; 0] [-1; 54; 27]];
DCM.Sname = {'left LP', 'right LP', 'Precuneus', 'medial PFC'};


% Spatial model
%--------------------------------------------------------------------------
%DCM.M.dipfit.model = 'CMM_NMDA'; %% specific the 'CMM models'
%DCM.M.dipfit.type  = 'IMG'; %%% 'IMG' forward model 
%DCM.M.nograph=1;%% supress visual feedback during model fitting
DCM = spm_dcm_erp_dipfit(DCM);


% Specify connectivity model
%--------------------------------------------------------------------------
% A Matrix: Forward connections
DCM.A{1} = [
%    lLP   rLP  PrCu mPFC
    [  1    1    1    1  ];   % lLP
    [  1    1    1    1  ];   % rLP
    [  1    1    1    1  ];   % PrCu
    [  1    1    1    1  ];   % mPFC    
];

% A Matrix: Backward connections
DCM.A{2} = [
%    lLP   rLP  PrCu mPFC
    [  1    1    1    1  ];   % lLP
    [  1    1    1    1  ];   % rLP
    [  1    1    1    1  ];   % PrCu
    [  1    1    1    1  ];   % mPFC    
];

% A Modulatory
DCM.A{3} = [
%    lLP   rLP  PrCu mPFC
    [  0    0    0    0  ];   % lLP
    [  0    0    0    0  ];   % rLP
    [  0    0    0    0  ];   % PrCu
    [  0    0    0    0  ];   % mPFC    
];

% B Matrix
DCM.B = {};

% C Matrix: Driving inputs
DCM.C = [];

% Between trial effects
%--------------------------------------------------------------------------
% Only one trial
xU.name = '';
xU.X = [];    %'design matrix' 
DCM.xU = xU; 


%[pE,pC]  = spm_dcm_neural_priors(DCM.A,DCM.B,DCM.C,DCM.options.model);
%DCM.M.pE = pE;
%DCM.M.pC = pC;

%[pE,pC] = spm_cmm_NMDA_priors(DCM.A,DCM.B,DCM.C);
%DCM.M.pE = pE; % prior
%DCM.M.pC = pC; % prior covarience

%[DCM.M.pE,DCM.M.pC] = spm_L_priors(DCM.M.dipfit,pE,pC);
%DCM.M.pE.G = sparse(length(DCM.Sname),10);
%DCM.M.pC.G = sparse(length(DCM.Sname),10)+1/8;


% DCM fitting
% -----------------------------------------------------------------------
DCM = spm_dcm_csd_data(DCM); % Estimating cross-spectral data
DCM = spm_dcm_csd(DCM);

%save("DCM_cmmNMDA_01.mat", "DCM")
dcm_filename = fullfile(output_folder,...
    ['DCM_CMC_',sprintf('%02d',subject),'.mat']);

save(dcm_filename, "DCM");

end