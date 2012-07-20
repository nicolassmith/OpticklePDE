% Optickle Simulation of Double Optical Spring

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')

% set laser powers
Pc = 4;
Ps = 0*Pc/20;

% set detunings
deltac = 2.7;
%deltas = -.3;

% this creates opt and par (setupPDE)
par = paramPDE([],Pc);
par = paramPDE_LSC(par);
% hack in a different vFrf and vArf

c = 299792458;
fGamma = c*par.IX.T/(8*pi*par.Length.Xarm);

%fSubcarrier = (deltas-deltac)*fGamma;
fSubcarrier = par.ITM.w_internal/(2*pi);

par.PSL.vFrf = [par.PSL.vFrf;fSubcarrier;-fSubcarrier];
par.PSL.vArf = [par.PSL.vArf;sqrt(Ps);0];

% choose mod depth
modGamma = 0.0004;

% make opt
opt = optPDE(par,RFmodulator('armMod',fSubcarrier,1i*modGamma));
opt = probesPDE(opt,par);

% set detuning
pos = zeros(1,opt.Ndrive);

fdelta = deltac*fGamma; %detuning

pos(getDriveNum(opt,'EX')) = -fdelta/c*(opt.lambda*par.Length.Xarm); %detuning of EX in meters

% tickle
f = logspace(log10(500)*0-1,4,500).';

[fDC, sigDC, sigAC, mMech] = tickle(opt, pos, f);

respOptic = 'EX';

nOpt = getDriveNum(opt,respOptic);
Opt = getOptic(opt,respOptic);

springTF = getTF(mMech,nOpt,nOpt).*squeeze(freqresp(Opt.mechTF,2*pi*f));

subplot(2,1,1)
loglog(f,abs(springTF))
xlim([min(f) max(f)])
grid on
subplot(2,1,2)
semilogx(f,180/pi*angle(springTF))
xlim([min(f) max(f)])
ylim([-180 180])
grid on

% evaluate modulation deph in terms of meters
disp(['Modulation = ' num2str(modGamma*opt.lambda/(4*pi)) 'm'])