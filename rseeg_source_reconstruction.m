function D = rseeg_source_reconstruction(filename, mri_dir, subject)

% Load data
D = spm_eeg_load(filename);

% Remove previous reconstructions
if isfield(D, 'inv')
    D = rmfield(D, 'inv');
end

% MRI
sMRI = fullfile(mri_dir,...
        ['sub-',sprintf('%02d',subject),'_T1.nii']);

% Reconstruction number
val = 1;
D.val = val;

% Normal mesh
Msize = 2;

% Create mesh
D.inv{val}.mesh = spm_eeg_inv_mesh(sMRI, Msize);

% Comment
D.inv{val}.comment = {'inversion_1'};

spm_eeg_inv_checkmeshes(D);

save(D);

% Fiducials
meeg_fid = D.fiducials;

% Registration
S = [];
S.sourcefid = meeg_fid;
S.targetfid = D.inv{val}.mesh.fid;
S.useheadshape = 1;
S.template = 0;

M1 = spm_eeg_inv_datareg(S);

% Data registration
D.inv{val}.datareg = struct([]);

D.inv{val}.datareg(1).sensors  = ft_transform_geometry(M1, D.sensors('EEG'));
D.inv{val}.datareg(1).fid_eeg  = ft_transform_geometry(M1, S.sourcefid);
D.inv{val}.datareg(1).fid_mri  = S.targetfid;
D.inv{val}.datareg(1).toMNI    = D.inv{val}.mesh.Affine;
D.inv{val}.datareg(1).fromMNI  = inv(D.inv{val}.datareg(1).toMNI);
D.inv{val}.datareg(1).modality = 'EEG';

spm_eeg_inv_checkdatareg(D);

% Forward model
D.inv{val}.forward(1).voltype = 'EEG BEM';

D = spm_eeg_inv_forward(D, val);
spm_eeg_inv_checkforward(D, val);

D.save;

end
