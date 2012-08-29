
% make opt
par = paramPDE([],1);
par = paramPDE_LSC(par);
opt = optPDE(par);
opt = probesPDE(opt,par);

cucumber = cucumberPDE(opt);

fHigh = 30000; fLow = 1;
f = logspace(log10(fLow),log10(fHigh),500).';

results = lentickleEngine(cucumber,[],f).';

%dofs = {'CML' 'CMF'};
dofs = results.dofNames;

DOFol = {};
for dof = dofs
    DOFol = [DOFol 1-1./pickleTF(results,dof,dof)];
end

REFLol = 1-1./pickleTF(results,'REFL_I','REFL_I');

figure(1)
clf
subplot(2,1,1)
loglog(f,abs(REFLol))
hold all
for olTF = DOFol
    loglog(f,abs(olTF{:}))
end
ylim([1e-5 1e7])
xlim([fLow fHigh])
grid on
subplot(2,1,2)
semilogx(f,angle(REFLol)*180/pi)
hold all
for olTF = DOFol
    semilogx(f,angle(olTF{:})*180/pi)
end
ylim([-180 180])
xlim([fLow fHigh])
grid on

subplot(2,1,1)
legend(['REFL' dofs],'location','best')