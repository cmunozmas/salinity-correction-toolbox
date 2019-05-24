function [ GUESS, AXISlims ] = phase_2_run_whitespace( Campaign, CTD, buttonMC, TESTdat, CtdCorrDataFile, depNUM_glider )
% WHITESPACE MAXIMISATION METHOD FOR CORRECTING GLIDER DATA: 
%       create vectors of background data using the chosen data from the previous step: an iterative process tests correction coefficients that allow the test (glider)
%       data to align with the background data in a TS diagram - the iterative procedure stops at the point at which the whitespace area of the TSdiagram is maximised. 

global MainPath

% 3a) backgrnd comparison data for the whitespace maximisation correction method; combine and rearrange into a structure of vectors:
counter=1;
RANGE = size(Campaign.COMP,1);
% for n1 = 1 : RANGE
%     if RANGE == 1
%         XX = Campaign.COMP;
%         %XX = XX{1};
%     else
%         XX = Campaign.COMP{n1};
%     end
%     if isfield(CTD.(XX).Corrected,'SALT_01')==1 && isfield(CTD.(XX).Corrected,'SALT_02')==1
%         ii=1:length(CTD.(XX).latitude);%find(CTD.(XX).longitude>2); %for Mallorca Channel only! 
%         tmpry.S       = [reshape(CTD.(XX).Corrected.SALT_01(:,ii),[],1);reshape(CTD.(XX).Corrected.SALT_02(:,ii),[],1)];
%         tmpry.T       = [reshape(CTD.(XX).t090C(:,ii),[],1);reshape(CTD.(XX).t190C(:,ii),[],1)];
%         tmpry.PT      = [reshape(CTD.(XX).Corrected.ptemp_01(:,ii),[],1);reshape(CTD.(XX).Corrected.ptemp_02(:,ii),[],1)];
%         tmpry.C       = [reshape(CTD.(XX).Corrected.COND_01(:,ii),[],1);reshape(CTD.(XX).Corrected.COND_02(:,ii),[],1)];
%         tmpry.Pr      = [reshape(CTD.(XX).Pressure(:,ii),[],1);reshape(CTD.(XX).Pressure(:,ii),[],1)];
%         tmpry.timeUTC = [reshape(repmat(CTD.(XX).timeUTC(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);reshape(repmat(CTD.(XX).timeUTC(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1)];
%         tmpry.Station = [reshape(repmat(CTD.(XX).Station(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);reshape(repmat(CTD.(XX).Station(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1)];
%         tmpry.Lat     = [reshape(repmat(CTD.(XX).latitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);reshape(repmat(CTD.(XX).latitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1)];
%         tmpry.Lon     = [reshape(repmat(CTD.(XX).longitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);reshape(repmat(CTD.(XX).longitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1)];
%         bgrndDAT.S(counter:(counter-1+length(tmpry.S)),1)       = tmpry.S;
%         bgrndDAT.T(counter:(counter-1+length(tmpry.T)),1)       = tmpry.T;
%         bgrndDAT.PT(counter:(counter-1+length(tmpry.T)),1)      = tmpry.PT;
%         bgrndDAT.C(counter:(counter-1+length(tmpry.T)),1)       = tmpry.C;
%         bgrndDAT.Pr(counter:(counter-1+length(tmpry.T)),1)      = tmpry.Pr;
%         bgrndDAT.timeUTC(counter:(counter-1+length(tmpry.T)),1) = tmpry.timeUTC;
%         bgrndDAT.Station(counter:(counter-1+length(tmpry.T)),1) = tmpry.Station;
%         bgrndDAT.Lat(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lat;
%         bgrndDAT.Lon(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lon;
%         counter=counter+length(tmpry.S)+1;
%     elseif isfield(CTD.(XX).Corrected,'SALT_01')==1 
%         ii=1:length(CTD.(XX).latitude);%find(CTD.(XX).longitude>2); %for Mallorca Channel only! 
%         tmpry.S       = reshape(CTD.(XX).Corrected.SALT_01(:,ii),[],1);
%         tmpry.T       = reshape(CTD.(XX).t090C(:,ii),[],1);
%         tmpry.PT      = reshape(CTD.(XX).Corrected.ptemp_01(:,ii),[],1);
%         tmpry.C       = reshape(CTD.(XX).Corrected.COND_01(:,ii),[],1);
%         tmpry.Pr      = reshape(CTD.(XX).Pressure(:,ii),[],1);
%         tmpry.timeUTC = reshape(repmat(CTD.(XX).timeUTC(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Station = reshape(repmat(CTD.(XX).Station(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Lat     = reshape(repmat(CTD.(XX).latitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Lon     = reshape(repmat(CTD.(XX).longitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         bgrndDAT.S(counter:(counter-1+length(tmpry.S)),1)       = tmpry.S;
%         bgrndDAT.T(counter:(counter-1+length(tmpry.T)),1)       = tmpry.T;
%         bgrndDAT.PT(counter:(counter-1+length(tmpry.T)),1)      = tmpry.PT;
%         bgrndDAT.C(counter:(counter-1+length(tmpry.T)),1)       = tmpry.C;
%         bgrndDAT.Pr(counter:(counter-1+length(tmpry.T)),1)      = tmpry.Pr;
%         bgrndDAT.timeUTC(counter:(counter-1+length(tmpry.T)),1) = tmpry.timeUTC;
%         bgrndDAT.Station(counter:(counter-1+length(tmpry.T)),1) = tmpry.Station;
%         bgrndDAT.Lat(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lat;
%         bgrndDAT.Lon(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lon;
%         counter=counter+length(tmpry.S)+1;
%     end
%     clear XX ii tmpry
% end
for n1 = 1 : RANGE
    if RANGE == 1
        XX = Campaign.COMP;
        %XX = XX{1};
    else
        XX = Campaign.COMP{n1};
    end
    if isfield(CTD.Corrected,'SALT_01')==1 && isfield(CTD.Corrected,'SALT_02')==1
        ii=1:length(CTD.latitude);%find(CTD.(XX).longitude>2); %for Mallorca Channel only! 
        tmpry.S       = [reshape(CTD.Corrected.SALT_01(:,ii),[],1);reshape(CTD.Corrected.SALT_02(:,ii),[],1)];
        tmpry.T       = [reshape(CTD.temp_01(:,ii),[],1);reshape(CTD.temp_02(:,ii),[],1)];
        tmpry.PT      = [reshape(CTD.Corrected.ptemp_01(:,ii),[],1);reshape(CTD.Corrected.ptemp_02(:,ii),[],1)];
        tmpry.C       = [reshape(CTD.Corrected.COND_01(:,ii),[],1);reshape(CTD.Corrected.COND_02(:,ii),[],1)];
        tmpry.Pr      = [reshape(CTD.pressure(:,ii),[],1);reshape(CTD.pressure(:,ii),[],1)];
        tmpry.Lat     = [reshape(repmat(CTD.latitude(ii),size(CTD.pressure(:,ii),1),1),[],1);reshape(repmat(CTD.latitude(ii),size(CTD.pressure(:,ii),1),1),[],1)];
        tmpry.Lon     = [reshape(repmat(CTD.longitude(ii),size(CTD.pressure(:,ii),1),1),[],1);reshape(repmat(CTD.longitude(ii),size(CTD.pressure(:,ii),1),1),[],1)];
        bgrndDAT.S(counter:(counter-1+length(tmpry.S)),1)       = tmpry.S;
        bgrndDAT.T(counter:(counter-1+length(tmpry.T)),1)       = tmpry.T;
        bgrndDAT.PT(counter:(counter-1+length(tmpry.T)),1)      = tmpry.PT;
        bgrndDAT.C(counter:(counter-1+length(tmpry.T)),1)       = tmpry.C;
        bgrndDAT.Pr(counter:(counter-1+length(tmpry.T)),1)      = tmpry.Pr;
%         bgrndDAT.timeUTC(counter:(counter-1+length(tmpry.T)),1) = tmpry.timeUTC;
%         bgrndDAT.Station(counter:(counter-1+length(tmpry.T)),1) = tmpry.Station;
        bgrndDAT.Lat(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lat;
        bgrndDAT.Lon(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lon;
        counter=counter+length(tmpry.S)+1;
%     elseif isfield(CTD.(XX).Corrected,'SALT_01')==1 
%         ii=1:length(CTD.(XX).latitude);%find(CTD.(XX).longitude>2); %for Mallorca Channel only! 
%         tmpry.S       = reshape(CTD.(XX).Corrected.SALT_01(:,ii),[],1);
%         tmpry.T       = reshape(CTD.(XX).t090C(:,ii),[],1);
%         tmpry.PT      = reshape(CTD.(XX).Corrected.ptemp_01(:,ii),[],1);
%         tmpry.C       = reshape(CTD.(XX).Corrected.COND_01(:,ii),[],1);
%         tmpry.Pr      = reshape(CTD.(XX).Pressure(:,ii),[],1);
%         tmpry.timeUTC = reshape(repmat(CTD.(XX).timeUTC(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Station = reshape(repmat(CTD.(XX).Station(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Lat     = reshape(repmat(CTD.(XX).latitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         tmpry.Lon     = reshape(repmat(CTD.(XX).longitude(ii),size(CTD.(XX).Pressure(:,ii),1),1),[],1);
%         bgrndDAT.S(counter:(counter-1+length(tmpry.S)),1)       = tmpry.S;
%         bgrndDAT.T(counter:(counter-1+length(tmpry.T)),1)       = tmpry.T;
%         bgrndDAT.PT(counter:(counter-1+length(tmpry.T)),1)      = tmpry.PT;
%         bgrndDAT.C(counter:(counter-1+length(tmpry.T)),1)       = tmpry.C;
%         bgrndDAT.Pr(counter:(counter-1+length(tmpry.T)),1)      = tmpry.Pr;
%         bgrndDAT.timeUTC(counter:(counter-1+length(tmpry.T)),1) = tmpry.timeUTC;
%         bgrndDAT.Station(counter:(counter-1+length(tmpry.T)),1) = tmpry.Station;
%         bgrndDAT.Lat(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lat;
%         bgrndDAT.Lon(counter:(counter-1+length(tmpry.T)),1)     = tmpry.Lon;
        counter=counter+length(tmpry.S)+1;
    end
    clear XX ii tmpry
end
% if we remove data from the Mallorca Channel:
if strcmpi(buttonMC,'YES')==1
    % replace data with nans for ship data:
    r = find(bgrndDAT.Lon>1.5);
    flds = fieldnames(bgrndDAT);
    for n=1:length(flds)
        if iscell(bgrndDAT.(flds{n}))==0
            bgrndDAT.(flds{n})(r) = nan;
        end
    end
    clear r 
    %replace data with nans for glider data:
    r = find(TESTdat.Lon>1.5);
    flds = fieldnames(TESTdat);
    for n=1:length(flds)
        if iscell(TESTdat.(flds{n}))==0
            TESTdat.(flds{n})(r) = nan;
        end
    end
    clear r   
end
% remove nans:
r = isnan(bgrndDAT.S)==1 | isnan(bgrndDAT.T)==1 |...
    isnan(bgrndDAT.PT)==1 | isnan(bgrndDAT.C)==1 |...
    isnan(bgrndDAT.Pr)==1 | bgrndDAT.C==0;
FLDbgnd = fieldnames(bgrndDAT);
for n1 = 1:length(FLDbgnd)
    bgrndDAT.(FLDbgnd{n1})(r) = [];
end
clear r tmpry


% 3b) CREATE TS DIAG OF DATA TO JUDGE IF BACKGROUND DATA IS SENSIBLE, AND
% WHAT AXES LIMITS TO USE FOR WHITESPACE CORRECTION:
disp(Campaign.COMP)
%tmpry = strjoin(Campaign.COMP.');
tmpry = Campaign.COMP;
msgbox(['Select the following background data cruise for TS diagram: displayed in the Command Window (Campaign.COMP): ',tmpry])
clear tmpry
%pause
TSdiags_from_Struct(1, 0, TESTdat, depNUM_glider, CtdCorrDataFile)
%TSdiags_from_Struct(1, 0, TESTdat, depNUM_glider, CtdCorrDataFile)

% 3c) Choose axis limits of the TSdiagram for the whitespace maximisation method:
AXISlims.xMin = 38.48;
AXISlims.xMax = 38.6;
AXISlims.yMin = 12.8;
AXISlims.yMax = 13.8;%28:-2:14;
disp(AXISlims)
buttonAXIS = questdlg('Do you wish to alter the default axis limits for the whitespace correction?','Axis limits','YES','NO','NO');
if strcmpi(buttonAXIS,'YES')==1
    prompt = {'Adjust temperature min?','Adjust temperature max?','Adjust salinity min?','Adjust salinity max?'};
    dlg_title = 'Data range for iteration';
    num_lines = 1;
    defaultans = {num2str(AXISlims.yMin),num2str(AXISlims.yMax),num2str(AXISlims.xMin),num2str(AXISlims.xMax)};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    %LIMIT BY RANGES:
    AXISlims.yMin = str2double(answer{1});
    AXISlims.yMax = str2double(answer{2});
    AXISlims.xMin = str2double(answer{3});
    AXISlims.xMax = str2double(answer{4});
end

% 3d) now for the whitespace correction: find correction by calculating whitespace area in a figure, and finding the maximum 
%     whitespace area through shifting the test campaign data to the left/right, i.e. when the curves are most coincident 
%     The std of the results provides a basic error estimate.

init_guess  = [0.9999,1,1.0001]; % initial guess of correction coeff, so starts at 1 as in  condGliderAdj =  A * condGlider from which we make out steps to find the solution;

step_major  = 0.0001; % initial solution search step
step_minor  = 0.00001; % second solution search step and level of accuracy (could increase this with more steps)
max_iterations  = 100; % nominal number of steps if more than this we have a problem
step_miniscule = 0.000001;  % third solution search step and level of accuracy (could increase this with more steps)

% if exist([FigsPname_out,Campaign.Test,'_V1/WHITESPACE'],'dir') ~= 7
%     mkdir([FigsPname_out ,Campaign.Test,'_V1/WHITESPACE'])
% end
% imageDir = [FigsPname_out,Campaign.Test,'_V1/WHITESPACE/'];
if exist(MainPath.deploymentFigsTSdiagsCorrectedReference,'dir') ~= 7
    mkdir(MainPath.deploymentFigsTSdiagsCorrectedReference)
end
imageDir = MainPath.deploymentFigsTSdiagsCorrectedReference;

% calls function optim3steps for the whitespace maximisation correction
% method:
disp(['initial guess for A is: ', num2str(init_guess)])
disp(['A', ' Area', ' Difference'])
for n=1:length(init_guess)
    %disp(['INITIAL GUESS = ', sprintf('%1.6f',init_guess(n))])
    [TSrange.guess(n), TSrange.value(n), TSrange.iterations(n)] = optim3steps_john(@imageArea_V2, init_guess(n), step_major, step_minor, step_miniscule, max_iterations,...
        TESTdat.C, TESTdat.T, TESTdat.Pr, TESTdat.PT, bgrndDAT.S, bgrndDAT.PT, imageDir,AXISlims,n);
    disp(['FINAL GRADIENT = ',sprintf('%1.6f',(TSrange.guess(n)))]) %num2str((TSrange.guess(n)), '%1.6f')])
end
 
% 3e) Plots TS diagrams of the background data and the "corrected" test
% (glider) data as a result of the three different initial_guess values in
% step 3d. Asks the user to decide which provides the best correction
% coeficient:
scrsz = get(0,'ScreenSize');
figure('Position',[50 50 scrsz(3)-100 scrsz(4)-200]);
subplot(1,3,1)
plot(gsw_SP_from_C((TSrange.guess(1)*TESTdat.C),TESTdat.T,TESTdat.Pr),TESTdat.PT,'.r','markersize',3)
grid on; hold on; set(gca,'fontsize',14,'fontweight','b')
plot(bgrndDAT.S,bgrndDAT.PT,'.k','markersize',3)
axis([AXISlims.xMin,AXISlims.xMax,AXISlims.yMin,AXISlims.yMax])
title(['Guess 1 = ',(sprintf('%0.8f',TSrange.guess(1)))],'fontsize',14,'fontweight','b')
subplot(1,3,2)
plot(gsw_SP_from_C((TSrange.guess(2)*TESTdat.C),TESTdat.T,TESTdat.Pr),TESTdat.PT,'.r','markersize',3)
grid on; hold on; set(gca,'fontsize',14,'fontweight','b')
plot(bgrndDAT.S,bgrndDAT.PT,'.k','markersize',3)
% axis([AXISlims.xMin,AXISlims.xMax,12.9,13.6])
axis([AXISlims.xMin,AXISlims.xMax,AXISlims.yMin,AXISlims.yMax])
title(['Guess 2 = ',sprintf('%0.8f',TSrange.guess(2))],'fontsize',14,'fontweight','b')
subplot(1,3,3)
plot(gsw_SP_from_C((TSrange.guess(3)*TESTdat.C),TESTdat.T,TESTdat.Pr),TESTdat.PT,'.r','markersize',3)
grid on; hold on; set(gca,'fontsize',14,'fontweight','b')
plot(bgrndDAT.S,bgrndDAT.PT,'.k','markersize',3)
axis([AXISlims.xMin,AXISlims.xMax,AXISlims.yMin,AXISlims.yMax])
title(['Guess 3 = ',sprintf('%0.8f',TSrange.guess(3))],'fontsize',14,'fontweight','b')
% Choose best result:
%input_sensor=n;
buttonGUESS = questdlg('Which guess do we use?','Guess value to use','Guess 1','Guess 2', 'Guess 3','Guess 2');
if strcmpi(buttonGUESS,'Guess 1')==1
    GUESS = TSrange.guess(1);
elseif strcmpi(buttonGUESS,'Guess 2')==1
    GUESS = TSrange.guess(2);
elseif strcmpi(buttonGUESS,'Guess 3')==1
    GUESS = TSrange.guess(3);
end


end

