% This script estimates point-source CO₂ emissions using OCO-2 satellite observations using Gaussian Plume model
clear; clc; close all
%% Required Fields

oco2_myFolder = 'D:\India_OCO_data\OCO_2_data';  

date_ano = 210113; 

rep_emi_cb = 10; 

lat_sou = 24.0151;  
lon_sou = 82.7978;

lat_ano = 23.90;
lon_ano = 83.15;

ws_ano = 2.49;
wd_ano = 320.49;

bad_data = 'YES'; 

rot_val = 25; 

%% Data Manipulation

date_ano_str = num2str(date_ano); 
year_file = ['20',date_ano_str(1:2)];

oco2_req_data = oco2_data_mani(oco2_myFolder, date_ano, lat_sou(1), lon_sou(1), bad_data);

max_lat_arou_ano_idx = find( (oco2_req_data.lat >= lat_ano - 0.1) & (oco2_req_data.lat <= lat_ano + 0.1) );

[max_arou_ano, max_arou_ano_idx] = max (oco2_req_data.co2(max_lat_arou_ano_idx));

dis_max = oco2_req_data.dis(max_lat_arou_ano_idx(max_arou_ano_idx)); 
lat_at_max_peak = oco2_req_data.lat(max_lat_arou_ano_idx(max_arou_ano_idx)); 
lon_at_max_peak = oco2_req_data.lon(max_lat_arou_ano_idx(max_arou_ano_idx));

dis_range_ind = find (oco2_req_data.dis <= dis_max+100 & oco2_req_data.dis >= dis_max-100);
oco2_req_data_range = table(oco2_req_data.lat(dis_range_ind),oco2_req_data.lon(dis_range_ind),oco2_req_data.co2(dis_range_ind),oco2_req_data.uncer(dis_range_ind),oco2_req_data.id(dis_range_ind),oco2_req_data.wv(dis_range_ind),oco2_req_data.sp(dis_range_ind),(oco2_req_data.dis(dis_range_ind)- dis_max));
oco2_req_data_range.Properties.VariableNames = {'lat', 'lon', 'co2', 'uncer', 'id','wv', 'sp','dis'};
%% Curve Fit for Background XCO2 Calculation

x_fit = oco2_req_data_range.dis;
y_fit = oco2_req_data_range.co2;
y_wei = oco2_req_data_range.uncer;

disp(['Estimate the slope (b) and intercept (m) using "Curve Fitter" tool. ' newline ...
    'Choose X data = x_fit; Y data = y_fit; Weights = y_wei; ' newline ...
    'Custom Equation = ((m*x)+b)+((a/(s*(2*3.14).^(1/2)))*exp((-(x-mu).^2)/(2*s.^2)))'])
%% Estimating Unknown Parameters and XCO2 Enhancement

b_fit = input('Intercept (b) estimated from curve fit: ');
m_fit = input('Slope (m) estimated from curve fit: ');

lin_fun = (m_fit*x_fit)+b_fit;

oco2_req_data_range.obser_enh = oco2_req_data_range.co2 - lin_fun; 
%% Modelling The XCO2 Expected Enhancement Using Gaussian Plume Model

sp_mean = nanmean(oco2_req_data_range.sp,'all'); 
wv_mean = nanmean(oco2_req_data_range.wv,'all');

wd_ano_req = wd_ano +rot_val; 

if wd_ano_req > 360
    wd_ano_req = wd_ano_req-360;
elseif wd_ano_req < 0
    wd_ano_req = wd_ano_req+360;
end

rep_emi = rep_emi_cb.*10^12/(365*24*60*60);

co2_vc_summed =  gau_model(rep_emi, lat_sou, lon_sou, ws_ano, wd_ano_req); 
%% Plots

oco2_req_data_range_final = gau_resample(co2_vc_summed,oco2_req_data_range, lat_sou, lon_sou, wd_ano_req); 
weight_co2 = oco2_req_data_range_final.uncer/nansum(oco2_req_data_range_final.uncer);

xco2_gau_plot = co2_vc_summed * (28.97/44.01) * (9.81/(sp_mean - wv_mean * 9.81))*1000; 
gau_plot_obs_val(oco2_req_data_range_final)
gau_plot_model_obser_2d(xco2_gau_plot, oco2_req_data_range_final)
gau_plot_model_obser_scatter(oco2_req_data_range_final)
%% Scaling Factor Estimation

plume_idx = find(oco2_req_data_range_final.mod_enh >= 1/100*(max(oco2_req_data_range_final.mod_enh)));

plume_obser = oco2_req_data_range_final.obser_enh(plume_idx);
plume_model = oco2_req_data_range_final.mod_enh(plume_idx);
plume_unc = oco2_req_data_range_final.uncer(plume_idx);
plume_model(plume_obser <= 0) = [];
plume_unc(plume_obser <= 0) = [];
plume_obser(plume_obser <= 0) = [];
plume_unc(plume_obser <= 0) = [];


disp(['Estimate the scaling factor using "Curve Fitter" tool. ' newline ...
    'Choose X data = plume_model; Y data = plume_obser; Weights = plume_unc; ' newline ...
    'Custom Equation = sf*x'])
%% XCO2 Emission Calculation

sf_fit = input('Scaling Factor (sf) estimated from curve fit: ');

disp(['Estimated XCO2 Emission (Mt/Year): ', num2str(sf_fit.*rep_emi_cb)])

plume_R = min(corrcoef(plume_obser, plume_model,'rows','pairwise'),[],"all");

if plume_R >= 0.5
    disp('Emission estimate is highly reliable.');
elseif plume_R >= 0.25
    disp('Emission estimate has moderate reliability.');
else
    disp('Emission estimate has low reliability.');
end