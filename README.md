# Satellite-Based CO₂ Emission Estimation Using OCO-2

This repository provides a MATLAB implementation for estimating point-source CO₂ emissions using OCO-2 satellite XCO₂ observations combined with Gaussian plume modeling and cross-sectional emission flux method.  
The methodology follows the framework described in:

**Reference**  
Balamurugan et al. (2024), *Fossil Fuel CO2 Emission Signatures Over India Captured by OCO-2 Satellite Measurements*, **Earth’s Future**.  
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

### Required Inputs

| Parameter | Description | Example |
|---------|------------|---------|
| `oco2_data_folder` | Path to folder containing OCO-2 data | `D:\India_OCO_data\OCO_2_data` |
| `date_ano` | Investigation date (YYMMDD) | `210113` |
| `rep_emi_cb` | Known CO₂ emission(s) (Mt/year) | `[5.16, 4.18]` |
| `lat_sou` | Latitude of emission source(s) | `[24.202043, 24.1042119]` |
| `lon_sou` | Longitude of emission source(s) | `[82.789128, 82.7063552]` |
| `lat_ano` | Latitude of XCO₂ anomaly | `23.9013992799531` |
| `lon_ano` | Longitude of XCO₂ anomaly | `83.1563360231732` |
| `ws_ano` | Wind speed (m/s) | `2.49` |
| `wd_ano` | Wind direction (degrees) | `320.49` |
| `bad_data` | Include bad data (`YES` / `NO`) | `YES` |
| `rot_val` | Extra plume rotation angle (degrees) | `25` |
