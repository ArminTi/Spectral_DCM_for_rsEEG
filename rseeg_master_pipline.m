%% ========================================================================
% MASTER ANALYSIS PIPELINE for resting state EEG Processing 
% ========================================================================
%
%   Armin Toghi
%   Project: EEG Resting State Analysis Pipeline
%   Toolbox: 
%   SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
%   fieldtrip 
%   EEGLAB 
% ------------------------------------------------------------------------
% REQUIREMENTS:
%   - MATLAB R2019a or newer
%   - Required package added to MATLAB path
% ------------------------------------------------------------------------
% NOTE:
%   This script does NOT run all steps automatically. 
%   It executes ONE step at a time to prevent accidental overwriting.
%
% ========================================================================

clear
clc

%% Package Location
addpath C:/Users/ASUS/Desktop/Apps/fieldtrip-20231220
addpath C:/Users/ASUS/Desktop/Apps/fieldtrip-20231220/plotting
addpath C:/Users/ASUS/Desktop/Apps/auto-ica-checking
addpath C:/Users/ASUS/Desktop/Apps/fieldtrip-20231220/external/eeglab
addpath C:/Users/ASUS/Desktop/Apps/spm12
addpath 'D:\Package\connectivity_rsEEG\Previous_code'
%% Requirement

Datadir = 'D:\Package\connectivity_rsEEG\Previous_code\Pre_procc_data'; % specify your directory
MRI_dir = 'D:\Package\connectivity_rsEEG\Previous_code\Pre_procc_data';
subject = 01; % specify the subject or subject (e.g., 1:22)

%% PIPELINE CALL 

fprintf('\nSelect a pipeline step to implement:\n')

fprintf('   1 - Preprocessing and ICA\n')
fprintf('   2 - DCM under conductance-based neural mass model\n')
fprintf('   3 - DCM under convolutional-based neural mass model\n')
fprintf('   4 - Explained Variance\n')
fprintf('   5 - EC plots\n')

job = input('Enter the step number: ');



switch job
    case 1
        rseeg_pipline(Datadir, subject) % Preprocessing & ICA
    case 2
        rseeg_conductance_DCM(Datadir, MRI_dir, subject) % Conductance-based neural mass models
    case 3
        rseeg_convolutional_DCM(Datadir, MRI_dir, subject) % Convolutional-based neural mass models
end

fprintf('\n✓ Pipeline step completed successfully.\n')
fprintf('------------------------------------------------------------------\n');
