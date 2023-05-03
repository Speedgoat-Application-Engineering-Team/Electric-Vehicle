
**About**

The Electric Vehicle HIL Demo by Speedgoat, is aiming to provide a versatile platflorm to show how Speedgoat hardware and simulink real-time can leverage the vast mathworks ecosystem for automotive components developments and testing.
It needs the IO 334 with -21 expension, performance target machine with 4Ghz (new generation) or 4.2Ghz (old generation) as well as a 3D space mouse to control the speed. Powertrain blockset, simscape simulink real-time are needed to run the model.
Additionnaly, the IO box with oscilloscope can be used to monitor the current outputs from the IO 334.

----------

**Getting started**

 1. Open MATLAB and open the EV Simulink Project File. Connect the spacemouse with a usb cable to the host computer, and if available, the IO334 to the IO box and the IO box channels A and B of output 1:4 to the oscillosope.   

Check if the the stock configuration is working by running the EvReferenceApplication.slx in real-time. If the IO is not reckognized check if the IO configuration block in the model is well configured (specify PCI port if needed). 
If the 3D mouse is not changing the speed, check if the IP written in the receive UDP block of the EvReferenceApplication.slx model and the send UDP block in the joystick.slx. For longer runs and better refresh rate of the UI, use monitor only option in SDI.
 
----------

**Release notes**
> **1.1.1 - May 2023**
Small cosmetic changes

> **1.1.0 - January 2023**

Working R2022b version with 200Mhz FPGA motor model in the loop from slrt example. 3 phases are now on the analog outputs. Original bitstream and source model included in the repository (EV/SubProjects/High-Fidelity-Electric-Drive/model) but not needed as the bitstream is included in the slrt installation. Could be useful if changes occur in the future. 
Battery level is now taken from average of the simscape cells instead of the original model. 
Known issues : 
- loss of signal display in dashboards
- Better stability with SDI "view during simulation only" option
- Crash when the fault is triggered for too long (battery gets to its limit temperature and the time constant interpolation from the simscape component becomes negative)

Desireable improvements : 
- variant for the motor model to allow CPU simulation only like the original model
- Simscape plant model in the loop instead of in parralel.
- Control loop fine tuning.
- HIL version with TI launchpad

> **1.0.0 - September 2022**

Working R2022b version, with 100Mhz FPGA motor model running in parallel to the vehicle control loop. SDI should be set as monitor only.
Not all models are saved as R2022b. A very similar version (2021a) has been shown at live events without problems.


> **0.9.0 - September 2022**

 Version almost ready for release. Should run properly on R2022a.


**© 2007 – 2023 Speedgoat GmbH**

