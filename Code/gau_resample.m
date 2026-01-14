function final_table = gau_resample(co2_vc_summed,oco2_req_data_range, lat_sou, lon_sou, era5_wd_ano_req)

oco2_lon_tran = zeros(1,length(oco2_req_data_range.lon));
oco2_lat_tran = zeros(1,length(oco2_req_data_range.lat));

for tran_xx = 1:length(oco2_req_data_range.lat)
    oco2_lon_tran(tran_xx)= (oco2_req_data_range.lon(tran_xx)*cosd(era5_wd_ano_req))+(oco2_req_data_range.lat(tran_xx)*sind(era5_wd_ano_req));
    oco2_lat_tran(tran_xx)= (-oco2_req_data_range.lon(tran_xx)*sind(era5_wd_ano_req))+(oco2_req_data_range.lat(tran_xx)*cosd(era5_wd_ano_req));
end

lon_sou_main = (lon_sou(1) * cosd(era5_wd_ano_req))+(lat_sou(1) * sind(era5_wd_ano_req));
lat_sou_main = (-lon_sou(1) * sind(era5_wd_ano_req))+(lat_sou(1) * cosd(era5_wd_ano_req));

oco2_req_data_range.lon_tran = (deg2km(oco2_lon_tran-lon_sou_main,'earth'))';
oco2_req_data_range.lat_tran = (deg2km(oco2_lat_tran-lat_sou_main,'earth'))';

final_table = oco2_req_data_range;

along_wind = -111.195*2:11.1195/100:111.195*2; % in km
across_wind = (-111.195*2:11.1195/100:111.195*2)*1000; % in meters

x = along_wind; y = across_wind/1000;

exp_enh = nan(length(oco2_req_data_range.lon_tran),1); 
for gau_resample_xx = 1:length(oco2_req_data_range.lon_tran)
     [~, lat_tran_near] = min(abs(y-oco2_req_data_range.lat_tran(gau_resample_xx)));
     [~, lon_tran_near] = min(abs(x-oco2_req_data_range.lon_tran(gau_resample_xx)));
     exp_enh(gau_resample_xx) = co2_vc_summed(lat_tran_near,lon_tran_near) * (28.97/44.01) * (9.81/(oco2_req_data_range.sp(gau_resample_xx) - oco2_req_data_range.wv(gau_resample_xx) * 9.81))*1000;
end

final_table.mod_enh = exp_enh;

end