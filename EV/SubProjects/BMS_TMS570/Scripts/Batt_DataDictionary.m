addpath('Lib');
%%
NumModules = 1; %Number of Modules
Ns_Module = 6; % Number of Cells in Each Module
Ns_Pack = NumModules*Ns_Module;
CellType = 1;
if CellType == 1
    load('Kokam_LUT_1RC');% Load 1RC Cell Data
else
    load('Kokam_LUT_3RC'); % Load 3RC Cell Data
end
%load('BattCrntDrvCycle'); % Load Drive Cycle Current Profile
%load('BMS_Sw_ModelConfig'); % Load Model Configuration File

SOCInit = 0.75;
TempInit = 15 + 273.15; %K
TestCase = 1; % Default TestCase
%% Thermal Properties
% Cell dimensions and sizes
cell_thickness = 0.0084; %m
cell_width = 0.215; %m
cell_height = 0.220; %m
% Cell surface area
cell_area = 2 * (...
    cell_thickness * cell_width +...
    cell_thickness * cell_height +...
    cell_width * cell_height); %m^2
% Cell volume
cell_volume = cell_thickness * cell_width * cell_height; %m^3
%%
for idx = 1:Ns_Module
%% Lookup Table Breakpoints
    Battery(idx).SOC_LUT = SOC_LUT;
    Battery(idx).Temperature_LUT = [5 20 40] + 273.15;
    %% Em Branch Properties (OCV, Capacity)
    % Battery capacity
    Battery(idx).Capacity_LUT = Capacity; %Ampere*hours
    if CellType == 1
    % Em Branch Properties (OCV, Capacity)
    % Em open-circuit voltage vs SOC rows and T columns
    Battery(idx).Em_LUT =  [results.T5C(:,1) ...
                                    results.T20C(:,1) ...
                                    results.T40C(:,1)]; %Volts
    % Terminal Resistance Properties
    % R0 resistance vs SOC rows and T columns
    Battery(idx).R0_LUT = [results.T5C(:,2) ...
                                    results.T20C(:,2) ...
                                    results.T40C(:,2)]; %Ohms
    % RC Branch Properties
    % R1 Resistance vs SOC rows and T columns
    Battery(idx).R1_LUT = [ results.T5C(:,3) ...
                            results.T20C(:,3) ...
                            results.T40C(:,3)]; %Ohms
    % C1 Capacitance vs SOC rows and T columns
    Battery(idx).C1_LUT = [ results.T5C(:,4) ...
                            results.T20C(:,4) ...
                            results.T40C(:,4)]; %Farads
    else
    % Em Branch Properties (OCV, Capacity)
    % Em open-circuit voltage vs SOC rows and T columns
    Battery(idx).Em_LUT =  [results.T5C(:,1) ...
                                    results.T20C(:,1) ...
                                    results.T40C(:,1)]; %Volts
    % Terminal Resistance Properties
    % R0 resistance vs SOC rows and T columns
    Battery(idx).R0_LUT = [results.T5C(:,2) ...
                                    results.T20C(:,2) ...
                                    results.T40C(:,2)]; %Ohms
    % RC Branch Properties
    % R1 Resistance vs SOC rows and T columns
    Battery(idx).R1_LUT = [ results.T5C(:,3) ...
                            results.T20C(:,3) ...
                            results.T40C(:,3)]; %Ohms
    % C1 Capacitance vs SOC rows and T columns
    Battery(idx).C1_LUT = [ results.T5C(:,6) ...
                            results.T20C(:,6) ...
                            results.T40C(:,6)]; %Farads
    % R2 Resistance vs SOC rows and T columns
    Battery(idx).R2_LUT = [ results.T5C(:,4) ...
                            results.T20C(:,4) ...
                            results.T40C(:,4)]; %Ohms
    % R3 Resistance vs SOC rows and T columns
    Battery(idx).R3_LUT = [ results.T5C(:,5) ...
                            results.T20C(:,5) ...
                            results.T40C(:,5)]; %Ohms
    % C2 Capacitance vs SOC rows and T columns
    Battery(idx).C2_LUT = [ results.T5C(:,7) ...
                            results.T20C(:,7) ...
                            results.T40C(:,7)]; %Farads
    % C3 Capacitance vs SOC rows and T columns
    Battery(idx).C3_LUT = [ results.T5C(:,8) ...
                            results.T20C(:,8) ...
                            results.T40C(:,8)]; %Farads
    end
    %% Cell Mass and Specific Heat
    % Cell mass
    Battery(idx).cell_mass = 0.84; %kg

    % Volumetric heat capacity
    % assumes uniform heat capacity throughout the cell
    % ref: J. Electrochemical Society 158 (8) A955-A969 (2011) pA962
    Battery(idx).cell_rho_Cp = 2.04E6; %J/m3/K

    % Specific Heat
    Battery(idx).cell_Cp_heat = Battery(idx).cell_rho_Cp * cell_volume / Battery(idx).cell_mass; %J/kg/K
    %% Initial Conditions
    % Charge deficit
    % Battery(idx).Qe_init = 15.6845; %Ampere*hours

    % Ambient Temperature
    Battery(idx).T_init = TempInit; %K

    %% Initial charge deficit
    Battery(idx).Qe_init = Capacity(1)*(1-SOCInit); %Ampere*hours

end
%% Out of balance charge deficit
%Battery(3).Qe_init = Capacity(1)*(1-SOCInit*1.03); %Ampere*hours
%Battery(2).Qe_init = Capacity(1)*(1-SOCInit*1.03); %Ampere*hours
%% Convective heat transfer coefficient
% For natural convection this number should be in the range of 5 to 25
h_conv = 5; %W/m^2/K Cell-to-cell
h_conv_end = 10; %W/m^2/K End cells to ambient
%% Passive balancing parameters
% load('tempParam')
R_bleed = 20; %Ohm
BattCrntGain = 1;
% Controller Parameters
I_cc = single(30); % Amp, 1C Rate
CV_Gain = single(0.2);
%% BMS Algorithm Parameters
flgEnBalancing = true;
MaxTargetSoc = single(0.90);
MaxCellVoltThrsld = single(4.2);


TargetDeltaV = single(0.01); %10 mV
HighTempLimit = single(45+273.15); % single(318.15); %45 dC
LowTempLimit = single(278.15); %5 dC
SnsrFltThld = 4.2*Ns_Pack*0.01; % 1 percent of Pack_Voltage
BalOnWait = int16(60);
BalOffWait = int16(20);
BalNotActWait = int16(30);
%% Model Data
ts = 1e-1;
Ts = ts;
