function opt = probesPDE(opt, par)

%add sinks
%add probes
%phases are defined in the paramPDE_LSC.m



%% REFL Port
opt = addSink(opt,'aREFL',0.9); %this should be a function of the input power
opt = addSink(opt,'REFL');

opt = addLink(opt,'BS','frB','aREFL','in',3); %need to get the dist from BS to REFL
opt = addLink(opt,'aREFL','out','REFL','in',0.1);

%% Trans Ports
opt = addSink(opt, 'aX_TRANS',0.5);
opt = addSink(opt,'aY_TRANS',0.5);
opt = addSink(opt,'X_TRANS');
opt = addSink(opt,'Y_TRANS');

opt = addLink(opt,'EX','bk','aX_TRANS','in',1);
opt = addLink(opt,'EY','bk','aY_TRANS','in',1);
opt = addLink(opt,'aX_TRANS','out','X_TRANS','in',0.1);
opt = addLink(opt,'aY_TRANS','out','Y_TRANS','in',0.1);


%% AS Port All Distances wrong
% Homodyne split

opt = addMirror(opt, 'ASsplit', 45, 0, 0.05, 0, 0, 0);
opt = addMirror(opt,'HOM_BS',45,0,0.5,0,0,0); %Matt recommends mirrors not BS for this
opt = addSink(opt,'synHOM',0);
opt = addSink(opt,'HOM1');
opt = addSink(opt,'HOM2');
opt = addSink(opt,'aAS_RF',0.2);
opt = addSink(opt,'AS_RF');

opt = addLink(opt,'BS','bkB','ASsplit','fr',4); % 4 chosen randomly
opt = addLink(opt,'ASsplit','bk','aAS_RF','in',1);
opt = addLink(opt,'aAS_RF','out','AS_RF','in',0.1);
opt = addLink(opt,'ASsplit','fr','synHOM','in',0);
opt = addLink(opt,'synHOM','out','HOM_BS','fr',0.25);
opt = addLink(opt,'HOM_BS','fr','HOM1','in',0.25);
opt = addLink(opt,'HOM_BS','bk','HOM2','in',0.25);

%% Adding Probes
f_mod = par.PSL.Mod_f1;

%REFL

opt = addProbeIn(opt,'REFLDC','REFL','in',0,0);
opt = addProbeIn(opt,'REFL_I','REFL','in',f_mod,par.phase.REFL);
opt = addProbeIn(opt,'REFL_Q','REFL','in',f_mod,par.phase.REFL-90);

%AS
opt = addProbeIn(opt,'ASDC','AS_RF','in',0,0);
opt = addProbeIn(opt,'AS_I','AS_RF','in',f_mod,par.phase.AS);
opt = addProbeIn(opt,'AS_Q','AS_RF','in',f_mod,par.phase.AS+90);

%HOMODYNE, technically we need to set the HOMX_DC phase to be something
%since we are looking at a specific quadrature.
opt = addProbeIn(opt,'HOM1_DC','HOM1','in',0,0);
opt = addProbeIn(opt,'HOM1_I','HOM1','in',f_mod,par.phase.HOM1);
opt = addProbeIn(opt,'HOM1_Q','HOM1','in',f_mod,par.phase.HOM1+90);

opt = addProbeIn(opt,'HOM2_DC','HOM2','in',0,0);
opt = addProbeIn(opt,'HOM2_I','HOM2','in',f_mod,par.phase.HOM2);
opt = addProbeIn(opt,'HOM2_Q','HOM2','in',f_mod,par.phase.HOM2+90);

%Synthetic Homodyne
% We don't actually have to perform a homodyne readout in optickle since we
% are able to just look at the field at a specific location.  
% 
% opt = addProbeIn(opt,'synHOM_DC','synHOM','in',0,0);
% opt = addProbeIn(opt,'synHOM_amp','synHOM','in',0,par.phase.HOM);
% opt = addProbeIn(opt,'synHOM_ph','synHOM','in',0,par.phase.HOM+90);

%Trans
opt = addProbeIn(opt,'X_TRANS_DC','X_TRANS','in',0,0);
opt = addProbeIn(opt,'Y_TRANS_DC','Y_TRANS','in',0,0);










