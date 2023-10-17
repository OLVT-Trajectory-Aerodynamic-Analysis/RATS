function plotFlight(data,config)
set(0,'DefaultFigureWindowStyle','docked')
t = data.time;
%% Positions 
%Altitude
hold on
alt = data.position.altitude;
figure('Name','Position','NumberTitle','off')
plot(t,alt)
title('Altitude')
xlabel('Time [s]'); ylabel('Altitude [ft]')
grid on
%% Velocities
vMag = data.velocity.magnitude;

%Velocity plot
figure('Name','Vel','NumberTitle','off')
plot(t,vMag)
title('Velocity')
xlabel('Time [s]'); ylabel('Velocity [?]')
legend('vMag')
grid on

%% Acceleration
aMag = data.acceleration.magnitude;

%Acceleration plot
figure('Name','Accel','NumberTitle','off')
hold on
plot(t,vMag)
title('Acceleration')
xlabel('Time [s]'); ylabel('Acceleration [?]')
legend('aMag')
grid on
%% Gyro [needs edit]
tilt = data.gyro.tilt;

%Gyro plots
figure('Name','Gyro','NumberTitle','off')
plot(t,tilt)
title('Tilt')
xlabel('Time (s)'); ylabel('angle [?]')
grid on

%% Atmosphere
atmP = data.atmosphere.pressure;
atmT = data.atmosphere.temperature;
atmD = data.atmosphere.density;

%Atmosphere plots: Thinking of putting all 3 of these into 1 window
figure('Name','Atmosphere','NumberTitle','off')
subplot(2,2,1)
plot(atmP,alt)
title('Pressure')
xlabel('Pressure [?]'); ylabel('Altitude [ft]')
grid on

subplot(2,2,2)
plot(atmT,alt)
title('Temperature')
xlabel('Temperature [?]'); ylabel('Altitude [ft]')
grid on

subplot(2,2,3)
plot(atmD,alt)
title('Density')
xlabel('Density [?]'); ylabel('Altitude [ft]')
grid on

%% Max Q (Idk where to put this)
figure('Name','MaxQ','NumberTitle','off')
dynamicPressure = (atmD.*(vMag.^2))/2; % assuming it has the same # of rows

subplot(1,2,1)
plot(t,dynamicPressure)
title('MaxQ v Time')
xlabel('Time [s]'); ylabel('Dynamic Pressure [?]')
grid on

subplot(1,2,2)
plot(alt,dynamicPressure)
title('MaxQ v Altitude')
xlabel('Dynamic Pressure [?]'); ylabel('Altitude [ft]'); 
grid on
end
