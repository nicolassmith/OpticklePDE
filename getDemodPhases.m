% Measure Sensing Matrix at 1 frequency to set demod phases

sweepSetup

dLm = 100e-12;
dLp = 0;
dlm = 0;
dlp = 0;

pos = zeros(opt.Ndrive, 1);
pos(nEX) =  dLm / 2;
pos(nEY) = -dLm / 2;

%This is already in sweepSetup.m but included for ease readability
nREFL_I = getProbeNum(opt,'REFL_I');
nREFL_Q = getProbeNum(opt,'REFL_Q');
nAS_I = getProbeNum(opt,'AS_I');
nAS_Q = getProbeNum(opt,'AS_Q');


% compute the DC signals and TFs on resonances
f = 150;
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nAS_Q, nEX);
hY = getTF(sigAC, nAS_Q, nEY);
hDARMasq = hX - hY;

hX = getTF(sigAC, nAS_I, nEX);
hY = getTF(sigAC, nAS_I, nEY);
hDARMasi = hX - hY;

as_phase = -1*findBestPhase(hDARMasq,hDARMasi)

hX = getTF(sigAC, nREFL_I, nEX);
hY = getTF(sigAC, nREFL_I, nEY);
hCARMrefli = hY + hX;

hX = getTF(sigAC, nREFL_Q, nEX);
hY = getTF(sigAC, nREFL_Q, nEY);
hCARMreflq = hY + hX;

refl_phase = findBestPhase(hCARMrefli,hCARMreflq)

