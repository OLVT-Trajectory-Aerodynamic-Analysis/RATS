close all; clear; clc

%% Boost:

% Declare a time span
t_start_boost = 0;
t_end_boost = 2.158;
h=0.001; %time step
tspan_boost = t_start_boost:h:t_end_boost;

% Set up initial state of the system

initial_position_boost = 0;
initial_speed_boost = 0;

x0_boost = [initial_position_boost, initial_speed_boost];

x_boost = zeros(2, length(tspan_boost)); % Initialize solution matrix
x_boost(:,1) = x0_boost; % Initial conditions

for i = 1:(length(tspan_boost)-1)
    t = tspan_boost(i);
    x_current = x_boost(:,i);

    k1 = boost(t, x_current);
    k2 = boost(t + h/2, x_current + h/2 * k1);
    k3 = boost(t + h/2, x_current + h/2 * k2);
    k4 = boost(t + h, x_current + h * k3);

    x_boost(:,i+1) = x_current + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end
%[t_boost,x_boost]=ode45(@boost,tspan_boost,x0_boost);

%% Coast:

t_start_coast = t_end_boost;
t_end_coast = 10;
h=0.001;%time step
tspan_coast = t_start_coast:h:t_end_coast;

% Set up initial state of the system
n = length(tspan_boost);
initial_position_coast = x_boost(1,n);
initial_speed_coast = x_boost(2,n);

x0_coast = [initial_position_coast, initial_speed_coast];


x_coast = zeros(2, length(tspan_coast)); % Initialize solution matrix
x_coast(:,1) = x0_coast; % Initial conditions

for i = 1:(length(tspan_coast)-1)
    t = tspan_coast(i);
    x_current = x_coast(:,i);

    k1 = coast(t, x_current);
    k2 = coast(t + h/2, x_current + h/2 * k1);
    k3 = coast(t + h/2, x_current + h/2 * k2);
    k4 = coast(t + h, x_current + h * k3);

    x_coast(:,i+1) = x_current + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end
%[t_coast,x_coast]=ode45(@coast,tspan_coast,x0_coast);

%% Drogue:

t_start_drogue = t_end_coast;
t_end_drogue = 25;
h=0.001; %time step
tspan_drogue = t_start_drogue:h:t_end_drogue;

% Set up initial state of the system
n = length(tspan_coast);
initial_position_drogue = x_coast(1,n);
initial_speed_drogue = x_coast(2,n);

x0_drogue = [initial_position_drogue, initial_speed_drogue];

x_drogue = zeros(2, length(tspan_drogue)); % Initialize solution matrix
x_drogue(:,1) = x0_drogue; % Initial conditions

for i = 1:(length(tspan_drogue)-1)
    t = tspan_drogue(i);
    x_current = x_drogue(:,i);

    k1 = drogue(t, x_current);
    k2 = drogue(t + h/2, x_current + h/2 * k1);
    k3 = drogue(t + h/2, x_current + h/2 * k2);
    k4 = drogue(t + h, x_current + h * k3);

    x_drogue(:,i+1) = x_current + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end

%[t_drogue,x_drogue]=ode45(@drogue,tspan_drogue,x0_drogue);

%% Main:

t_start_main = t_end_drogue;
t_end_main = 40;
h=0.001; %time step
tspan_main = t_start_main:h:t_end_main;

% Set up initial state of the system
n = length(tspan_drogue);
initial_position_main = x_drogue(1,n);
initial_speed_main = x_drogue(2,n);

x0_main = [initial_position_main, initial_speed_main];

x_main = zeros(2, length(tspan_main)); % Initialize solution matrix
x_main(:,1) = x0_main; % Initial conditions

for i = 1:(length(tspan_main)-1)
    t = tspan_main(i);
    x_current = x_main(:,i);

    k1 = main(t, x_current);
    k2 = main(t + h/2, x_current + h/2 * k1);
    k3 = main(t + h/2, x_current + h/2 * k2);
    k4 = main(t + h, x_current + h * k3);

    x_main(:,i+1) = x_current + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end
%[t_main,x_main]=ode45(@main,tspan_main,x0_main);

%% Graphing:

tiledlayout(2,1)

%figure(1);
nexttile
plot(tspan_boost,x_boost(1,:));
hold on
plot(tspan_coast,x_coast(1,:));
plot(tspan_drogue,x_drogue(1,:));
plot(tspan_main,x_main(1,:));
hold off
title('Altitude vs Time');
xlabel('Time (s)');
ylabel('Altitude (m)');
legend('Boost','Coast','Drogue Chute','Main Chute');

%figure(2);
nexttile
plot(tspan_boost,x_boost(2,:));
hold on
plot(tspan_coast,x_coast(2,:));
plot(tspan_drogue,x_drogue(2,:));
plot(tspan_main,x_main(2,:));
hold off
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Boost','Coast','Drogue Chute','Main Chute');



function xdot = boost(t,x)
    % T using J460T motor.
    Dr = 0.005; % 1/m
    g = 9.81; % m/s2
    m = 4.191193 - 0.415; % Skipper1B w/o propellant weight.

    xdot_1 = x(2);
    xdot_2 = -Dr*x(2)^2 + (Thrust(t)/m) - g; % rocket going up

    xdot = [xdot_1 ; xdot_2];
end


function xdot = coast(t,x)
    % Initialize any constants
    Dr = 0.0005;
    g = 9.81;

    if x(2) >= 0
        xdot_1 = x(2);
        xdot_2 = -Dr*x(2)^2 - g; % rocket going up
    else
        xdot_1 = x(2);
        xdot_2 = Dr*x(2)^2 - g; % rocket has tipped over and coming down
    end


    xdot = [xdot_1 ; xdot_2];
end

function xdot = drogue(t,x)
    Dc = 0.01;
    g = 9.81;

    if x(2) >= 0
        xdot_1 = x(2);
        xdot_2 = -Dc*x(2)^2 - g; % rocket going up
    else
        xdot_1 = x(2);
        xdot_2 = Dc*x(2)^2 - g; % rocket has tipped over and coming down
    end

    xdot = [xdot_1 ; xdot_2];
end

function xdot = main(t,x)
    Dm = 0.1;
    g = 9.81;

    if x(2) >= 0
        xdot_1 = x(2);
        xdot_2 = -Dm*x(2)^2 - g; % rocket going up
    else
        xdot_1 = x(2);
        xdot_2 = Dm*x(2)^2 - g; % rocket has tipped over and coming down
    end

    xdot = [xdot_1 ; xdot_2];
end

function T = Thrust(t)
    % Data = readmatrix('AeroTech_J460T.csv');
    % RawDataTime = [0;Data(:,1)];
    % RawDataThrust = [0;Data(:,2)];
RawDataTime= [0 0.041 0.125 0.209 0.294 0.379 0.464 0.548 0.633 0.718 0.802 0.887 0.972 1.056 1.141 1.225 1.31 1.395 1.479 1.565 1.649 1.733 1.819 1.903 1.987 2.073 2.158];
RawDataThrust=[0 500.927 509.423 516.357 527.752 535.135 541.858 545.793 545.678 544.832 540.278 533.698 526.34 511.003 492.475 474.977 457.021 437.203 418.093 403.24 339.173 203.861 102.62 49.295 9.538 2.155 0];
    T = interp1(RawDataTime,RawDataThrust,t);
end