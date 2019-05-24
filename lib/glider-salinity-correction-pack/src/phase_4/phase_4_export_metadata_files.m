function [TESTdat, fnameOutPath] = phase_4_export_metadata_files(TESTdat, CtdCorrDataFile, GliderDataFile, Campaign, AXISlims)

global MainPath
global EXT_GLIDER

[CTD_CORR.data, CTD_CORR.meta, CTD_CORR.global_meta] = loadnc(char(CtdCorrDataFile.path{1}));

% 4.c) error estimate of corrected salinity:
ERROR = inputdlg('Provide error estimate:','error estimate',1,{'0.01'});
TESTdat.Corr.Error = str2double(ERROR);

    
% 4.d) Providing information for metadata:
TESTdat.metaCorr.A = sprintf('%.6f',TESTdat.Corr.A);
TESTdat.metaCorr.ErrorEst = str2double(ERROR{1});
TESTdat.metaCorr.CorrectionSummaryMethod  = 'whitespace area maximisation of a Theta-S diagram comparison, between glider data and other nearby (in time and space) cruises was employed';
TESTdat.metaCorr.Calibration_equation = 'COND_CORR=A*COND_01';
TESTdat.metaCorr.CorrectionSummaryREPORT  = 'For further details, refer to report...TBC';
TESTdat.metaCorr.CorrectionSummaryGLIDERREPORT  = 'http://www.socib.es/?seccion=gliderPage&facility=gliderReports';
TESTdat.metaCorr.Comment = 'Salinity calibration reference: Allen, J.T.; Fuda,J-L.;Perivoliotis, L.; Munoz-Mas, C.; Alou, E. and Reeve, K. (2018) Guidelines for the delayed mode scientific correction of glider data. WP 5, Task 5.7, D5.15. Version 4.1. Palma de Mallorca, Spain, SOCIB - Balearic Islands Coastal Observing and Forecasting System for JERICO-NEXT, 20pp. (JERICO-NEXT-WP5-D5.15-140818-V4.1). DOI: 10.25607/OBP-430'

RANGE = size(Campaign.DEP, 1);
for n = 1 : RANGE
    x{n} = [num2str(n),') ', CtdCorrDataFile.name{n}(1:end-3)];
end
TESTdat.metaCorr.CorrectionSummaryBGRNDdata  = strjoin(['Background comparison Cruises used:', x]); clear x
TESTdat.metaCorr.CorrectionSummaryERRORestimate  = 'error estimate is based on the range of salinity values of the comparison cruises at about 13 deg C (i.e. at the tail end of the deepest values on the Theta-S diagram)';
TESTdat.metaCorr.CorrectionSummaryWHTSPACE = ['Salinity: ',num2str(AXISlims.xMin),' to ', num2str(AXISlims.xMax), ' psu, Temperature: ',num2str(AXISlims.yMin),' to ', num2str(AXISlims.yMax), ' deg C'];

save([MainPath.dataCorrectedMat, Campaign.testDeploymentCode, '_', Campaign.testPlatformName, '_', Campaign.testInstrumentName, '_', Campaign.testDeploymentDate '.nc'],'TESTdat')

% 4.f) Create netcdf file of the meta data for corrected conductivity and
% salinity (to go to the data centre):
switch EXT_GLIDER
    case 1
        TESTdat.Corr.C = reshape(TESTdat.Corr.C,[],1);
        TESTdat.Corr.S = reshape(TESTdat.Corr.S,[],1);
        TESTdat.T = reshape(TESTdat.T,[],1);
        TESTdat.S = reshape(TESTdat.S,[],1);
        TESTdat.PT = reshape(TESTdat.PT,[],1);
        TESTdat.Pr = reshape(TESTdat.Pr,[],1);
end
fileNameOut = [MainPath.dataCorrectionCoefficientsNc, Campaign.testDeploymentCode, '_', Campaign.testPlatformName, '_', Campaign.testInstrumentName, '_', Campaign.testDeploymentDate '.nc'];

nccreate(fileNameOut,'conductivity_corr','Dimensions',{'time',inf})
ncwrite(fileNameOut,'conductivity_corr',TESTdat.Corr.C);
ncwriteatt(fileNameOut,'conductivity_corr','observation_type','corrected_measurements')

if isfield(TESTdat,'T') == 0  % check whether exists thermal lag corrected temperature
    ncwriteatt(fileNameOut,'conductivity_corr','conductivity_thermal_corr_used','YES')
else
    ncwriteatt(fileNameOut,'conductivity_corr','conductivity_thermal_corr_used','NO, unavailable')
end

