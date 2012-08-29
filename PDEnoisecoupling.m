% example for calculating laser intensity noise coupling

% make opt
par = paramPDE([],1);
par = paramPDE_LSC(par);
opt = optPDE(par);
opt = probesPDE(opt,par);

cucumber = cucumberPDE(opt);

fHigh = 30000; fLow = 50;
f = logspace(log10(fLow),log10(fHigh),500).';
% run lentickle
results = lentickleEngine(cucumber,[],f).';

% calculate calibration TF
DARMcalmeters = pickleTF(results,'EX','DARM') - pickleTF(results,'EY','DARM'); % units of [DARM counts]/m

% calculate nosie TF
AMtoDARM = pickleTF(results,'AM','AS_Q')/2; %units of [DARM counts]/RIN (factor of 2 is because of optickle units of amplitude modulator

AMnoise = AMtoDARM ./ DARMcalmeters; % units m/RIN

% make a plot

figure(1)
subplot(2,1,1)
loglog(f,abs(AMnoise),'r');
title('Intensity Noise Coupling')
ylabel('Magnitude (m/RIN)')
legend('DARM','location','NE')
xlim([fLow fHigh])
grid on
subplot(2,1,2)
semilogx(f,180/pi*angle(AMnoise),'r');
ylabel('Phase (degrees)')
xlabel('Frequency (Hz)')
xlim([fLow fHigh])
ylim([-180 180])
grid on