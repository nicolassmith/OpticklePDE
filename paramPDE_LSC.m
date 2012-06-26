function par = paramPDE_LSC(par)

%Procedure to find the correct phases
% Set all phases to 0
% run sweepSetup.m
% run getDemodPhases
% copy output from getDemodPhase to here

par.phase.REFL = 144;
par.phase.AS =  24.2208;
par.phase.HOM = 0;
par.phase.HOM1 = 0;
par.phase.HOM2 =0;
