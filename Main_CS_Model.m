% This script estimates CO₂ emissions using OCO-2 satellite observations using cross-sectional flux method
clear; clc; close all
%% Required Fields

oco2_myFolder = 'D:\India_OCO_data\OCO_2_data'; 

date_ano = 210113;

lat_ano = 23.90;
lon_ano = 83.15;

bad_data = 'YES'; 

ws_ano = 2.49;
wd_ano = 320.49;

rot_val = 25; 
%% Data Manipulation

date_ano_str = num2str(date_ano); 
year_file = ['20',date_ano_str(1:2)];

oco2_req_data = oco2_data_mani(oco2_myFolder, date_ano, lat_ano(1), lon_ano(1), bad_data);

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

disp(['Estimate a, b, m, mu, and s using "Curve Fitter" tool. ' newline ...
    'Choose X data = x_fit; Y data = y_fit; Weights = y_wei; ' newline ...
    'Custom Equation = ((m*x)+b)+((a/(s*(2*3.14).^(1/2)))*exp((-(x-mu).^2)/(2*s.^2)))'])
%% Estimating Unknown Parameters and XCO2 Enhancement

a_fit = input('Scaling Constant (a) estimated from curve fit: ');
b_fit = input('Intercept (b) estimated from curve fit: ');
m_fit = input('Slope (m) estimated from curve fit: ');
mu_fit = input('Shift  (mu) estimated from curve fit: ');
s_fit = input('Standard Deviation (s) estimated from curve fit: ');

oco2_req_data_range.lin_fun = (m_fit*x_fit)+b_fit;

oco2_req_data_range.obser_enh = oco2_req_data_range.co2 - oco2_req_data_range.lin_fun; 
oco2_req_data_range.gau_fun = ((m_fit*x_fit)+b_fit)+((a_fit/(s_fit*(2*3.14).^(1/2)))*exp((-(x_fit-mu_fit).^2)/(2*s_fit.^2)));
oco2_req_data_range.gau_fun_rem_bkg = oco2_req_data_range.gau_fun - oco2_req_data_range.lin_fun;
%% XCO2 Emission Calculation
area_ld = trapz(x_fit,oco2_req_data_range.gau_fun_rem_bkg);

sp_mean = nanmean(oco2_req_data_range.sp,'all'); 
wv_mean = nanmean(oco2_req_data_range.wv,'all');

wd_ano_req = wd_ano +rot_val; 

if wd_ano_req > 360
    wd_ano_req = wd_ano_req-360;
elseif wd_ano_req < 0
    wd_ano_req = wd_ano_req+360;
end

ws_nor_tra = cs_ws (oco2_req_data_range,ws_ano,wd_ano_req);
co2_ld = ((area_ld * 44.01 * sp_mean - wv_mean * 9.81)/(28.9 * 9.81))* 10^(-6);
flux_co2 = co2_ld * (ws_nor_tra)*10^(-6)*365*24*60*60; 
disp(['Estimated XCO2 Emission (Mt/Year): ', num2str(flux_co2)])
