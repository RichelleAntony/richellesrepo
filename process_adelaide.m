%%% process_adelaide.m
% This script will load data for the climate station ADELAIDE_AIRPORT, and carry out the same analysis as you completed in a spreadsheet for the first part of your Climate Data Assignment. Y
%
%
%
% Created by: Richelle Antonythasan 
%
% Date created: December 8, 2025
% 
%

%%%%% Your tasks with this function:
%%% 1. Complete the code where tasks have been left for you (indicated by <**TO DO**>)
%%% 2. Ensure that the script runs without issue and produces the figures in the \Figs directory
%%% 3. Comment the top and other edited lines appropriately.
%%%%%

%% Preparation
clearvars;
%%% Set a variable equal to the station name -- this way, we can reuse it to
% load and save things. 
% Load data
stn_data = readmatrix('Data/ADELAIDE_AIRPORT.csv');

% Extract years and temperatures
years = stn_data(:,1);
temps = stn_data(:,2);

% Clean temperatures
temps(temps == -9999) = NaN;
temps = temps ./ 100;   % convert to °C

station_name = 'ADELAIDE_AIRPORT'; 
stn_data = readmatrix(['Data/' station_name '.csv']);

%%% Colormap (used for barcode plots)
cmap = ([0,0,0.562500000000000;0,0,0.625000000000000;0,0,0.687500000000000;0,0,0.750000000000000;0,0,0.812500000000000;0,0,0.875000000000000;0,0,0.937500000000000;0,0,1;0,0.0625000000000000,1;0,0.125000000000000,1;0,0.187500000000000,1;0,0.250000000000000,1;0,0.312500000000000,1;0,0.375000000000000,1;0,0.437500000000000,1;0,0.500000000000000,1;0,0.562500000000000,1;0,0.625000000000000,1;0,0.687500000000000,1;0,0.750000000000000,1;0,0.812500000000000,1;0,0.875000000000000,1;0,0.937500000000000,1;0,1,1;0.117647059261799,0.992647051811218,0.992647051811218;0.235294118523598,0.985294103622437,0.985294103622437;0.352941185235977,0.977941155433655,0.977941155433655;0.470588237047195,0.970588207244873,0.970588207244873;0.588235318660736,0.963235318660736,0.963235318660736;0.705882370471954,0.955882370471954,0.955882370471954;0.823529422283173,0.948529422283173,0.948529422283173;0.941176474094391,0.941176474094391,0.941176474094391;0.948529422283173,0.948529422283173,0.823529422283173;0.955882370471954,0.955882370471954,0.705882370471954;0.963235318660736,0.963235318660736,0.588235318660736;0.970588207244873,0.970588207244873,0.470588237047195;0.977941155433655,0.977941155433655,0.352941185235977;0.985294103622437,0.985294103622437,0.235294118523598;0.992647051811218,0.992647051811218,0.117647059261799;1,1,0;1,0.937500000000000,0;1,0.875000000000000,0;1,0.812500000000000,0;1,0.750000000000000,0;1,0.687500000000000,0;1,0.625000000000000,0;1,0.562500000000000,0;1,0.500000000000000,0;1,0.437500000000000,0;1,0.375000000000000,0;1,0.312500000000000,0;1,0.250000000000000,0;1,0.187500000000000,0;1,0.125000000000000,0;1,0.0625000000000000,0;1,0,0;0.937500000000000,0,0;0.875000000000000,0,0;0.812500000000000,0,0;0.750000000000000,0,0;0.687500000000000,0,0;0.625000000000000,0,0;0.562500000000000,0,0;0.500000000000000,0,0]);
%%% Create a cell array with column names for the input file 
colheaders = {'Year','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}; % Column headers

%%% Load the data for the site from the /Data directory:
stn_data = readmatrix(['Data/' station_name '.csv']); % Note how we've built the filename from the station name.
%%% <**TO DO**> Open up the data in the Variable Browser and inspect. 
openvar('stn_data')

%%% Pull out years and temperatures from stn_data
% Adelaide Airport data
ref_start = 1951;
ref_end = 1980;
years_adelaide = stn_data(:,1); 
years_adelaide = double(years_adelaide) % column of years
temps_adelaide = stn_data(:,2:end);     % monthly temperatures
temps_adelaide(temps_adelaide==-9999) = NaN;
temps_adelaide = temps_adelaide./100;   % degrees Celsius

% Annual mean and anomalies
annual_mean_adelaide = mean(temps_adelaide, 2, 'omitnan');
annual_mean_ref_adelaide = mean(annual_mean_adelaide(...
    years_adelaide>=ref_start & years_adelaide<=ref_end & ~isnan(annual_mean_adelaide)));
anoms_annual = annual_mean_adelaide - annual_mean_ref_adelaide;

%%% Create some labels to use for plotting
first_ten_mult = find(mod(years,10)==0,1,'first'); % Find the first year in the time series that is evenly divisible by 10. 
year_labels = num2str(years([first_ten_mult:20:numel(years)])); % We'll create a set of labels that start at the first_ten_mult and advance by 20.

%%%%%%%%%%%%%%%%%%%%
%% Calculate annual means, anomalies

%%% Calculate annual means so that years with an NaN in any month will also have NaNs in annual average 
% <**TO DO**> Figure out how to take the mean of all years (i.e. average temperatures for each row across columns <TO DO> 
annual_mean = mean(stn_data, 2); % <**TO DO**> hint: enter 'doc mean' into the command window to learn how to average across columns

% Mean of reference period -- take average of all non-NaNs between the reference years
annual_mean_ref = mean(annual_mean(years_adelaide>=ref_start & years_adelaide<= ref_end & ~isnan(annual_mean)));

%%% <**TO DO**> Calculate Annual anomalies by subtracting annual_mean_ref from annual_mean and <TO DO>
anoms_annual = annual_mean - annual_mean_ref;
length(annual_mean)
%% --- Adelaide Trendline Calculation ---

% Convert x to numeric
if isduration(years_adelaide)
    x = years(years_adelaide);   % convert duration -> numeric years
elseif isdatetime(years_adelaide)
    x = year(years_adelaide);    % convert datetime -> numeric years
else
    x = double(years_adelaide);  % already numeric
end

% Ensure y is numeric
y = double(anoms_annual);

% Make column vectors
x = x(:);
y = y(:);

% Remove NaNs consistently
validInd = ~isnan(x) & ~isnan(y);
x = x(validInd);
y = y(validInd);

% Check there are enough points
if numel(x) < 2
    error('Not enough valid data points to fit a trend.');
end

% Center x for numerical stability
x = x - mean(x);

% Fit linear trend
p = polyfit(x, y, 1);   % p(1) = slope, p(2) = intercept

% Optional: evaluate trendline
y_fit = polyval(p, x);
%% --- Calculate linear trend ---
% Compute anomalies if not already done
% Ensure numeric years
years_numeric = double(years_adelaide(:));

% Remove NaNs for fitting
ind = ~isnan(years_numeric) & ~isnan(anoms_annual);

% Fit linear trend
p = polyfit(years_numeric(ind), anoms_annual(ind), 1);

% Evaluate trend over all years
anoms_annual_trend = polyval(p, years_numeric);


%% Convert years to numeric (DO THIS ONCE)
if isduration(years)
    years_numeric = years(years);      % duration → numeric
elseif isdatetime(years)
    years_numeric = year(years);       % datetime → numeric
else
    years_numeric = double(years);     % already numeric
end
ref_ind = years_numeric >= ref_start & years_numeric <= ref_end;
ref_mean = mean(temps(ref_ind), 'omitnan');
anoms_annual = temps - ref_mean;

% Ensure years and anomalies are column vectors
x = years_numeric(:);          % numeric years
y = anoms_annual(:);           % anomalies

% Ignore NaNs
ind = ~isnan(x) & ~isnan(y);

% Fit first-order polynomial (linear trend)
p = polyfit(x(ind), y(ind), 1);  

% Evaluate trend for all years
anoms_annual_trend = polyval(p, x);
%% Figure 1: Create line plot and save it to the /Figs directory with a filename that matches the station name (i.e., "Adelaide Airport_timeseries.png") *** YOU NEED TO FINISH THIS *** 
if isduration(years_adelaide)
    years_numeric = years(years_adelaide);   % duration -> numeric
elseif isdatetime(years_adelaide)
    years_numeric = year(years_adelaide);    % datetime -> numeric
else
    years_numeric = double(years_adelaide);
end
% --- Original data ---
y_data = anoms_annual(:);
% --- Fit trendline ---
x_centered = years_numeric - mean(years_numeric);
y_trend = polyval(p, x_centered);
%%% Plot (this part is done)
fig1 = figure; clf;
plot(years,anoms_annual,'b.-'); hold on; % Plot the anomaly time series
plot(years,anoms_annual_trend,'r-'); % Plot the trend line
%%% <**TO DO**> Annotate and style the figure. YOU NEED TO FINISH THIS <**TO DO**> 
ylabel('Annual Temperature Anomaly (°C)'); 
xlabel('Year');
legend('Annual anomalies', 'Linear trend', 'Location', 'best');
title([station_name ' Annual Temperature Anomalies']);
print('-dpng',['Figs\' station_name '_timeseries']); % saves as "Adelaide Airport_timeseries.png" with the name of the station in the filename. See how handy it is to reuse variables?

grid on; box on;

% Enlarge fonts for readability
set(gca, 'FontSize', 12);

% Ensure Figs folder exists
if ~exist('Figs','dir')
    mkdir('Figs');
end

% Save figure (PNG)
print('-dpng', ['Figs\' station_name '_timeseries']);
%%%%%%%%%%%%%%%%%%%%%
%% Figure 2: Create a 'Barcode' graph of Annual anomalies and save it to the /Figs directory with a filename that matches the station name (i.e., "Adelaide Airport_barcode.png" *** YOU NEED TO FINISH THIS *** 
%%% Rearrange and plot (This is done for you)
anoms_annual_plot = anoms_annual'; % transpose for plotting purposes
anoms_annual_plot(isnan(anoms_annual_plot))=0;
fig2 = figure;
imagesc(anoms_annual_plot);
shading flat;
colormap(cmap); % Sets a colormap using the cmap array we created at the beginning of the script.
caxis([-2 2]); % Scales the limits of the colours to +/- 2 degrees C
c2 = colorbar; 
set(gca,'XTick',[first_ten_mult:20:numel(years)]);
set(gca,'XTickLabels',year_labels);
set(gca,'YTick',[]); % Leave this blank-it removes ticks on the y-axis.
%%% <TO DO> Save this in the Figs\ directory (as above) with the name of the station and '_barcode' (i.e. '\Figs\Adelaide Airport_barcode') <TO DO>
ylabel(c2,'Temperature Anomaly (°C)');   % Colorbar label
print('-dpng', ['Figs\' station_name '_barcode']);   % Save as "Adelaide Airport_barcode.png"
%% Part 2: Plot a scatterplot of annual temperature anomalies between Adelaide Airport and Detroit Airport (Detroit Metro Ap.csv)
%%% --- Load and prepare Detroit Airport data ---
% Load the Detroit data file
stn_data_detroit = readmatrix('Data/DETROIT_METRO_AP.csv');

% Extract years
years = stn_data_detroit(:,1);

% Replace -9999 with NaN
stn_data_detroit(stn_data_detroit == -9999) = NaN;

% Calculate Detroit annual means (across columns)
monthly_detroit = stn_data_detroit(:, 2:13);
annual_mean_detroit = mean(monthly_detroit, 2, 'omitnan');

% Calculate Detroit reference-period mean (same years 1951–1980)
annual_mean_ref_detroit = mean(annual_mean_detroit( ...
    years>=ref_start & years<=ref_end & ~isnan(annual_mean_detroit)));

% Calculate Detroit annual anomalies
anoms_annual_detroit = annual_mean_detroit - annual_mean_ref_detroit;

%%% --- SCATTERPLOT ---
fig3 = figure; clf;

% Find common years between Adelaide and Detroit
common_start = max(min(years_adelaide), min(years_detroit));
common_end   = min(max(years_adelaide), max(years_detroit));
common_years = common_start:common_end;

% Get indices for each dataset
idx_adelaide = ismember(years_adelaide, common_years);
idx_detroit  = ismember(years_detroit,  common_years);

% Select anomalies for common years
x = anoms_annual(idx_adelaide);
y = anoms_annual_detroit(idx_detroit);

% Remove any NaNs
valid = ~isnan(x) & ~isnan(y);

% Scatter plot
scatter(x(valid), y(valid), 'filled');
xlabel('Adelaide Annual Anomaly (°C)');
ylabel('Detroit Annual Anomaly (°C)');
title('Annual Temperature Anomalies: Adelaide vs Detroit');
grid on;
set(gca, 'FontSize', 12);

%%% Save figure
if ~exist('Figs','dir')
    mkdir('Figs');
end

print('-dpng', 'Figs\Adelaide_vs_Detroit');

