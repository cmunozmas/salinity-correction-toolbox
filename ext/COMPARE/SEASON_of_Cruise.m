function [SEASON,MNTHS] = SEASON_of_Cruise(Campaign,TYPE,STARTdate)
%
%
% Code description: This code takes the ship file name (which typically
% includes either the start date or the season in its name) or glider file
% name and corresponding start date of the glider campaign, and assigns a
% corresponding season.
%
% INPUT:  Camapign  = filename of glider or ship campaign
%         TYPE      = SHIP or GLIDER
%         STARTdate = If TYPE == GLIDER, this is the start date of the campaign 
%
% OUTPUT: SEASON    = the season based on the start date of the campaign,
% where
           % Winter   = January, February or March
           % Spring   = April, May or June
           % Summer   = July, August, September
           % December = October, November, December 
%
% ***COMMENT: should I change my defiition of the seasons? June to
% September for Summer, and January and February for Winter?
%
% Author: Krissy Reeve (kreeve@socib.es)
% Date created: 21/03/2016


% Finds Ship campaigns with matching season:
if strcmpi(TYPE,'SHIP')==1
    tmpry = regexpi(Campaign.Test,{'Winter','Spring','Summer','Autumn'});
        counter = 1;
        while isempty(tmpry{counter})==1
            counter=counter+1;
            if counter==5
                counter=10;
                break
            end
        end
        clear tmpry
        if counter==10
            % if file name has a month, not a season, assign correct
            % season:
            tmpry = regexpi(Campaign.Test,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
            counter = 1;
            while isempty(tmpry{counter})==1
                counter=counter+1;
                if counter==13
                    counter=10;
                    break
                end
            end
            clear tmpry
            if counter==10;
                % if the filename format does not fit with the structure above, manually assign season to test campaign:
                [tmprySEASON,~]=listdlg('PromptString','Season of test campaign:',...
                    'SelectionMode','single','ListString',{'Winter','Spring','Summer','Autumn'});
                if tmprySEASON == 1
                    SEASON = 'Winter';
                    MNTHS = {'Jan','Feb','Mar'};
                elseif tmprySEASON == 2
                    SEASON = 'Spring';
                    MNTHS = {'Apr','May','Jun'};
                elseif tmprySEASON == 3
                    SEASON = 'Summer';
                    MNTHS = {'Jul','Aug','Sep'};
                elseif tmprySEASON == 4
                    SEASON = 'Autumn';
                    MNTHS = {'Oct','Nov','Dec'};
                end
                %MNTH = [];
            else
                if counter <=3
                    SEASON = 'Winter';
                    MNTHS = {'Jan','Feb','Mar'};
                elseif counter >=4 && counter <=6
                    SEASON = 'Spring';
                    MNTHS = {'Apr','May','Jun'};
                elseif counter >=7 && counter <=9
                    SEASON = 'Summer';
                    MNTHS = {'Jul','Aug','Sep'};
                elseif counter >=10 && counter <=12
                    SEASON = 'Autumn';
                    MNTHS = {'Oct','Nov','Dec'};
                end
                %MNTH = counter;
            end
        else
            if counter == 1
                SEASON = 'Winter';
                MNTHS = {'Jan','Feb','Mar'};
            elseif counter == 2
                SEASON = 'Spring';
                MNTHS = {'Apr','May','Jun'};
            elseif counter == 3
                SEASON = 'Summer';
                MNTHS = {'Jul','Aug','Sep'};
            elseif counter == 4
                SEASON = 'Autumn';
                MNTHS = {'Oct','Nov','Dec'};
            end
            %MNTH = [];
        end
elseif strcmpi(TYPE,'GLIDER')
    % If input data is from a glider, then take the start data (input data
    % requirement) and assign a corresponding season:
    mnth=str2double(datestr(STARTdate,'mm'));
    if mnth<=3
        SEASON = 'Winter';
        MNTHS = {'Jan','Feb','Mar'};
    end
    if mnth>=4 && mnth<=6
        SEASON = 'Spring';
        MNTHS = {'Apr','May','Jun'};
    end
    if mnth>=7 && mnth<=9
        SEASON = 'Summer';
        MNTHS = {'Jul','Aug','Sep'};
    end
    if mnth>=10
        SEASON = 'Autumn';
        MNTHS = {'Oct','Nov','Dec'};
    end
end