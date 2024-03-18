function [] = plotDifferences(processedData, configs, rocket)
%% Separate Data

for i=1:length(processedData)

    if processedData{1, i}.dataTitle == "RasAeroII Data"
      RAS_time=processedData{1, i}.time;
      RAS_velocity=processedData{1,i}.velocity.magnitude;
      RAS_Zposition=processedData{1,i}.position.Zposition;
      RAS_altitude=processedData{1,i}.position.altitude;
      RAS_acceleration_mag=processedData{1,i}.acceleration.magnitude;
    elseif processedData{1, i}.dataTitle== "Telemega Data"
      TELE_time=processedData{1, i}.time;
      TELE_velocity=processedData{1,i}.velocity.magnitude;
      TELE_Zposition=processedData{1,i}.position.Zposition;
      TELE_altitude=processedData{1,i}.position.altitude;
      TELE_acceleration_mag=processedData{1,i}.acceleration.magnitude;
    elseif processedData{1, i}.dataTitle=="BlueRaven Data"
      Raven_time=processedData{1,i}.time;
      Raven_velocity=processedData{1,i}.velocity.magnitude;
      Raven_Zposition=processedData{1,i}.position.Zposition;
      Raven_altitude=processedData{1,i}.position.altitude;
      Raven_acceleration_mag=processedData{1,i}.acceleration.magnitude;
    end
end

%% Create uniform time vectors
% Determine the start and end times for the uniform time vector

%RAS and Blue Raven
start_time = min([min(RAS_time) min(Raven_time) min(TELE_time)]);
end_time = max([max(RAS_time) max(Raven_time) max(TELE_time)]);

% Create a uniform time vector from the earliest start to the latest end with a step of 0.1
uniform_time = (start_time:0.1:end_time)';


%% Initialize vectors to hold aligned property values values


RAS_velocity_aligned = zeros(length(uniform_time), 1);
RAS_Zposition_aligned= zeros(length(uniform_time), 1);
RAS_altitude_aligned=zeros(length(uniform_time), 1);
RAS_acceleration_mag_aligned=zeros(length(uniform_time), 1);

Raven_velocity_aligned = zeros(length(uniform_time), 1);
Raven_Zposition_aligned=zeros(length(uniform_time), 1);
Raven_altitude_aligned=zeros(length(uniform_time), 1);
Raven_acceleration_mag_aligned=zeros(length(uniform_time), 1);


TELE_velocity_aligned= zeros(length(uniform_time), 1);
TELE_Zposition_aligned=zeros(length(uniform_time), 1);
TELE_altitude_aligned=zeros(length(uniform_time), 1);
TELE_acceleration_mag_aligned=zeros(length(uniform_time), 1);
%% Align different data vectors
%these loops create the new property vectors. 
%the initialized vectors currently hold zeros that span the uniform time
%vector. The loop will fill in the values that the sensor provides for the
%time values that match the uniform time vector. If the sensor does not have
%a value for the time in the uniform time vector, it will remain zero.


tolerance = 1e-5; % Define tolerance for matching times
                  %If the difference is greater than this, they do not
                  %match
%RAS 
for i = 1:length(RAS_time)
    % Calculate the absolute difference between RAS_time(i) and all uniform_time values
    %Index corresponds to the position in the uniform time vector
    [minValue, index] = min(abs(uniform_time - RAS_time(i)));
    
    % Check if the closest match is within the tolerance
    %if match, assign the value to the aligned vector
    if minValue <= tolerance
        RAS_velocity_aligned(index) = RAS_velocity(i);
        RAS_Zposition_aligned(index)=RAS_Zposition(i);
        RAS_altitude_aligned(index)=RAS_altitude(i);
        RAS_acceleration_mag_aligned(index)=RAS_acceleration_mag(i);
    end
end

%Blue Raven
for i = 1:length(Raven_time)
    [minValue, index] = min(abs(uniform_time - Raven_time(i)));
    
    if minValue <= tolerance
        Raven_velocity_aligned(index) = Raven_velocity(i);
        Raven_Zposition_aligned(index)=Raven_Zposition(i);
        Raven_altitude_aligned(index)=Raven_altitude(i);
        Raven_acceleration_mag_aligned(index)=Raven_acceleration_mag(i);
    end
end

%Telemega
for i = 1:length(TELE_time)
    [minValue, index] = min(abs(uniform_time - TELE_time(i)));
    
    if minValue <= tolerance
        TELE_velocity_aligned(index) = TELE_velocity(i);
        TELE_Zposition_aligned(index)=TELE_Zposition(i);
        TELE_altitude_aligned(index)=TELE_altitude(i);
        TELE_acceleration_mag_aligned(index)=TELE_acceleration_mag(i);
    end