ncwriteatt(fileNameOut,'conductivity_corr','correction_coefficient_A',TESTdat.metaCorr.A)
ncwriteatt(fileNameOut,'conductivity_corr','calibration_equation',TESTdat.metaCorr.Calibration_equation)
%ncwriteatt([Pname_outMeta,Campaign.Test,'_corr'],'conductivity_corr','salinity_error_estimate',TESTdat.metaCorr.ErrorEst)
ncwriteatt(fileNameOut,'conductivity_corr','summary_method', TESTdat.metaCorr.CorrectionSummaryMethod)
ncwriteatt(fileNameOut,'conductivity_corr','summary_method_error_estimate', TESTdat.metaCorr.CorrectionSummaryERRORestimate)
ncwriteatt(fileNameOut,'conductivity_corr','summary_method_report', TESTdat.metaCorr.CorrectionSummaryREPORT)
if isfield(TESTdat.metaCorr,'CorrectionSummaryGLIDERREPORT') ==1
    ncwriteatt(fileNameOut,'conductivity_corr','glider_report', TESTdat.metaCorr.CorrectionSummaryGLIDERREPORT)
end
ncwriteatt(fileNameOut,'conductivity_corr','background_data_used_for_correction', TESTdat.metaCorr.CorrectionSummaryBGRNDdata)
ncwriteatt(fileNameOut,'conductivity_corr','theta-sal_whitespace_for_correction', TESTdat.metaCorr.CorrectionSummaryWHTSPACE)
ncwriteatt(fileNameOut,'conductivity_corr','comment', TESTdat.metaCorr.Comment)

nccreate(fileNameOut,'salinity_corr','Dimensions',{'time',inf});
ncwrite(fileNameOut,'salinity_corr',TESTdat.Corr.S);
ncwriteatt(fileNameOut,'salinity_corr','observation_type','corrected_derived_from_conductivity_corr')
ncwriteatt(fileNameOut,'salinity_corr','summary_details','Refer to meta.conductivity_corr.attributes')
ncwriteatt(fileNameOut,'salinity_corr','salinity_error_estimate',TESTdat.metaCorr.ErrorEst)
ncwriteatt(fileNameOut,'salinity_corr','background_data_used_for_correction', TESTdat.metaCorr.CorrectionSummaryBGRNDdata)
dum = {'residual_salinity_differences_std', 'Residual_Salinity_differences_std'};
for i = 1: length(CTD_CORR.meta.SALT_01_CORR.attributes)
   %if strcmp(CTD_CORR.meta.SALT_01_CORR.attributes(i).name, dum) == 1;
   if ismember(CTD_CORR.meta.SALT_01_CORR.attributes(i).name, dum) == 1;            
       ncwriteatt(fileNameOut,'salinity_corr','residual_salinity_differences_std_background_data', [sprintf('%.6f', CTD_CORR.meta.SALT_01_CORR.attributes(i).value), ' given temperature and given pressure'])
   end
end
ncwriteatt(fileNameOut,'salinity_corr','comment', TESTdat.metaCorr.Comment);

nccreate(fileNameOut,'time','Dimensions',{'time',inf});
ncwrite(fileNameOut,'time',TESTdat.timeNUM);

nccreate(fileNameOut,'temperature_corr','Dimensions',{'time',inf});
ncwrite(fileNameOut,'temperature_corr',TESTdat.T);
ncwriteatt(fileNameOut,'temperature_corr','observation_type','corrected_measurements')
ncwriteatt(fileNameOut,'temperature_corr','summary_details','At this stage, temperature_corr is the same as original temperature. This section will be updated if de-spiking is required')

nccreate(fileNameOut,'temperature','Dimensions',{'time',inf});
ncwrite(fileNameOut,'temperature',TESTdat.T);

nccreate(fileNameOut,'salinity','Dimensions',{'time',inf});
ncwrite(fileNameOut,'salinity',TESTdat.S);

nccreate(fileNameOut,'potential_temperature','Dimensions',{'time',inf});
ncwrite(fileNameOut,'potential_temperature',TESTdat.PT);

nccreate(fileNameOut,'pressure','Dimensions',{'time',inf});
ncwrite(fileNameOut,'pressure',TESTdat.Pr);

switch EXT_GLIDER
    case 0
        ncwriteatt(fileNameOut,'/','name',char(GliderDataFile.path{1}));
end
fnameOutPath = [MainPath.dataCorrectionCoefficientsNc];
ncdisp(fileNameOut,'/');

disp(Campaign.COMP)
disp(AXISlims)
format long
disp(TESTdat.Corr.A)
disp(ERROR)

end