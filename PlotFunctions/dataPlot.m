function dataPlot(data)
% This function takes a structure input and graphs it based on pre-established
% subsets in the structures. Would prefer to use Kalman filter for Gyro
% Note: Thinking of grouping all plot sets into 1 window each
set(0,'DefaultFigureWindowStyle','docked')
t = data.time;
%% Positions 
pX = data.position.Xposition; % (make sure these are row vectors)
pY = data.position.Yposition;
pZ = data.position.Zposition;
pMag = data.position.magnitude;
alt = data.position.altitude;

%Altitude
figure('Name','Position','NumberTitle','off')
subplot(1,2,1)
plot(t,alt)
title('Altitude')
xlabel('Time [s]'); ylabel('Altitude [ft]')
grid on

%Ground Track plot
subplot(1,2,2)
plot(pX,pY)
title('Ground Track')
xlabel('Position X [ft]'); ylabel('Position Y [ft]')
grid on

% Arclength (I dont think this should be in this file lol
positions = [pX',pY',pZ']; %assuming pX,Y,Z are row vectors
distList = zeros(1,length(pX)-1);
for i = 2:length(t)
    dist = norm(positions(i,:)-positions(i-1,:)); % mag(Avec - Bvec)
    distList(i-1) = dist; 
end
totalDist = norm(abs(distList));

%% Velocities
% vX = data.velocity.Xvelocity;
% vY = data.velocity.Yvelocity;
% vZ = data.velocity.Zvelocity;
vMag = data.velocity.magnitude;

%Velocity plot
figure('Name','Vel','NumberTitle','off')
hold on
% plot(t,vX)
% plot(t,vY)
% plot(t,vZ)
plot(t,vMag)
title('Velocity')
xlabel('Time [s]'); ylabel('Velocity [?]')
legend(['vX','vY','vZ','vMag'])
grid on
hold off

%% Acceleration
aX = data.acceleration.Xacceleration;
aY = data.acceleration.Yacceleration;
aZ = data.acceleration.Zacceleration;
aMag = data.acceleration.magnitude;

%Acceleration plot
figure('Name','Accel','NumberTitle','off')
hold on
% plot(t,vX)
% plot(t,vY)
% plot(t,vZ)
plot(t,vMag)
title('Acceleration')
xlabel('Time [s]'); ylabel('Acceleration [?]')
legend(['aX','aY','aZ','aMag'])


%% Gyro [needs edit]
roll = data.gyro.roll;
pitch = data.gyro.pitch;
yaw = data.gyro.yaw;
tilt = data.gyro.tilt;

%Gyro plots
figure('Name','Gyro','NumberTitle','off')
subplot(2,2,1)
plot(t,roll)
title('Roll')
xlabel('Time (s)'); ylabel('angle [?]')
grid on

subplot(2,2,2)
plot(t,pitch)
title('Pitch')
xlabel('Time (s)'); ylabel('angle [?]')
grid on

subplot(2,2,3)
plot(t,yaw)
title('Yaw')
xlabel('Time (s)'); ylabel('angle [?]')
grid on

subplot(2,2,4)
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
