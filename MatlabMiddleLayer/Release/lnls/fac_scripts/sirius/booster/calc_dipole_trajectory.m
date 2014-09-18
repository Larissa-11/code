function calc_dipole_trajectory

mm   = 0.001; % [mm] -> [m] conversion
mrad = 0.001; % [mrad] -> [rad] conversion  

% adds path with runge kutta scripts
root_path = lnls_get_root_folder();
folder = fullfile(root_path,'code','MatlabMiddleLayer','Release','lnls','fac_scripts','sirius','magnet_modelling');
addpath(folder);

% loads fieldmap
filename = fullfile(root_path, 'data','sirius_mml','magnet_modelling','MM3D','B_Booster','2013-12-21_Dipolo_Booster_BD_Modelo_6_-80_20mm_-1000_1000mm.txt');
%load_fieldmap(filename, 'suppress_plot');
load_fieldmap(filename);
maxwell_field_reconstruction(0);

% calcs beam parameters (magnetic rigidity, gamma factor, beta, etc)
beam_energy = 3.0; % [GeV]
calc_beam_parameters(beam_energy);

% does runge-kutta tracking to calculate initial position
runge_kutta_flags.RelTol  = 1e-8;      % RK tolerance                        
runge_kutta_flags.AbsTol  = 1e-8;      % RK tolerance                        
runge_kutta_flags.MaxStep = 4 * mm;    % RK max step size (longitudinal position)    
distance      = 1000;     %[mm]
sag           = 18.0896;  %[mm]
init_position = ([sag/2 0 0 0 0 1].*[mm mm mm 1 1 1])'; % initial condition [x,y,z,beta_x,beta_y,beta_z] 
t = calc_traj([0  distance] * mm, init_position, runge_kutta_flags);
traj1.s = t(:,7); 
traj1.x = t(:,1); traj1.y = t(:,2); traj1.z = t(:,3);
traj1.beta_x  = t(:,4); traj1.beta_y  = t(:,5); traj1.beta_z  = t(:,6); 
traj1.angle_x = atan(traj1.beta_x ./ traj1.beta_z);
traj1.angle_y = atan(traj1.beta_y ./ traj1.beta_z);
ref_angle  = -traj1.angle_x(end);
ref_x      =  traj1.x(end);
ref_y      =  traj1.y(end);
ref_z      = -traj1.z(end);
ref_beta_x = -traj1.beta_x(end);
ref_beta_z =  traj1.beta_z(end);
traj1.x = [flipud(traj1.x); traj1.x(2:end)];
traj1.y = [traj1.y; traj1.y(2:end)];
traj1.z = [-flipud(traj1.z); traj1.z(2:end)];

% adds kick to the initial coordinate (from kicker) and does runge-kutta
% tracking
x  = 8.375 * mm;
xl = 2.88  * mrad; 
init_position = [ref_x + cos(ref_angle) * x, ref_y, ref_z - sin(ref_angle) * x, ref_beta_x + xl, 0, ref_beta_z];
t = calc_traj([0  2*distance] * mm, init_position, runge_kutta_flags);
traj2.s = t(:,7); 
traj2.x = t(:,1); traj2.y = t(:,2); traj2.z = t(:,3);
traj2.beta_x  = t(:,4); traj2.beta_y  = t(:,5); traj2.beta_z  = t(:,6); 
traj2.angle_x = atan(traj2.beta_x ./ traj2.beta_z);
traj2.angle_y = atan(traj2.beta_y ./ traj2.beta_z);

figure; hold all;
plot(1000*traj1.z, 1000*traj1.x);
plot(1000*traj2.z, 1000*traj2.x);




