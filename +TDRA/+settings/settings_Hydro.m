function [ settings ] = settings_Hydro( settings )

% user settings concerning Hydrodynamic Transfer Functions

% input folder path
settings.Hydro.input_folder = 'D:\Matlab\TimeDomainCode\Input\Wadam';
% Wadam folder names
settings.Hydro.wadam_folders = {'WAMIT30','WAMIT31','WAMIT32','WAMIT33'};
% wadam file to import
settings.Hydro.wadam_filename = 'WADAM1.LIS';

% FDI INPUT
settings.Hydro.WAMIT_No = 3;  %0 ,1 ,2 ,3 represents the pontoons with four different dimensions  
settings.Hydro.Dof = [3,3]; %[1~6,1~6]
settings.Hydro.FDIopt.OrdMax     = 6;
settings.Hydro.FDIopt.AinfFlag   = 0;
settings.Hydro.FDIopt.Method     = 2;
settings.Hydro.FDIopt.Iterations = 400;
settings.Hydro.FDIopt.PlotFlag   = 0;
settings.Hydro.FDIopt.LogLin     = 0;
settings.Hydro.FDIopt.wsFactor   = 0.1;  
settings.Hydro.FDIopt.wminFactor = 0.1;
settings.Hydro.FDIopt.wmaxFactor = 10;


% target folder to save outputs
settings.Hydro.target = 'D:\Matlab\TimeDomainCode\Output';
mkdir(settings.Hydro.target);
settings.Hydro.target_name_matrices = 'curveBridgeWamit3';
settings.Hydro.target_name_fits = 'Wamit3';

end

