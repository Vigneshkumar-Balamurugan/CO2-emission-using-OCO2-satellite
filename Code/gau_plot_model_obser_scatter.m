function gau_plot_model_obser_scatter(oco2_req_data_range)

figure
scatter (oco2_req_data_range.dis , oco2_req_data_range.obser_enh,'filled') 
hold on
scatter (oco2_req_data_range.dis , oco2_req_data_range.mod_enh,'filled')
grid minor
ylim([min(oco2_req_data_range.obser_enh), max([oco2_req_data_range.obser_enh;oco2_req_data_range.mod_enh])+1])
xlabel('distance (km)')
ylabel('XCO_2 enhancement (ppm)')
legend('Observed enhancement','Modelled enhancement')
set(gca,'FontSize', 15,'fontweight','bold','FontName', 'Times New Roman')
end