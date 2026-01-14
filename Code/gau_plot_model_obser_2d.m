function gau_plot_model_obser_2d(xco2_gau, oco2_req_data_range)

along_wind = -111.195*2:11.1195/100:111.195*2; % in km
across_wind = (-111.195*2:11.1195/100:111.195*2)*1000; % in meters

figure; ax1 = axes;
imagesc(ax1,along_wind,across_wind/1000,(xco2_gau));
set(gca,'YDir','normal');
grid minor
set(gca,'YDir','normal','fontweight','bold','FontSize', 12,'FontName', 'Times New Roman')

ax2 = axes;
scatter (ax2, oco2_req_data_range.lon_tran,oco2_req_data_range.lat_tran, 80, oco2_req_data_range.obser_enh,'filled')
linkaxes([ax1,ax2])
ax2.Visible = 'off';
ax2.XTick = []; ax2.YTick = [];
colormap(ax1,'hot') 
colormap(ax2,'parula')

set([ax1,ax2],'Position',[0.1 .1 .685 .815]);
% cb1 = colorbar(ax1,'Position',[0.8 .1 .06 .815]);
% cb1.Label.String = 'XCO_2 enhancement (ppm)';
% cb1.Label.FontSize=16; 
% cb1.FontSize=16; 
cb2 = colorbar(ax2,'Position',[.80 .1 .06 .815]);
cb2.Label.String = ' Observed XCO_2 enhancement (ppm)';
cb2.Label.FontSize=16; 
cb2.FontSize=14;
caxis(ax1,[0 4])
caxis(ax2,[0 4]);
set(gca,'fontweight','bold','FontSize', 15,'FontName', 'Times New Roman')

xlim([-40 80])
ylim([-20 40])

ax = gca;
ax.XLabel.Visible = 'on';
xlh = xlabel(ax,'distance (km)','fontweight','bold','FontSize', 16,'FontName', 'Times New Roman');
xlh.Position(2) = xlh.Position(2) - 1.5;  
ax.YLabel.Visible = 'on';
ylh = ylabel(ax,'distance (km)','fontweight','bold','FontSize', 16,'FontName', 'Times New Roman');
ylh.Position(1) = ylh.Position(1) - 7;

end