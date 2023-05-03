% Model         :   PMSM Field Oriented Control
% Description   :   Set Parameters for PMSM Field Oriented Control
% File name     :   mcb_pmsm_foc_qep_f28379d_data.m

% Copyright 2021 The MathWorks, Inc.

%% Set PWM Switching frequency
PWM_frequency 	= 20e3;             %Hz     // converter s/w freq
T_pwm           = 1/PWM_frequency;  %s      // PWM switching time period

%% Set Sample Times
T_cpu          	= 200e-6; % T_pwm;            %sec    // Sample time for control system
Ts_simulink     = 200e-6; % T_pwm/2;          %sec    // Simulation time step for model simulation
Ts_motor        = 200e-6; % T_pwm/2;          %Sec    // Simulation time step for pmsm
Ts_inverter     = 200e-6; % T_pwm/2;          %sec    // Simulation time step for inverter
Ts_speed        = 200e-6; % 10*T_cpu;            %Sec    // Sample time for speed controller

%% Set data type for controller & code-gen
% dataType = fixdt(1,32,17);        % Fixed point code-generation
dataType = 'single';                % Floating point code-generation

%% System Parameters
% Motor parameters
pmsm = mcb_SetPMSMMotorParameters('Teknic2310P');
pmsm.PositionOffset = 0;% Per-Unit position offset

%% Target & Inverter Parameters
target = mcb_SetProcessorDetails('F28379D',PWM_frequency);

inverter = mcb_SetInverterParameters('BoostXL-DRV8305');
% Run HIL in open loop, plot the ADC counts for two phase currents, find
% the counts corresponding to DC offset by computing the average
% inverter.CtSensAOffset = 2250;     				%Counts // ADC Offset for phase-A
% inverter.CtSensBOffset = 2250;     				%Counts // ADC Offset for phase-B

% Enable automatic calibration of ADC offset for current measurement
inverter.ADCOffsetCalibEnable = 0;  % Enable: 1, Disable:0

% If automatic ADC offset calibration is disabled, uncomment and update the
% offset values below manually
% inverter.CtSensAOffset = 2295;      % ADC Offset for phase current A
% inverter.CtSensBOffset = 2286;      % ADC Offset for phase current B

% Update inverter.ISenseMax based for the chosen motor and target
inverter = mcb_updateInverterParameters(pmsm,inverter,target);
inverter.ADCOffset = 1.65;          %volt   // Current sense output for 0A current

% Max and min ADC counts for current sense offsets
inverter.CtSensOffsetMax = 2500;    % Maximum permitted ADC counts for current sense offset
inverter.CtSensOffsetMin = 1500;    % Minimum permitted ADC counts for current sense offset

%% Derive Characteristics
pmsm.N_base = mcb_getBaseSpeed(pmsm,inverter); %rpm // Base speed of motor at given Vdc

% mcb_getCharacteristics(pmsm,inverter);

%% PU System details // Set base values for pu conversion

PU_System = mcb_SetPUSystem(pmsm,inverter);

%% Controller design // Get ballpark values!

PI_params = mcb.internal.SetControllerParameters(pmsm,inverter,PU_System,T_pwm,T_cpu,Ts_speed);

%Updating delays for simulation
PI_params.delay_Currents    = int32(T_cpu/Ts_simulink);
PI_params.delay_Position    = int32(T_cpu/Ts_simulink);
PI_params.delay_Speed       = int32(Ts_speed/Ts_simulink);
PI_params.delay_Speed1      = (PI_params.delay_IIR + 0.5*T_cpu)/Ts_speed;

% mcb_getControlAnalysis(pmsm,inverter,PU_System,PI_params,Ts,Ts_speed);

%% Displaying model variables
disp(pmsm);
disp(inverter);
disp(target);
disp(PU_System);
