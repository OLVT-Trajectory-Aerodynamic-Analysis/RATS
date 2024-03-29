function struct = RasCSVToStd(csv, title, rasAeroIILaunchSite)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a RASAeroII csv file to a standardized data structure
    %
    %% Input:
    %  csv:     The name of the csv file containing the initial data
    %
    %% Output:
    %  struct:  A standardized data structure
    %
    %% Contributors:
    %  @author Austin Zary
    %  @created 10/03/2023
    %
    %  @editor Michael Plano
    % 
    %% Parsing Input:
    fixed = StandardTime(csv,1);
    
    %% Unit Conversion for Launch Site
    rasAeroIILaunchSite.elevation = rasAeroIILaunchSite.elevation_ft * 0.3048;
    rasAeroIILaunchSite.temperature = ...
        (5/9)*(rasAeroIILaunchSite.temperature_F - 32) + 273.15;
    if (rasAeroIILaunchSite.pressure_inhg ~= "null")
        rasAeroIILaunchSite.pressure = rasAeroIILaunchSite.pressure_inhg * 3386.39;
    end
    rasAeroIILaunchSite.windSpeed = rasAeroIILaunchSite.windSpeed_mph * 0.44704;
    rasAeroIILaunchSite.launchRailLength = rasAeroIILaunchSite.launchRailLength_ft * 0.3048;

    %% Operational Code:
    struct.dataType = "RasAeroII";
    struct.dataTitle = title;

    struct.time = fixed(:,1);
    
    struct.position.magnitude = sqrt((fixed(:,23)).^2 + (fixed(:,24).^2)) * 0.3048; % [m]
    struct.position.altitude = (fixed(:,23)) * 0.3048 + rasAeroIILaunchSite.elevation;
    %struct.position.Xposition = null;
    %struct.position.Yposition = null;
    struct.position.Zposition = fixed(:,23) * 0.3048; % [m]
    
    struct.velocity.magnitude = sqrt((fixed(:,19)).^2 + (fixed(:,20)).^2) * 0.3048; % [m/s]
    %struct.velocity.Xvelocity = null;
    %struct.velocity.Yvelocity = null;
    struct.velocity.Zvelocity = fixed(:,19) * 0.3048; % [m/s]
    
    struct.acceleration.magnitude = sqrt((fixed(:,16)).^2 + (fixed(:,17)).^2) * 0.3048; % [m/s2]
    %struct.acceleration.Xacceleration = null;
    %struct.acceleration.Yacceleration = null;
    struct.acceleration.Zacceleration = fixed(:,16) * 0.3048; % [m/s2]
    
    %struct.gyro.roll = null;
    %struct.gyro.pitch = null;
    %struct.gyro.yaw = null;
    struct.gyro.tilt = abs(fixed(:,21) - 90); % []

    % Launch site cond need to be factoered in here
    [struct.atmosphere.temperature,~, ...
        struct.atmosphere.pressure, ...
        struct.atmosphere.density] = atmoscoesa(struct.position.altitude);



    struct.performance.dragAcc = fixed(:,10);

    end