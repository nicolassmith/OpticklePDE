%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script prepares some variables for the sweep functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the model
setupPDE

% get the serial numbers of some optics
nBS = getDriveNum(opt, 'BS');
nIX = getDriveNum(opt, 'IX');
nIY = getDriveNum(opt, 'IY');
nEX = getDriveNum(opt, 'EX');
nEY = getDriveNum(opt, 'EY');

% serial #'s for laser noises
nAM = getDriveNum(opt,'AM');
nPM = getDriveNum(opt,'PM');

% probe names and numbers
% get some probe indexes

%RF
nREFL_I = getProbeNum(opt,'REFL_I');
nREFL_Q = getProbeNum(opt,'REFL_Q');
nAS_I = getProbeNum(opt,'AS_I');
nAS_Q = getProbeNum(opt,'AS_Q');

%DC
nASDC = getProbeNum(opt,'ASDC');
nREFLDC = getProbeNum(opt,'REFLDC');


