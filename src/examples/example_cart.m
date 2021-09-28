%% Set up the problem
clear
% Initial and final conditions
pos_initial = 0;
pos_final = 0.7;
velocity_initial = 0;
velocity_final = 0;
time_final = 1;

% State variables grid
SVnames = {'Position', 'Speed'};
x1_grid = 0:0.01:1;
x2_grid = -0.5:0.01:1;
x_grid = {x1_grid, x2_grid};
% Initial state 
x1_init = pos_initial;
x2_init = velocity_initial;
x_init = {x1_init, x2_init};
% Final state constraints
x1_final = [pos_final-0.05 pos_final+0.05];
x2_final = [velocity_final-0.05 velocity_final+0.05];

x_final = {x1_final, x2_final};
% Control variable grid
CVnames = 'Thrust';
u_grid = {-5:0.05:5};
% Number of stages (time intervals)
dt = 0.1;
Nint = time_final/dt;

% Create DynaProg object
prob = DynaProg(x_grid, x_init, x_final, u_grid, Nint, @cart);
prob.VFInitialization = 'linear';

%% Solve and visualize results
% Solve the problem
prob = run(prob);

% Add time vector to use in the plot
time = 0:dt:time_final;
prob.Time = time;
% Add SV, CV and cost names to be used in the plot
prob.StateName = SVnames;
prob.ControlName = CVnames;
prob.CostName = 'Energy';
% Plot results
figure
plot(prob)
