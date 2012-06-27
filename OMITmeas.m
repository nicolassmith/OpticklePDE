% Optickle Simulation of OMIT style measurement

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')


% this creates opt and par (setupPDE)
par = paramPDE([],1);
par = paramPDE_LSC(par);
opt = optPDE(par);
opt = probesPDE(opt,par);

% choose detuning

IX = getOptic(opt,'IX');
g = 1/(4*pi)*par.IX.T*opt.lambda/2; % detuning (in meters)

f_internal = par.IX.w_internal/(2*pi);
g_f = g*opt.c/(opt.lambda*par.Length.Xarm);

pos = zeros(1,opt.Ndrive);
delta = f_internal/g_f;
pos(getDriveNum(opt,'EX')) = delta*g; %detuning of EX
pos(getDriveNum(opt,'EY')) = delta*g; %detuning of EY

% calculate TFs
%f = logspace(4,log10(2e5),1000);
f = linspace(f_internal-5,f_internal+5,1000);
[fDC, sigDC, sigAC] = tickle(opt, pos, f);

% show results
showfDC(opt,fDC)

nPM = getDriveNum(opt,'PM');
nTransX = getProbeNum(opt,'X_TRANS_DC');

PMtoXTRANS = -getTF(sigAC,nTransX,nPM);

figure(1)
subplot(2,1,1)
semilogy(f,abs(PMtoXTRANS))
xlim([min(f) max(f)])
subplot(2,1,2)
plot(f,180/pi*angle(PMtoXTRANS))
xlim([min(f) max(f)])