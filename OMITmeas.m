% Optickle Simulation of OMIT style measurement

% add optickle to path and Tobin's useful scripts

addpath('~/ligo/sim/Optickle/')
addpath('~/ligo/sim/Optickle/lib')
addpath('/home/nicolas/git/optickle-tutorial/lib')


powers = [2 1 .5 .2];
PMtoXTRANS={};
PMtoREFL={};

%% calculate
for P0=powers

% this creates opt and par (setupPDE)
par = paramPDE([],P0);
par = paramPDE_LSC(par);
opt = optPDE(par);
opt = probesPDE(opt,par);

% choose detuning
f_internal = par.IX.w_internal/(2*pi);

fudgeDetune = -0.075;
%fudgeDetune = .6;

pos = zeros(1,opt.Ndrive);
delta = f_internal/opt.c*(opt.lambda*par.Length.Xarm)*(1+fudgeDetune); %detuning in meters
pos(getDriveNum(opt,'EX')) = delta; %detuning of EX
pos(getDriveNum(opt,'EY')) = delta; %detuning of EY

% calculate TFs

zoomPlotWidth = 2;

f = sort([logspace(4,5,100)  linspace(f_internal-zoomPlotWidth/2,f_internal+zoomPlotWidth/2,1000)]);

[fDC, sigDC, sigAC] = tickle(opt, pos, f);

% show results
%showfDC(opt,fDC)

nPM = getDriveNum(opt,'PM');
nTransX = getProbeNum(opt,'X_TRANS_DC');
nREFL = getProbeNum(opt,'REFLDC');

PMtoXTRANS = [PMtoXTRANS {-getTF(sigAC,nTransX,nPM)/P0}];
PMtoREFL = [PMtoREFL {-getTF(sigAC,nREFL,nPM)/P0}];

end


%% make plots
figure(1)
set(gcf,'Color','white')
set(gcf,'Position',[0 0 1400 700])
colors = get(gca,'colororder');
legs = cell(length(powers),1);
clf
for jj = 1:length(powers)
subplot(2,2,1)
loglog(f,abs(PMtoXTRANS{jj}),'Color',colors(jj,:))
hold on
xlim([min(f) max(f)])
subplot(2,2,3)
semilogx(f,180/pi*angle(PMtoXTRANS{jj}),'Color',colors(jj,:))
hold on
xlim([min(f) max(f)])

% plot zoom in

f_subset = f<f_internal+zoomPlotWidth/2&f>f_internal-zoomPlotWidth/2;
fzoom = f(f_subset)-f_internal;
subplot(2,2,2)
semilogy(fzoom,abs(PMtoXTRANS{jj}(f_subset)),'Color',colors(jj,:))
hold on
xlim([min(fzoom) max(fzoom)])
subplot(2,2,4)
plot(fzoom,180/pi*angle(PMtoXTRANS{jj}(f_subset)),'Color',colors(jj,:))
hold on
xlim([min(fzoom) max(fzoom)])
legs{jj} = ['Input Power = ' num2str(powers(jj)) 'W'];
end


subplot(2,2,1)
title('EOM drive to X arm transmission, normalized by input power')
ylabel('Transfer function magnitude (1/radians)')
legend(legs,'Location','best')
subplot(2,2,3)
ylabel('Phase (degrees)')
xlabel('Frequency (Hz)')
subplot(2,2,2)
title('Zoom on OMIT dip')
subplot(2,2,4)
xlabel('Frequency (Hz)')

export_fig('opticleomit.pdf')
% 
% figure(2)
% set(gcf,'Color','white')
% set(gcf,'Position',[0 0 1400 700])
% colors = get(gca,'colororder');
% legs = cell(length(powers),1);
% clf
% for jj = 1:length(powers)
% subplot(2,2,1)
% loglog(f,abs(PMtoREFL{jj}),'Color',colors(jj,:))
% hold on
% xlim([min(f) max(f)])
% subplot(2,2,3)
% semilogx(f,180/pi*angle(PMtoREFL{jj}),'Color',colors(jj,:))
% hold on
% xlim([min(f) max(f)])
% 
% % plot zoom in
% 
% f_subset = f<f_internal+zoomPlotWidth/2&f>f_internal-zoomPlotWidth/2;
% fzoom = f(f_subset)-f_internal;
% subplot(2,2,2)
% semilogy(fzoom,abs(PMtoREFL{jj}(f_subset)),'Color',colors(jj,:))
% hold on
% xlim([min(fzoom) max(fzoom)])
% subplot(2,2,4)
% plot(fzoom,180/pi*angle(PMtoREFL{jj}(f_subset)),'Color',colors(jj,:))
% hold on
% xlim([min(fzoom) max(fzoom)])
% legs{jj} = ['Input Power = ' num2str(powers(jj)) 'W'];
% end
% 
% 
% subplot(2,2,1)
% title('EOM drive to reflected power, normalized by input power')
% ylabel('Transfer function magnitude (1/radians)')
% legend(legs,'Location','best')
% subplot(2,2,3)
% ylabel('Phase (degrees)')
% xlabel('Frequency (Hz)')
% subplot(2,2,2)
% title('Zoom on OMIT dip')
% subplot(2,2,4)
% xlabel('Frequency (Hz)')