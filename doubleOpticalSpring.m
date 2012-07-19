% Optickle Simulation of Double Optical Spring

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')

% set laser powers
Pc = 1;
Ps = Pc/20;

% this creates opt and par (setupPDE)
par = paramPDE([],Pc);
par = paramPDE_LSC(par);
% hack in a different vFrf and vArf

c = 299792458;
fGamma = c*par.IX.T/(8*pi*par.Length.Xarm);

fSubcarrier = 3.5*fGamma;

par.PSL.vFrf = [par.PSL.vFrf;fSubcarrier;-fSubcarrier];
par.PSL.vArf = [par.PSL.vArf;0;Ps];

% make opt
opt = optPDE(par);
opt = probesPDE(opt,par);
