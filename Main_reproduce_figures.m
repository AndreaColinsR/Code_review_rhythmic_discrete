function Main_reproduce_figures
%% Main_reproduce_figures reproduce all the figures of the paper
% for this, download a copy of the data from the Mendeley repository and
% place both files in a folder named "Data_Russo"
% unzip the "Code" folder in a neighbouring folder
% Run this code in the folder that contains the Data_Russo and Code folder
%
% This code will create a new folder named "Output_files" to save
% intermediate results
%
%
% 13/01/2025
% Andrea Colins Rodriguez

%% add necessary toolboxes 
%%addpath(genpath('.\Code\'))
%%addpath(genpath('C:\Users\Acer\Documents\Codes_from_papers\matlab_dpca'))
%%addpath(genpath('C:\Users\andrea.colins\OneDrive - Universidad Adolfo Ibanez\Office computer\codes_from_papers\jPCA_ForDistribution'))
%%addpath(genpath('C:\Users\andrea.colins\OneDrive - Universidad Adolfo Ibanez\Office computer\codes_from_papers\kobak2016'))


plot_supp = 0; % 1 to plot supplementary figures, 0 otherwise
mkdir Output_files
%% 0. Define PCA trajectories and save results in Output_files folder
create_all_output_files

%% Figure 1
animal = 'Drake';
Plot_kinematics(animal)
test_raster_different_N_cycles(animal)



%% Train neural networks here
% Create inputs and outputs for the RNNs


%% Figure 2
%region_name='M1';
%compare_network_families(region_name,plot_supp)

%% Figure 3

% region_name='SMA';
% compare_network_families(region_name,plot_supp)
end