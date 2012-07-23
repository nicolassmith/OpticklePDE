% This function will search for the minimum modulation required for a
% stable intracavity modulated double optical spring
function doubleSpringSearch()
    addpath('~/ligo/sim/Optickle/')
    addpath('~/ligo/sim/Optickle/lib')
    addpath('/home/nicolas/git/optickle-tutorial/lib')
    
    
    % do a fminsearch

    %x0 = [.0001,14.2]; % starting modulation and detuning
    
    %x = fminsearch(@minModulation,x0);
    
    %disp(['Modulation = ' num2str(x(1)) ', detuning = ' num2str(x(2))])
    
    minModulation([3.3198e-5 14.2552])
    
end


function cost = minModulation(args)

    modGamma = args(1);
    delta = args(2);

    % frequency
    f = logspace(2,log10(300),20).';
    
    
    % set laser powers
    Pc = 4;
    Ps = 0;

    % this creates opt and par (setupPDE)
    par = paramPDE([],Pc);
    par = paramPDE_LSC(par);
    % hack in a different vFrf and vArf

    c = 299792458;
    fGamma = c*par.IX.T/(8*pi*par.Length.Xarm);

    fSubcarrier = par.ETM.w_internal/(2*pi);

    par.PSL.vFrf = [par.PSL.vFrf;fSubcarrier;-fSubcarrier];
    par.PSL.vArf = [par.PSL.vArf;sqrt(Ps);0];

    % make opt
    opt = optPDE(par,RFmodulator('armMod',fSubcarrier,1i*modGamma));
    opt = probesPDE(opt,par);

    % set detuning
    pos = zeros(1,opt.Ndrive);

    fdelta = delta*fGamma; %detuning

    pos(getDriveNum(opt,'EX')) = -fdelta/c*(opt.lambda*par.Length.Xarm); %detuning of EX in meters

    % tickle

    [fDC, sigDC, sigAC, mMech] = tickle(opt, pos, f);

    respOptic = 'EX';

    nOpt = getDriveNum(opt,respOptic);
    Opt = getOptic(opt,respOptic);

    springTF = getTF(mMech,nOpt,nOpt).*squeeze(freqresp(Opt.mechTF,2*pi*f));

    stability = -sum(sin(angle(springTF))); % a postive number means the resonance is stable
    
    if stability>0
        cost = modGamma;
    else
        cost = inf;
    end
end