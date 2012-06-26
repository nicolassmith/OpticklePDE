function opt = optPDE(par)

%% Model and PSL

% create an empty model, with frequencies specified
opt = Optickle(par.PSL.vFrf);

% add a source, with RF amplitudes from param file
opt = addSource(opt, 'Laser', par.PSL.vArf);

% Laser amplitude and phase noise, use modulators
opt = addModulator(opt, 'AM', 1);
opt = addModulator(opt, 'PM', 1i);

% link, output of Laser is PM->out
opt = addLink(opt, 'Laser', 'out', 'AM', 'in', 0);
opt = addLink(opt, 'AM', 'out', 'PM', 'in', 0);

% Modulator and link
opt = addRFmodulator(opt, 'Mod1', par.PSL.Mod_f1, 1i * par.PSL.Mod_g1);
opt = addLink(opt,'PM','out','Mod1','in',2); % just chose 2m at random

%% Add IFO Optics

mirrorList = {'BS','IX','IY','EX','EY'};
MirrorPowerloss = 0; %single pass 

dampRes = [0.01 + 1i, 0.01 - 1i]; %simple initial TF, not worrying about Q, can add fitted one for more accuracy

% Add optics and set TF
for n = 1:length(mirrorList)
  name = mirrorList{n};
  p = par.(name);
  
  % add the mirror
  if strmatch(name,'BS')
    opt = addBeamSplitter(opt, name, 45, 1 / p.ROC, p.T, p.L, p.Rar, MirrorPowerloss);
    opt = setMechTF(opt,name,zpk([], -p.w * dampRes, 1 / p.mass),1);
    opt = setMechTF(opt,name,zpk([], -p.w_pit * dampRes, 1 / p.moment),2);
  else
    opt = addMirror(opt,name, 0,1/p.ROC,p.T,p.L,p.Rar,MirrorPowerloss);
    opt = setMechTF(opt,name,zpk([], -p.w * dampRes, 1 / p.mass),1);
    opt = setMechTF(opt,name,zpk([], -p.w_pit * dampRes, 1 / p.moment),2) ;   
  end
  
end
 
%Link from Mod1 to BS front output
opt = addLink(opt,'Mod1','out','BS','frA',par.Length.BS);

%link BS A-side outputs to IX and IY back inputs
opt = addLink(opt, 'BS', 'frA', 'IX', 'bk', par.Length.IY);
opt = addLink(opt, 'BS', 'bkA', 'IY', 'bk', par.Length.IX);

% link BS B-side inputs to and IX and IY back outputs
opt = addLink(opt, 'IX', 'bk', 'BS', 'frB', par.Length.IY);
opt = addLink(opt, 'IY', 'bk', 'BS', 'bkB', par.Length.IX);

%add arm links
opt = addLink(opt,'IX','fr','EX','fr',par.Length.Xarm);
opt = addLink(opt,'EX','fr','IX','fr',par.Length.Xarm);

opt = addLink(opt,'IY','fr','EY','fr',par.Length.Yarm);
opt = addLink(opt,'EY','fr','IY','fr',par.Length.Yarm);

%All Port information is contained in the probesPDE.m file 