# Satellite-Based CO₂ Emission Estimation Using OCO-2

This repository provides a MATLAB implementation for estimating point-source CO₂ emissions using OCO-2 satellite XCO₂ observations combined with Gaussian plume modeling and cross-sectional emission flux method.  
The methodology follows the framework described in:

**Reference**  
Author et al. (2023), *Satellite-based detection and quantification of CO₂ emissions using OCO-2 observations*, **Earth’s Future**.  
https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2023EF004411

The methodology is suitable for:
- Power plants and industrial point sources

---

## Methodology 

The code estimates CO₂ emissions from a point source by:

## Gaussian Plume Model

1. Extracting OCO-2 XCO₂ data around a target region
2. Estimating background XCO₂ using weighted curve fitting
3. Calculating observed XCO₂ enhancements
4. Simulating expected enhancements using a Gaussian plume model
5. Estimating an emission scaling factor via least-square fitting method

## Cross-sectional Emission Flux 
1. Extracting OCO-2 XCO₂ data around a target region
2. Estimating background XCO₂ using weighted curve fitting
3. Calculating observed XCO₂ enhancements
4. Estimating an emission using cross-sectional emission flux

 ## Required fields

oco2_myFolder = 'D:\India_OCO_data\OCO_2_data';  % Folder containing OCO-2 data

date_ano = 210113; % Investigation date (141023 --> 2014, 10, 23)

rep_emi_cb = 10;  % Known CO2 emission number in Mt/year (e.g, from inventory)

rep_emi_cb = [5.16, 4.18];  % Known CO2 emission if there are more than one source

lat_sou = 24.0151;  % Geo-location of emission source (latitude)

lon_sou = 82.7978; % Geo-location of emission source (longitude)

lat_sou = [24.202043, 24.1042119, 24.027];    % Geo-location of emission source if there are more than one source (latitude)
lon_sou = [82.789128, 82.7063552, 82.7915 ];  % Geo-location of emission source if there are more than one source (longitude)

lat_ano = 23.9013992799531; % Geo-location of XCO2 anomaly (latitude)
lon_ano = 83.1563360231732; % Geo-location of XCO2 anomaly (longitude)

ws_ano = 2.49; % Wind speed
wd_ano = 320.49; % Wind direction

bad_data = 'YES'; % Do you want to include bad data (YES/NO)

rot_val = 25; % angle to rotate plume in addition to wind info (negative value makes plume rotate clockwise and vice versa for positive value)