end
%%

Target=(configs.plotFilteredData.target);
if (configs.plotFilteredData.target) == "BlueRaven Data"
Target_vel=Raven_velocity_aligned;
Target_Zposition=Raven_Zposition_aligned;
Target_Altitude=Raven_altitude_aligned;
Target_acceleration_mag=Raven_acceleration_mag_aligned;
elseif (configs.plotFilteredData.target)=="Telemega Data"
    Target_vel=TELE_velocity_aligned;
    Target_Zposition=TELE_Zposition_aligned;
    Target_Altitude=TELE_altitude_aligned;
    Target_acceleration_mag=TELE_acceleration_mag_aligned;
elseif (configs.plotFilteredData.target)=="RasAeroII Data"
    Target_vel=RAS_velocity_aligned;
    Target_Zposition=RAS_Zposition_aligned;
    Target_Altitude=RAS_altitude_aligned;
    Target_acceleration_mag=RAS_acceleration_mag_aligned;
 end


%% Calculate the differences in aligned data

%velocity
RAS_vs_Target_velo = Target_vel-RAS_velocity_aligned;
TELE_vs_Target_velo = Target_vel-TELE_velocity_aligned;
Raven_vs_Target_velo = Target_vel-Raven_velocity_aligned;

Target_RAS_ratio_velo =Target_vel./RAS_velocity_aligned;
Target_TELE_ratio_velo =Target_vel./TELE_velocity_aligned;
Target_Raven_ratio_velo =Target_vel./Raven_velocity_aligned;

%Z position
RAS_vs_Target_Zposition=Target_Zposition-RAS_Zposition_aligned;
TELE_vs_Target_Zposition=Target_Zposition-TELE_Zposition_aligned;
Raven_vs_Target_Zposition=Target_Zposition-Raven_Zposition_aligned;

Target_RAS_ratio_Zposition=Target_Zposition./RAS_Zposition_aligned;
Target_TELE_ratio_Zposition=Target_Zposition./TELE_Zposition_aligned;
Target_Raven_ratio_Zposition=Target_Zposition./Raven_Zposition_aligned;

%Altitdue
RAS_vs_Target_alt=Target_Altitude-RAS_altitude_aligned;
TELE_vs_Target_alt=Target_Altitude-TELE_altitude_aligned;
Raven_vs_Target_alt=Target_Altitude-Raven_altitude_aligned;

Target_RAS_ratio_alt=Target_Altitude./RAS_altitude_aligned;
Target_TELE_ratio_alt=Target_Altitude./TELE_altitude_aligned;
Target_Raven_ratio_alt=Target_Altitude./Raven_altitude_aligned;


%Acceleration Magnitude
RAS_vs_Target_acceleration_mag=Target_acceleration_mag-RAS_acceleration_mag_aligned;
TELE_vs_Target_acceleration_mag=Target_acceleration_mag-TELE_acceleration_mag_aligned;
Raven_vs_Target_acceleration_mag=Target_acceleration_mag-Raven_acceleration_mag_aligned;

Target_RAS_ratio_acceleration_mag=Target_acceleration_mag./RAS_acceleration_mag_aligned;
Target_TELE_ratio_acceleration_mag=Target_acceleration_mag./TELE_acceleration_mag_aligned;
Target_Raven_ratio_acceleration_mag=Target_acceleration_mag./Raven_acceleration_mag_aligned;

%% Graph stuff


    set(0, 'DefaultAxesFontSize', 15);
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0,'DefaultFigureWindowStyle','docked')
    titleSz = 30;
    lineWidth = 2;
    
    
    % Velocity Magnitude
    fig1 = figure();
    fig1.Name = "Velocity Difference";
   
    if any(RAS_vs_Target_velo ~= 0)
    
    plot(uniform_time, RAS_vs_Target_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " - RAS")
    hold on
    plot(uniform_time, Target_RAS_ratio_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " / RAS")
    end 
    if any(TELE_vs_Target_velo ~= 0)
    
    plot(uniform_time, TELE_vs_Target_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " - TELE")
    hold on
    plot(uniform_time, Target_TELE_ratio_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " / TELE")
    end

    if any(Raven_vs_Target_velo ~= 0)
    
    plot(uniform_time, Raven_vs_Target_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " - Raven ")
    hold on
    plot(uniform_time, Target_Raven_ratio_velo, 'LineWidth', lineWidth, 'DisplayName', Target + " / Raven")
    end
