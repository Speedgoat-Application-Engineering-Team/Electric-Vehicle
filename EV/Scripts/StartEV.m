% This script defines a project shortcut. 
%
% To get a handle to the current project use the following function:
%
% project = simulinkproject();
%
% You can use the fields of project to get information about the currently 
% loaded project. 
%
% See: help simulinkproject

% Copyright 2016-2018 The MathWorks, Inc.
% Create work folder if not exisiting yet
% Use Simulink Project API to get the current project:
p = slproject.getCurrentProject;
projectRoot = p.RootFolder;

myCacheFolder = fullfile(projectRoot, 'Work');
if ~isfolder(myCacheFolder)
    mkdir(projectRoot,'Work')
end

SetSlPrjFastLoadAndBuild
a = 200e-6;
TsElecDrive= a;
TsBattSimscape = a;
TsBatt = a;
TsEV= a;
TsDrivetrain = a;
TsIntrument10Hz = 0.1;
TsIntrument100Hz = 0.01;
TsIntrument1kHz = 0.001;
TsIntrument10kHz = 0.0002;


% Open reference application system model 
open_system('EvReferenceApplication')

% Open reference application getting started doc file 
