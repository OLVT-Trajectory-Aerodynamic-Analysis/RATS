function struct = TelemetrumCSVToStd(csv, title)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a Telemetrum csv file to a standardized data structure
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
    %% Parsing Input:
    fixed = StandardTime(csv,5);
    
    %% Operational Code:
    struct.dataType = "Telemetrum";
    struct.dataTitle = title;

    struct.time = fixed(:,5);                           % [s] 
    
    struct.position.magnitude = [];
    struct.position.altitude = fixed(:,12);             % [m]
    struct.position.Xposition = [];
    struct.position.Yposition = [];
    struct.position.Zposition = fixed(:,13);            % [m]
    
    struct.velocity.magnitude = fixed(:,14);            % [m/s]
    struct.velocity.Xvelocity = []; 
    struct.velocity.Yvelocity = [];
    struct.velocity.Zvelocity = [];
    
    struct.acceleration.Xacceleration = fixed(:,19);    % [m/s^2]
    struct.acceleration.Yacceleration = fixed(:,20);    % [m/s^2]
    struct.acceleration.Zacceleration = fixed(:,21);    % [m/s^2]
    struct.acceleration.magnitude = fixed(:,10);         % [m/s^2]

    struct.gyro.roll = fixed(:,22);                     % [degrees]
    struct.gyro.pitch = fixed(:,23);                    % [degrees]
    struct.gyro.yaw = fixed(:,24);                      % [degrees]
    struct.gyro.tilt = fixed(:,28);                     % [degrees]
    
    struct.atmosphere.pressure = fixed(:,11);            % [Pa]
    struct.atmosphere.temperature = fixed(:,15) + 273.15;        % [K]
    struct.atmosphere.density = ...
        struct.atmosphere.pressure ./ (287.1 * struct.atmosphere.temperature);

    struct.performance.dragAcc = calculateDragAcceleration(struct);
    end