hold off

    plotXlines(configs.plotDataSources,  rocket, fig1)
    trimAxis(configs.plotDataSources, processedData{1, 1})
    title("RAS vs. Blue Raven Velocity Mag.", 'FontName', 'Times New Roman', 'FontSize', titleSz)
    xlabel('Time [s]'); ylabel('Velocity Mag. [m/s]')
    legend('Location', 'best')
    grid on
    grid minor


    %Z Position 
    fig2 = figure();
    fig2.Name = "Z-Position Difference";
   
    if any(RAS_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, RAS_vs_Target_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " - RAS")
    hold on
    plot(uniform_time, Target_RAS_ratio_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " / RAS")
    end 
    if any(TELE_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, TELE_vs_Target_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " - TELE")
    hold on
    plot(uniform_time, Target_TELE_ratio_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " / TELE")
    end

    if any(Raven_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, Raven_vs_Target_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " - Raven ")
    hold on
    plot(uniform_time, Target_Raven_ratio_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " / Raven")
    end
hold off

    plotXlines(configs.plotDataSources,  rocket, fig2)
    trimAxis(configs.plotDataSources, processedData{1, 1})
    title("RAS vs. Blue Raven Z-Position ", 'FontName', 'Times New Roman', 'FontSize', titleSz)
    xlabel('Time [s]'); ylabel('Position Mag. [m]')
    legend('Location', 'best')
    grid on
    grid minor


    %Altitude
    fig3 = figure();
    fig3.Name = "Altitude Difference";
   
    if any(RAS_vs_Target_alt ~= 0)
    
    plot(uniform_time, RAS_vs_Target_alt, 'LineWidth', lineWidth, 'DisplayName', Target + " - RAS")
    hold on
    plot(uniform_time, Target_RAS_ratio_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " / RAS")
    end 
    if any(TELE_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, TELE_vs_Target_alt, 'LineWidth', lineWidth, 'DisplayName', Target + " - TELE")
    hold on
    plot(uniform_time, Target_TELE_ratio_alt, 'LineWidth', lineWidth, 'DisplayName', Target + " / TELE")
    end

    if any(Raven_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, Raven_vs_Target_alt, 'LineWidth', lineWidth, 'DisplayName', Target + " - Raven ")
    hold on
    plot(uniform_time, Target_Raven_ratio_alt, 'LineWidth', lineWidth, 'DisplayName', Target + " / Raven")
    end
hold off

    plotXlines(configs.plotDataSources,  rocket, fig3)
    trimAxis(configs.plotDataSources, processedData{1, 1})
    title("RAS vs. Blue Raven Altitude", 'FontName', 'Times New Roman', 'FontSize', titleSz)
    xlabel('Time [s]'); ylabel('Altitude [m]')
    legend('Location', 'best')
    grid on
    grid minor

    %Acceleration Magnitude
    fig4 = figure();
    fig4.Name = "Acceleration Difference";
   
   if any(RAS_vs_Target_acceleration_mag ~= 0)
    
    plot(uniform_time, RAS_vs_Target_acceleration_mag, 'LineWidth', lineWidth, 'DisplayName', Target + " - RAS")
    hold on
    plot(uniform_time, Target_RAS_ratio_Zposition, 'LineWidth', lineWidth, 'DisplayName', Target + " / RAS")
    end 
    if any(TELE_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, TELE_vs_Target_acceleration_mag, 'LineWidth', lineWidth, 'DisplayName', Target + " - TELE")
    hold on
    plot(uniform_time, Target_TELE_ratio_acceleration_mag, 'LineWidth', lineWidth, 'DisplayName', Target + " / TELE")
    end

    if any(Raven_vs_Target_Zposition ~= 0)
    
    plot(uniform_time, Raven_vs_Target_acceleration_mag, 'LineWidth', lineWidth, 'DisplayName', Target + " - Raven ")
    hold on
    plot(uniform_time, Target_Raven_ratio_acceleration_mag, 'LineWidth', lineWidth, 'DisplayName', Target + " / Raven")
    end
hold off
    plotXlines(configs.plotDataSources,  rocket, fig4)
    trimAxis(configs.plotDataSources, processedData{1, 1})
    title("RAS vs. Blue Raven Acceleration", 'FontName', 'Times New Roman', 'FontSize', titleSz)
    xlabel('Time [s]'); ylabel('Acceleration [m/s^2]')
    legend('Location', 'best')
    grid on
    grid minor

    
end