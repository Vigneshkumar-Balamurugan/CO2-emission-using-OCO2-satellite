function gau_plot_obs_val(oco2_req_data_range)

figure
scatter (oco2_req_data_range.dis , oco2_req_data_range.co2,'o','filled','MarkerEdgeColor', 'k') 
grid minor
xlabel('distance (km)')
ylabel('XCO_2 (ppm)')
legend('XCO_2 retrievals from OCO-2')
set(gca,'FontSize', 15,'fontweight','bold','FontName', 'Times New Roman')
end