
% set_main_paths;
% [deploymentName, ncL1FileName, DIR, instrumentName] = stage_0_select_datasets;
% set_ancillary_paths(deploymentName, instrumentName);
% create_out_directories;

choice = {'PHASE 1. Load Cruise Data', ...
          'PHASE 2. Preliminary Results', ...
          'PHASE 3. Default Salinity Correction', ...
          'PHASE 3a. Manual Salinity Correction', ...
          'PHASE 4. Apply Correction Results', ...
          'PHASE 5. Write L1_corr Data Files'};
      
choiceFunction = {'[CtdBtl, InsituSal, DIR, ncL1FileName, DeploymentInfo] = phase_1_select_cruise_data', ...
    'phase_2_preliminary_results(DIR)', ...
    '[unique_sensor, rmX] = phase_3_salinity_corrections(DIR, DeploymentInfo, choice(3))', ...
    '[unique_sensor, rmX] = phase_3_salinity_corrections(DIR, DeploymentInfo, choice(4))', ...
    'fnameOutPath = phase_4_apply_salinity_correction_results(DeploymentInfo, DIR, ncL1FileName, unique_sensor)', ...%'Stage_7a_mbtl_insitu_SAL_matchup()', ... %original argument: manual_outlier_removal set to 0 or 1
    'write_L1_corr_data_files(fnameOutPath)'};
         
d = dialog('Position',[80 250 550 410],'Name','CTD Salinity Correction Pack');       
firstButtonY = 365;
firstButtonWidth = 350;
firstButtonX = 10;
firstBttonHeight = 40;
% txt = uicontrol('Parent',d,...
%        'Style','text',...
%        'Position',[20 80 210 40],...
%        'String','Select a color');
[x,~]=imread('LogoSocib.png');
I2=imresize(x, [102 113]);
socibLogo=uicontrol('Parent',d,...
            'units','pixels',...
            'position',[10 30 113 102],...
            'cdata',I2);
        
[x,~]=imread('ctdSocib.jpg');
I2=imresize(x, [202 140]);
ctdLogo=uicontrol('Parent',d,...
            'units','pixels',...
            'position',[380 162 140 202],...
            'cdata',I2);
        
[x,~]=imread('jericoLogo.jpg');
I2=imresize(x, [102 183]);
jericoLogo=uicontrol('Parent',d,...
            'units','pixels',...
            'position',[150 30 183 102],...
            'cdata',I2);


[~,n] = size(choice);
count = 0;
for i = 1:n
    stage(i) = uicontrol('Parent',d,...
       'Position',[firstButtonX firstButtonY - count firstButtonWidth firstBttonHeight],...
       'String',choice(i),...
       'fontSize',12, ...
       'Callback',choiceFunction{i}, ...
       'Interruptible', 'on');
    count = count + 45;
end



   
   
   
   
   
   