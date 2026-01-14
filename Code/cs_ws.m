function ws_nor_tra = cs_ws (oco2_req_data_range,era5_ws_ano,era5_wd_ano_req)

fp_1_idx = find(endsWith(cellstr(num2str(oco2_req_data_range.id)), '1'), 2, 'first');

ver_dis_tra = oco2_req_data_range.lat(fp_1_idx(2)) - oco2_req_data_range.lat(fp_1_idx(1));
hor_dis_tra = oco2_req_data_range.lon(fp_1_idx(1)) - oco2_req_data_range.lon(fp_1_idx(2));
tra_ang = atand(hor_dis_tra/ver_dis_tra);

if era5_wd_ano_req >= 0 && era5_wd_ano_req <= 90
    if era5_wd_ano_req <= tra_ang
        ws_nor_tra = era5_ws_ano* cosd(tra_ang-era5_wd_ano_req);
    else
        ws_nor_tra = era5_ws_ano* cosd(era5_wd_ano_req-tra_ang);
    end
end

if era5_wd_ano_req >= 90 && era5_wd_ano_req <= 180
    if era5_wd_ano_req-90 <= tra_ang
        ws_nor_tra = era5_ws_ano* cosd(era5_wd_ano_req  - tra_ang);
    else
        ws_nor_tra = era5_ws_ano* cosd(tra_ang+180 - era5_wd_ano_req);
    end
end

if era5_wd_ano_req >= 180 && era5_wd_ano_req <= 270
    if era5_wd_ano_req <= tra_ang+180
        ws_nor_tra = era5_ws_ano* cosd(tra_ang+180 - era5_wd_ano_req);
    else
        ws_nor_tra = era5_ws_ano* cosd( era5_wd_ano_req - (tra_ang+180));
    end
end

if era5_wd_ano_req >= 270 && era5_wd_ano_req <= 360
    if era5_wd_ano_req <= tra_ang+270
        ws_nor_tra = era5_ws_ano* cosd(era5_wd_ano_req - (tra_ang+180));
    else
        ws_nor_tra = era5_ws_ano* cosd(360 - era5_wd_ano_req + tra_ang);
    end
end

end