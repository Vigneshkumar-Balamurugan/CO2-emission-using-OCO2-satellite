function co2_vc_summed =  gau_model(rep_emi, lat_sou, lon_sou, era5_ws_ano, era5_wd_ano)

ws_sp = [2,5];
sp = [213, 104];

if era5_ws_ano <= 2
    sta_parm = 213;
elseif era5_ws_ano >= 5
    sta_parm = 104;
else
    sta_parm = interp1(ws_sp, sp, era5_ws_ano);
end
     
along_wind = -111.195*2:11.1195/100:111.195*2; % in km
across_wind = (-111.195*2:11.1195/100:111.195*2)*1000; % in meters

co2_vc = nan(length(across_wind),length(along_wind),length(rep_emi));

for rep_emi_xx = 1:length(rep_emi)
    for along_wind_xx = round(length(along_wind)/2):length(along_wind)
        for across_wind_xx = 1:length(across_wind)
            co2_vc(across_wind_xx,along_wind_xx,rep_emi_xx) = (rep_emi(rep_emi_xx) / ((2*3.14)^(1/2) * sta_parm * along_wind(along_wind_xx)^(0.894) * era5_ws_ano)) * exp ((-1/2)*(across_wind(across_wind_xx) / (sta_parm * along_wind(along_wind_xx)^(0.894)))^2);
        end
    end
end

lon_sou_main = (lon_sou(1) * cosd(era5_wd_ano))+(lat_sou(1) * sind(era5_wd_ano));
lat_sou_main = (-lon_sou(1) * sind(era5_wd_ano))+(lat_sou(1) * cosd(era5_wd_ano));

co2_vc_summed = co2_vc(:,:,1);

if length(rep_emi) > 1
    
    for rep_emi_xxx = 2:length(rep_emi)
        lon_sou_loop = (lon_sou(rep_emi_xxx) * cosd(era5_wd_ano))+(lat_sou(rep_emi_xxx) * sind(era5_wd_ano));
        lat_sou_loop = (-lon_sou(rep_emi_xxx) * sind(era5_wd_ano))+(lat_sou(rep_emi_xxx) * cosd(era5_wd_ano));
        
        sou_loop_dist_y = deg2km ((lat_sou_loop - lat_sou_main),'earth');
        sou_loop_dist_x = deg2km ((lon_sou_loop - lon_sou_main),'earth');
        
        x_add = round(sou_loop_dist_x/(11.1195/100));
        y_add = round(sou_loop_dist_y/(11.1195/100));
        
        if x_add <= 0
            co2_vc_summed = horzcat(zeros(length(across_wind),abs(x_add)),co2_vc_summed);
            co2_vc_loop = horzcat(co2_vc(:,:,rep_emi_xxx),zeros(length(across_wind),abs(x_add)));
        elseif x_add > 0
            co2_vc_summed = horzcat(co2_vc_summed,zeros(length(across_wind),abs(x_add))); 
            co2_vc_loop = horzcat(zeros(length(across_wind),abs(x_add)),co2_vc(:,:,rep_emi_xxx));
        end
        
        if y_add < 0 
            co2_vc_summed = vertcat(zeros(abs(y_add),length(co2_vc_summed)),co2_vc_summed);
            co2_vc_loop = vertcat(co2_vc_loop,zeros(abs(y_add),length(co2_vc_loop)));
        elseif y_add > 0
            co2_vc_summed = vertcat(co2_vc_summed,zeros(abs(y_add),length(co2_vc_summed)));
            co2_vc_loop = vertcat(zeros(abs(y_add),length(co2_vc_loop)),co2_vc_loop);
        end
        
        co2_vc_summed = nansum(cat(3, co2_vc_summed, co2_vc_loop),3);
        [R, C] = size(co2_vc_summed);
        
        if x_add < 0
            co2_vc_summed (:,1:abs(x_add)) = [];
        elseif x_add > 0
            co2_vc_summed (:,C-abs(x_add)+1:C) = [];
        end
        
        if y_add < 0
            co2_vc_summed (1:abs(y_add),:) = [];
        elseif y_add > 0
            co2_vc_summed (R-abs(y_add)+1:R,:) = [];
        end
    end
end

end