% This function gives you all the important parameters you need from the
% motor inputted

% Contributors
% @author Michael Plano
% @created 11/2023
% 

function [rocket] = createRocketParameters(rocket)
    %% This is to fix a null error
    boosterWeight = 0;
    boosterPropWeight = 0;
    boosterBurnTime = 0;

    %% Get Sustainer Stats
    url = strcat('https://www.thrustcurve.org/motors/AeroTech/', rocket.sustainerMotor, '/');
    % Read the webpage content
    webpage = webread(url);
    
    % Extract Total Weight
    sustainerWeightPattern = 'Total Weight.*?(\d+)\s*g';
    sustainerWeightTokens = regexp(webpage, sustainerWeightPattern, 'tokens');
    sustainerWeight = str2double(sustainerWeightTokens{1});
    
    % Extract Prop. Weight
    sustainerPropWeightPattern = 'Prop\. Weight.*?(\d+)\s*g';
    sustainerPropWeightTokens = regexp(webpage, sustainerPropWeightPattern, 'tokens');
    sustainerPropWeight = str2double(sustainerPropWeightTokens{1});
    
    % Extract Burn Time
    sustainerBurnTimePattern = 'Burn Time.*?(\d+.\d+)\s*s';
    sustainerBurnTimeTokens = regexp(webpage, sustainerBurnTimePattern, 'tokens');
    sustainerBurnTime = str2double(sustainerBurnTimeTokens{1});

    rocket.sustainerMotorWeight = sustainerWeight / 1000;
    rocket.sustainerMotorPropWeight = sustainerPropWeight / 1000;
    rocket.sustainerMotorBurnTime = sustainerBurnTime;

    rocket.sustainerWeight = rocket.sustainerUnloadedWeight + rocket.sustainerMotorWeight;


    %% Get booster weights
    if (rocket.boosterMotor ~= "null")
        url = strcat('https://www.thrustcurve.org/motors/AeroTech/', rocket.boosterMotor, '/');
        % Read the webpage content
        webpage = webread(url);
        
        % Extract Total Weight
        boosterWeightPattern = 'Total Weight.*?(\d+)\s*g';
        boosterWeightTokens = regexp(webpage, boosterWeightPattern, 'tokens');
        boosterTotalWeight = str2double(boosterWeightTokens{1});
        
        % Extract Prop. Weight
        boosterPropWeightPattern = 'Prop\. Weight.*?(\d+)\s*g';
        boosterPropWeightTokens = regexp(webpage, boosterPropWeightPattern, 'tokens');
        boosterPropWeight = str2double(boosterPropWeightTokens{1});
        
        % Extract Burn Time
        boosterBurnTimePattern = 'Burn Time.*?(\d+.\d+)\s*s';
        boosterBurnTimeTokens = regexp(webpage, boosterBurnTimePattern, 'tokens');
        boosterBurnTime = str2double(boosterBurnTimeTokens{1});
        
        rocket.boosterMotorWeight = boosterTotalWeight / 1000;
        rocket.boosterMotorPropWeight = boosterPropWeight / 1000;
        rocket.boosterMotorBurnTime = boosterBurnTime;

        boosterWeight = rocket.boosterMotorWeight + rocket.totalUnloadedWeight;
    end

    rocket.totalWeight = rocket.sustainerWeight + boosterWeight;
end