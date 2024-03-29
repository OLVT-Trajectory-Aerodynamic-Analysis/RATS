% This is the command center of the project. This function is like the
% center of the spider web, everything is called from here. First the data
% is converted from the rawData format to the SDFormat. Next the manager
% determines which plotting functions to call, and does that

% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

% @param sourceList is the list of sources in the source datatype. This
%   means that it is in the struct format
% @param config is all of the configurable parameters that might be needed
%   for the system. They are listed below
%   There are currently no config variables.
% 

function [] = manager(sourceList, rasAeroIILaunchSite, configs, rocket)
    %% Initialize Variables
    numSources = length(sourceList);
    processedData = {};

    %% Deal with rocket parameters
    rocket = createRocketParameters(rocket);

    %% Get raw data into SD format
    disp("Processing data ...")
    for sourceNum = 1:numSources
        processedData{sourceNum} = createSDFormat(sourceList(sourceNum), rasAeroIILaunchSite, rocket);
    end

    %%  Kalman filer
    disp("Filtering data ...")
    filteredData = filterData(processedData);

    %% Call plotting functions

    % To output just the main things (altitude, tilt, vel, accel, atm,
    % MaxQ) for all sources, use plotAllSources. It iterates through all 
    % the sensors and overlays their data.
    if (configs.plotDataSources.Plot == 1)
        disp("Plotting All Sources of Data ...")
        if (configs.plotDataSources.SingleFigure == 1)
            plotAllSourcesOneFigure(processedData, configs, rocket)
        else
            plotAllSources(processedData, configs, rocket)
        end
    end

    if (configs.plotDifferences.Plot == 1)
        disp("Differences Sources of Data ...")
        plotDifferences(processedData, configs, rocket)
    end

    % Plot Filtered Data here
%     if (configs.plotFilteredData.Plot)
%         disp("Add some plotting stuff here ...")
%     end
end