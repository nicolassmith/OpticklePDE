% Optickle Simulation of Double Optical Spring

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')

% set laser powers
Pc = 4;
Ps = 0;

% set detunings
deltac = 14.1552;
%deltas = -.3;

% this creates opt and par (setupPDE)
par = paramPDE([],Pc);
par = paramPDE_LSC(par);
% hack in a different vFrf and vArf

c = 299792458;
fGamma = c*par.IX.T/(8*pi*par.Length.Xarm);

%fSubcarrier = (deltas-deltac)*fGamma;
fSubcarrier = par.ETM.w_internal/(2*pi);

par.PSL.vFrf = [par.PSL.vFrf;fSubcarrier;-fSubcarrier];
par.PSL.vArf = [par.PSL.vArf;sqrt(Ps);0];

% choose mod depth
modGamma = 10e-5;

% make opt
opt = optPDE(par,RFmodulator('armMod',fSubcarrier,1i*modGamma));
opt = probesPDE(opt,par);

% add probe for SB signal in trans

opt = addProbeIn(opt,'X_TRANS_SB_I','X_TRANS','in',fSubcarrier,0);
opt = addProbeIn(opt,'X_TRANS_SB_Q','X_TRANS','in',fSubcarrier,90);

% set detuning
pos = zeros(1,opt.Ndrive);

fdelta = deltac*fGamma; %detuning

pos(getDriveNum(opt,'EX')) = -fdelta/c*(opt.lambda*par.Length.Xarm); %detuning of EX in meters

% tickle
f = logspace(2,3,500).';

[fDC, sigDC, sigAC, mMech] = tickle(opt, pos, f);

respOptic = 'EX';

nOpt = getDriveNum(opt,respOptic);
Opt = getOptic(opt,respOptic);

springTF = getTF(mMech,nOpt,nOpt).*squeeze(freqresp(Opt.mechTF,2*pi*f));

subplot(2,1,1)
loglog(f,abs(springTF))
xlim([min(f) max(f)])
grid on
title('ETM radiation pressure modified mechanical response')
ylabel('Magnitude (m/N)')
subplot(2,1,2)
semilogx(f,180/pi*unwrap(angle(springTF)))
xlim([min(f) max(f)])
ylim([-200 200])
grid on
ylabel('Phase (deg)')
xlabel('Frequency (Hz)')

% evaluate modulation deph in terms of meters
disp(['Modulation = ' num2str(modGamma*opt.lambda/(4*pi)) 'm'])

% evaluate the size of the signal at the mod frequency in transmission
nTransDC = getProbeNum(opt,'X_TRANS_DC');
nTransSBI = getProbeNum(opt,'X_TRANS_SB_I');
nTransSBQ = getProbeNum(opt,'X_TRANS_SB_Q');
transMod = sqrt(sigDC(nTransSBI)^2+sigDC(nTransSBQ)^2)/sigDC(nTransDC);

disp(['Transmission signal (RIN) = ' num2str(transMod)])