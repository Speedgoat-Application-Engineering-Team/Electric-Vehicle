% Description   :   Parameters for HIL workflow
% File name     :   PMSM_HIL_Param.m

% Copyright 2021 The MathWorks, Inc.

embedded_sim_codegen_data;

%% Load parameters to plant model from SLRT
gatesInputFlag = 1;
J = pmsm.J;
L0 = pmsm.Ld;
Ld = pmsm.Ld;
Lq = pmsm.Lq;
N = pmsm.p;
numSlits = pmsm.QEPSlits;
PM = pmsm.FluxPM;
Rs_HIL = pmsm.Rs;
Vdc = inverter.V_dc;
gain = inverter.ISenseVoltPerAmp;
bias = 1.65;

pulseSigOffset = 0;
shaftInitPos = 0;

%% Sample times
Ts = 200e-6; % 5e-5;
f_base = 200e6;     % 100e6 => 10ns sample time for inverter pwm capture
%f_base = 2e6; % Uncomment for faster desktop simulation

T_base = 1/f_base;  % Sample time for PWM capture
ts_FPGA_clk = 1 / f_base;
ts_FPGA_mdl = 1e-6;


% Model rate on the FPGA
T_fpga = 1e-6;      % Sample time for motor and inverter equations
f_fpga = 1/T_fpga;



% Description   :   Set Parameters for HIL workflow
% File name     :   PMSM_HIL_Param.m

% Copyright 2021 The MathWorks, Inc.

% Model rate on the FPGA
T_fpga = 1e-6;      % Sample time for motor and inverter equations
f_fpga = 1/T_fpga;

% Base frequency of the FPGA
%f_base = 2e6;     % uncomment for faster simulation, make sure this is commented during HDL codegen
T_base = 1/f_base;  % Sample time for PWM capture

% Set parameters for embedded controller (FOC)

% Base rate for desktop simulation
% T_base = 1e-6; 

oversampling = T_fpga/ T_base;

% Switching frequency
f_sw = PWM_frequency;
Tsw = 1/f_sw;

% Sample time of the controller
Tsc = T_cpu; 

% Sample time of the Simscape model
Ts = T_fpga; 

pmsm.Ld = 6.0000e-04;
pmsm.Lq =  6.0000e-04;

PUSpeedRef = 0.2;

Tcpu = T_cpu;

%
%
Load_Level_Pct = 50;
Auto_Test = 0;
Speed_Ref_Pct = 50;


