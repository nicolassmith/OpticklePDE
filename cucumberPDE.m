function cucumber = cucumberPDE(opt,pos)
    
    if nargin<2
        pos = [];
    end
    
    % probeSens
                    %  probes     sensors
    probeSensPairs = {'REFL_I', 'REFL_I'
                      'REFL_Q', 'REFL_Q'
                      'AS_I',   'AS_I'
                      'AS_Q',   'AS_Q'
                      'X_TRANS_DC','X_TRANS'
                      'Y_TRANS_DC','Y_TRANS'};
                  
    % now we can use this to create our matrix.
    
    Nsens = size(probeSensPairs,1);
    probeSens = sparse(Nsens,opt.Nprobe);
    
    for jSens = 1:Nsens
                  %sensor index, probe index = 1
        probeSens(jSens,getProbeNum(opt,probeSensPairs{jSens,1})) = 1; %#ok<SPRIX>
    end
                        
    % We will also need the list of sensor names
    
    sensNames = probeSensPairs(:,2).';
    
    % mirrDrive
    
                    %  mirrors  drives driveType
    mirrDrivePairs = {'EX',    'EX',   1
                      'EY',    'EY',   1
                      'IX',    'IX',   1
                      'IY',    'IY',   1
                      'BS',    'BS',   1
                      'AM',    'AM',   1
                      'PM',    'PM',   1
                      'OSC_AM','Mod1', 'amp'
                      'OSC_PM','Mod1', 'phase'};
                  
    % now we can use this to create our matrix.
    
    Nmirr = size(mirrDrivePairs,1);
    mirrDrive = sparse(opt.Ndrive,Nmirr);
    
    mirrNames = mirrDrivePairs(:,1).';   
    
    for jMirr = 1:Nmirr
                  %drive index, mirror index = 1
        mirrDrive(getDriveNum(opt, mirrDrivePairs{jMirr,2}, mirrDrivePairs{jMirr,3}), jMirr) = 1; %#ok<SPRIX>
    end
    
    % sensDof
    
    
               % REFLI REFLQ ASI ASQ XTRN YTRN
    sensDof = [1     0   0   0    0    0   % CML
                     1     0   0   0    0    0   % CMF
                     0     0   0   1    0    0   % DARM
                     0     1   0   0    0    0]; % MICH
    
    % Now that we've defined our DOFs, let's store the names we will use to
    % refer to them.
    
    dofNames = { 'CML', 'CMF', 'DARM', 'MICH'};
    %#ok<*NBRAK>
    % Control Filters (ctrlFilt)
    % These are the feedback filters.
    
    cmlGain = 2e4;
    ctrlFilt = [ filtZPK([],[0,0,0,200,200],cmlGain),... %CML
                 filtZPK([100,1000],[0,0,0,100],1),...  %CMF
                 filtZPK([],[0],1),...  %DARM
                 filtZPK([],[0],1)];    %MICH 
    
    % here we should also store the desired UGF of the loops
                % CML  CMF DARM MICH
    setUgfDof = [ NaN 10000  200  100];
    
    % dofMirr
    
               % CML  CMF DARM MICH
    dofMirr = [    0    0    0   0 % EX
                   0    0    0   0 % EY
                   1    0    1   0 % IX
                   1    0   -1   0 % IY
                   0    0    0   1 % BS
                   0    0    0   0 % AM
                   0    1    0   0 % PM
                   0    0    0   0 % OSC AM
                   0    0    0   0];% OSC PM
               
    unityFilt = filtZPK([],[],1); % just a flat TF 
    
               % EX EY IX IY BS AM PM OSCAM OSCPM
    mirrFilt = [unityFilt unityFilt unityFilt unityFilt unityFilt unityFilt unityFilt unityFilt unityFilt];
    
    % pendFilt
    for jMirr = 1:Nmirr
        optic = getOptic(opt,mirrDrivePairs(jMirr,2));
        if numel(optic.mechTF) ~= 0
            pendFilt(jMirr) = zpk2mf(optic.mechTF); %#ok<AGROW>
        else
            % mechTF isn't set, so put in the indentity TF.
            pendFilt(jMirr) = unityFilt; %#ok<AGROW>
        end
    end
    
    
    % store everything in the cucumber
    cucumber.opt       = opt;
    cucumber.probeSens = probeSens;
    cucumber.sensNames = sensNames;
    cucumber.mirrDrive = mirrDrive;
    cucumber.mirrNames = mirrNames;
    cucumber.sensDof   = sensDof;
    cucumber.dofNames  = dofNames;
    cucumber.ctrlFilt  = ctrlFilt;
    cucumber.setUgfDof = setUgfDof;
    cucumber.dofMirr   = dofMirr;
    cucumber.mirrFilt  = mirrFilt;
    cucumber.pendFilt  = pendFilt;
    
    % lenticklePhase here if necessary
end