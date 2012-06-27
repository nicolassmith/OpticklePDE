function par = paramPDE(par,Pin)

%Constants
lambda = 1064e-9;
c = 299792458;

%Need to measure everything.

%% IFO Layout and parameters

lschnupp= 0.1; %from Sigg MM doc
lmean = (0.3+0.4)/2;   %made up
larm_asy = 0; 

par.Length.IX = lmean + lschnupp/2;
par.Length.IY = lmean - lschnupp/2;
par.Length.Xarm = 1 + larm_asy/2;
par.Length.Yarm = 1 -larm_asy/2;
par.Length.BS = 1; % distance from the modulator to the BS, adding 1 for now
% ROC (need to measure these), only needed for the angular stuff, not using
% currently
par.BS.ROC = Inf;
par.IX.ROC = 0.53;
par.IY.ROC = 0.53;
par.EX.ROC = 0.53;
par.EY.ROC = 0.53;

%Offsets
%Putting darm and carm on the etms and the mich offset on the itms
par.dDARM = 0;
par.dCARM = 0;
par.dMICH = 0;

par.BS.pos = par.dMICH;
par.IX.pos = 0;
par.IY.pos = 0;
par.EX.pos = par.dDARM + par.dCARM;
par.EY.pos = -par.dDARM + par.dCARM;

%% Optical parameters
%Going to put all the difference in finess onto the ITM transmission which
%is pretty much what happens anyway
%
bsmismatch = 0.01;
itmmismatch = 10e-6;
Titm = 800e-6;
Tetm = 3e-6;
par.BS.T = 0.5 - bsmismatch;
par.IX.T = Titm + itmmismatch/2;
par.IY.T = Titm - itmmismatch/2;
par.EX.T = Tetm;
par.EY.T = Tetm;

%AR reflectivities, setting to zero for the time being
par.IX.Rar = 0;
par.IY.Rar = 0;
par.EX.Rar = 0;
par.EY.Rar = 0;
par.BS.Rar = 0;

%Loss for each arm, all the loss will go into the etm
%Here simplifying contrast defect by assuming all due to loss mismatch
Letm = 10e-6;
Lmismatch = 30e-6;

par.BS.L = 0;
par.EX.L = Letm + Lmismatch/2;
par.EY.L = Letm - Lmismatch/2;
par.IX.L = 0;
par.IY.L = 0;

CDlossmismatch = 100e-6; %solved using contrast defect

%% Mirror Mechanical Parmeters -- Need to measure

%Longitudinal
par.ITM.w = 2*pi*0.7; %fix until we actually measure
par.IX.w = par.ITM.w;
par.IY.w = par.ITM.w;
par.BS.w = par.ITM.w;
par.ITM.w_internal = 2*pi*27.5e3;
par.IX.w_internal = par.ITM.w_internal;
par.IY.w_internal = par.ITM.w_internal;
par.BS.w_internal = par.ITM.w_internal;

par.ETM.w = 2*pi*10;
par.EX.w = par.ETM.w;
par.EY.w = par.ETM.w;
par.ETM.w_internal = 2*pi*140e3;
par.EX.w_internal = par.ETM.w_internal;
par.EY.w_internal = par.ETM.w_internal;

par.ITM.Q_pendulum = 1;
par.ITM.Q_internal = 1e6;
par.IX.Q_pendulum = par.ITM.Q_pendulum;
par.IY.Q_pendulum = par.ITM.Q_pendulum;
par.BS.Q_pendulum = par.ITM.Q_pendulum;
par.IX.Q_internal = par.ITM.Q_internal;
par.IY.Q_internal = par.ITM.Q_internal;
par.BS.Q_internal = par.ITM.Q_internal;

par.ETM.Q_pendulum = 1;
par.ETM.Q_internal = 1e6;
par.EX.Q_pendulum = par.ETM.Q_pendulum;
par.EY.Q_pendulum = par.ETM.Q_pendulum;
par.EX.Q_internal = par.ETM.Q_internal;
par.EY.Q_internal = par.ETM.Q_internal;

par.ITM.mass = .25;
par.ETM.mass = 10^-3;
par.ETM.massdiff = 0;
par.IX.mass = par.ITM.mass;
par.IY.mass = par.ITM.mass;
par.BS.mass = par.ITM.mass;
par.EX.mass = par.ETM.mass;
par.EY.mass = par.ETM.mass - par.ETM.massdiff;

par.ITM.mass_internal = par.ITM.mass;
par.ETM.mass_internal = par.ETM.mass;
par.IX.mass_internal = par.ITM.mass_internal;
par.IY.mass_internal = par.ITM.mass_internal;
par.BS.mass_internal = par.ITM.mass_internal;
par.EX.mass_internal = par.ETM.mass_internal;
par.EY.mass_internal = par.ETM.mass_internal - par.ETM.massdiff;

%Yaw
par.ITM.w_pit = 2*pi*1; %fix until we actually measure
par.IX.w_pit = par.ITM.w_pit;
par.IY.w_pit = par.ITM.w_pit;
par.BS.w_pit = par.ITM.w_pit;

par.ETM.w_pit = 2*pi*80;
par.EX.w_pit = par.ETM.w_pit;
par.EY.w_pit = par.ETM.w_pit;

%Yaw
par.ITM.w_yaw = 2*pi*0.7; %fix until we actually measure
par.IX.w_yaw = par.ITM.w_yaw;
par.IY.w_yaw = par.ITM.w_yaw;
par.BS.w_yaw = par.ITM.w_yaw;

par.ETM.w_yaw = 2*pi*40;
par.EX.w_yaw = par.ETM.w_yaw;
par.EX.w_yaw = par.ETM.w_yaw;

par.ITM.radius = 1.5*2.54*10^-2;           % test-mass radius
par.ITM.thickness = 1*2.54*10^-2;      % CHECK THIS test-mass thickness
par.ITM.moment = (3 * par.ITM.radius^2 + par.ITM.thickness^2) / 12;  % Calculate moment of inertia
par.IY.moment = par.ITM.moment;
par.IX.moment = par.ITM.moment;
par.BS.moment = par.ITM.moment;

par.ETM.radius = 0.25*2.54*10^-2;           % test-mass radius
par.ETM.thickness = 0.25*2.54*10^-2;      % CHECK THIS test-mass thickness
par.ETM.moment = (3 * par.ETM.radius^2 + par.ETM.thickness^2) / 12;  % Calculate moment of inertia
par.EX.moment = par.ETM.moment;
par.EY.moment = par.ETM.moment;



%% Basic Laser Parameters, Noise is calculated after TF of couplings

par.PSL.Pin = 4;
if nargin>1
    par.PSL.Pin = Pin;
end
par.PSL.Mod_f1 = 25e6;
par.PSL.Mod_order1 = 1; % ignore 2*w sidebands
par.PSL.Mod_g1 = 0.3; %we need to measure this sometime in one arm mode or with a detuned cavity.

% modulation vectors
par.PSL.Mod_vect1= (-par.PSL.Mod_order1:par.PSL.Mod_order1)';

par.PSL.vFrf = unique([par.PSL.Mod_vect1*par.PSL.Mod_f1]); %slightly more complicated than necessary if we want to add a second modulation freq

nCarrier = find(par.PSL.vFrf ==0, 1);
vArf = zeros(size(par.PSL.vFrf));
vArf(nCarrier) = sqrt(par.PSL.Pin);
par.PSL.vArf = vArf;
par.PSL.Power = par.PSL.Pin;
par.PSL.wavelength = lambda;












