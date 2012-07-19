% Optickle Simulation of Double Optical Spring

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')

% set laser powers
Pc = 4;
Ps = Pc/20;

% set detunings
deltac = 0.5;
deltas = 0;

% this creates opt and par (setupPDE)
par = paramPDE([],Pc);
par = paramPDE_LSC(par);
% hack in a different vFrf and vArf

c = 299792458;
fGamma = c*par.IX.T/(8*pi*par.Length.Xarm);

fSubcarrier = (deltas-deltac)*fGamma;

par.PSL.vFrf = [par.PSL.vFrf;fSubcarrier;-fSubcarrier];
par.PSL.vArf = [par.PSL.vArf;sqrt(Ps);0];

% make opt
opt = optPDE(par);
opt = probesPDE(opt,par);

% set detuning
pos = zeros(1,opt.Ndrive);

fdelta = deltac*fGamma; %detuning

pos(getDriveNum(opt,'EX')) = -fdelta/c*(opt.lambda*par.Length.Xarm); %detuning of EX in meters

% tickle
f = logspace(log10(500),4,500).';

[fDC, sigDC, sigAC, mMech] = tickle(opt, pos, f);

nEX = getDriveNum(opt,'EX');

springTF = -getTF(mMech,nEX,nEX)./(f.^2);

subplot(2,1,1)
loglog(f,abs(springTF))
xlim([min(f) max(f)])
grid on
subplot(2,1,2)
semilogx(f,180/pi*angle(springTF))
xlim([min(f) max(f)])
ylim([-180 180])
grid on