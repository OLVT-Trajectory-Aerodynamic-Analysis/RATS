% This is the file that handles all of the ploitting functionality, for now
% at least
% 
% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

function plotFlights(sourceList, config, rocket)
% This function creates plots of the main data (altitude, tilt, vel,
% accel, atm), the data collected from each sensor is overlayed into one plot 

% Initialize the Figures
set(0,'DefaultFigureWindowStyle','docked')
figure('Name','Height','NumberTitle','off')
hold on; grid on
figure('Name','Vel','NumberTitle','off')
hold on; grid on
figure('Name','Accel','NumberTitle','off')
hold on; grid on
figure('Name','Gyro','NumberTitle','off')
hold on; grid on
figure('Name','Atmosphere','NumberTitle','off')
hold on; grid on
figure('Name','MaxQ','NumberTitle','off')
hold on; grid on
figure('Name', 'Drag', 'NumberTitle', 'off')
hold on; grid on;

%% Create legendList
legendList = strings(1, length(sourceList) );
for i = 1:length(sourceList)
    legendList(1, i) = sourceList{1, i}.dataTitle;
end



%% Graph Positions 
figure(1)
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    altitude = sourceList{1, i}.position.Zposition;
    plot(time, altitude)
    hold on
end
title('Height')
xlabel('Time [s]'); ylabel('Height above launchpad [m]')
legend(legendList)
hold off

%% Graph Velocities
figure(2)
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    plot(time, vMag)
    hold on
end
title('Velocity')
xlabel('Time [s]'); ylabel('Velocity [m s^-1]')
legend(legendList)
hold off

%% Graph Acceleration
figure(3)
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    aMag = sourceList{1, i}.acceleration.magnitude;
    plot(time, abs(aMag))
    hold on
end
title('Acceleration')
xlabel('Time [s]'); ylabel('Acceleration [m s^-2]')
legend(legendList)
hold off

%% Graph Gyro [needs edit]
figure(4)
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    tilt = sourceList{1, i}.gyro.tilt;
    %Gyro plots
    plot(time, tilt)
    hold on
end
title('Tilt')
xlabel('Time (s)'); ylabel('angle [degrees]')
legend(legendList)
hold off
%% Graph Atmosphere
figure (5)

tiledlayout(3, 1)

% Pressure
nexttile
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmP = sourceList{1, i}.atmosphere.pressure;

    plot(time, atmP)
    hold on
end
xlabel('Time [s]'); ylabel('Pressure [Pa]')
grid on
hold off

nexttile
% Temperature
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmT = sourceList{1, i}.atmosphere.temperature;

    plot(time, atmT)
    hold on
end
xlabel('Time [s]'); ylabel('Temperature [K]')
grid on
hold off

nexttile
% Density
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmD = sourceList{1, i}.atmosphere.density;

    plot(time, atmD)
    hold on
end
xlabel('Time [s]'); ylabel('Density [kg m^-3]')
grid on
hold off

leg = legend(legendList, 'Orientation', 'Horizontal');
leg.Layout.Tile = 'north';


%% Max Q
figure(6)
tiledlayout(1, 2);

nexttile
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(time, dynamicPressure)
    hold on
end
title('MaxQ v Time')
xlabel('Time [s]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off
    
nexttile
for i = 1:length(sourceList)
    altitude = sourceList{1, i}.position.altitude;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(altitude, dynamicPressure)
    hold on
end
title('MaxQ v altitude')
xlabel('Altitude [m]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off

leg = legend(legendList, 'Orientation', 'Horizontal');
leg.Layout.Tile = 'north';

%% Drag plots
% Here we only want to plot drag during coast phase, so cut after burntime
% and after apogee


figure(7);
for i = 1:length(sourceList)
   time = sourceList{1, i}.time;
   altitude = sourceList{1, i}.position.altitude;
   dragAccel = sourceList{1, i}.performance.dragAcc;

   [~, iMaxAlt] = max(altitude);
   iCoast = find(time > rocket.sustainerMotorBurnTime & time <= time(iMaxAlt));

   plot(time(iCoast), dragAccel(iCoast))
   hold on
end
title('Drag Acceleration v Time')
xlabel('Time [s]'); ylabel('Drag Acceleration [m s^-2]')
grid on
hold off
xlim([0 inf])

legend(legendList)


config = config;
end
