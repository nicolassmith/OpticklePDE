%% setupPDE.m

par = paramPDE;
par = paramPDE_LSC(par);
opt = optPDE(par);
opt = probesPDE(opt,par);

