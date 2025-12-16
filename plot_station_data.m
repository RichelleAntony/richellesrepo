function [] = plot_station_data(station_name, ref_start, ref_end)
%%% Note that this function should be run while MATLAB is in the directory
%%% containing the /Data folder (i.e. /MATLAB Drive/iSci3A12-CC-SciProgramming/)
% This function.....
%
%
% inputs:
% station_name: the name of a station's data file as it appears in ```/Data``` (e.g. ```ANCHORAGE_INTL_AP```, ```Jakutsk```, etc.). 
%%% - If station_name is entered as 'all', this function will process all site data in ```/Data``` at once (in a loop)
% ref_start: the reference period start year for calculating anomalies (e.g. 1951)
% ref_end: the reference period end year for calculating anomalies (e.g. 1980)
%
% outputs:
% two figures are created and saved in the /Figs directory: 
%%% - A *timeseries* figure named ```<stationName>_timeseries.png```, where ```<stationName>``` is the file name of the station data file, and 
%%% - A *barcode* figure named ```<stationName>_barcode.png```, where ```<stationName>``` is the file name of the station data file.
%
%
%
% usage example: plot_station_data('ADELAIDE_AIRPORT', 1951, 1980)
%
% To process all stations in /Data:
% plot_station_data('all', 1951, 1980)

%
% created by: Richelle Antonythasan
%
%



%% Your tasks with this function:
%%% 1. Complete the code so that it meets the requirements laid out on your
%%% assignment webpage (https://isci-3a12.github.io/scientific-programming/lesson5.html)
%%% 2. Style each figure and ensure that they print to file properly
%%% 3. Comment the top and other lines appropriately.

%% Declare variables (THIS PART IS DONE FOR YOU)

%%% Colormap (used for barcode plots)
cmap = ([0,0,0.562500000000000;0,0,0.625000000000000;0,0,0.687500000000000;0,0,0.750000000000000;0,0,0.812500000000000;0,0,0.875000000000000;0,0,0.937500000000000;0,0,1;0,0.0625000000000000,1;0,0.125000000000000,1;0,0.187500000000000,1;0,0.250000000000000,1;0,0.312500000000000,1;0,0.375000000000000,1;0,0.437500000000000,1;0,0.500000000000000,1;0,0.562500000000000,1;0,0.625000000000000,1;0,0.687500000000000,1;0,0.750000000000000,1;0,0.812500000000000,1;0,0.875000000000000,1;0,0.937500000000000,1;0,1,1;0.117647059261799,0.992647051811218,0.992647051811218;0.235294118523598,0.985294103622437,0.985294103622437;0.352941185235977,0.977941155433655,0.977941155433655;0.470588237047195,0.970588207244873,0.970588207244873;0.588235318660736,0.963235318660736,0.963235318660736;0.705882370471954,0.955882370471954,0.955882370471954;0.823529422283173,0.948529422283173,0.948529422283173;0.941176474094391,0.941176474094391,0.941176474094391;0.948529422283173,0.948529422283173,0.823529422283173;0.955882370471954,0.955882370471954,0.705882370471954;0.963235318660736,0.963235318660736,0.588235318660736;0.970588207244873,0.970588207244873,0.470588237047195;0.977941155433655,0.977941155433655,0.352941185235977;0.985294103622437,0.985294103622437,0.235294118523598;0.992647051811218,0.992647051811218,0.117647059261799;1,1,0;1,0.937500000000000,0;1,0.875000000000000,0;1,0.812500000000000,0;1,0.750000000000000,0;1,0.687500000000000,0;1,0.625000000000000,0;1,0.562500000000000,0;1,0.500000000000000,0;1,0.437500000000000,0;1,0.375000000000000,0;1,0.312500000000000,0;1,0.250000000000000,0;1,0.187500000000000,0;1,0.125000000000000,0;1,0.0625000000000000,0;1,0,0;0.937500000000000,0,0;0.875000000000000,0,0;0.812500000000000,0,0;0.750000000000000,0,0;0.687500000000000,0,0;0.625000000000000,0,0;0.562500000000000,0,0;0.500000000000000,0,0]);

%%% Create a cell array with column names for the input files
colheaders = {'StationID','Year','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}; % Column headers
% col 1 = year
% cols 2: 13: monthly (Jan - Dec) mean temperature (C)

%% Check if the user has entered 'all' for station_name. If so, we need to create a list of all csv files in the /Data directory
%%% THIS SECTION HAS BEEN DONE FOR YOU, but you should still try to understand how it works.

station_list = {}; % This will serve as our list of stations to process.
% If station_name is just one station (i.e. not 'all'), it'll consist of
% one entry. If station_name is 'all', it'll be a list with each station
% name that corresponds to data (csv) files in /Data.

if strcmpi((station_name),'all')==1 % Check to see if the value of station_name is 'all'
    %%% Get a list of all stations
    d = dir('Data/*.csv'); % The function 'dir' returns a listing of all files in a directory matching a certain criteria (.csv in this case)
    %%% Right now, the list of file names in d contain '.csv'. We want only
    %%% the filename and not the extension. Use fileparts to do this.
    for i = 1:1:length(d)
        [dir_path,fname,ext] = fileparts(d(i).name); %fileparts will split a filename like 'Adelaide Airport.csv' into fname = 'Adelaide Airport' and ext = '.csv'
        station_list{i,1} = fname; % station list in row i is the filename for that station.
    end
else
    % If the user hasn't asked to process all stations, then station_list
    % will have one entry (station_name):
    station_list{1,1} = station_name;
end
clear station_name; % We're clearing the value of station_name, as we'll reuse the variable below


%% Within the for loop, cycle through each station (even if there is only one station in the list), perform analyses, plot results, save figures:
for i = 1:1:size(station_list,1) % cycle through each entry in station_list
    
    %% Load the correct file, turn into degrees celsius
    %%% Load the data file using station_name (THIS HAS BEEN DONE FOR YOU)
    station_name = station_list{i,1};

fname = ['Data/' station_name '.csv'];
disp(['Loading file: ' fname])

stn_data = readmatrix(fname);

whos stn_data

years = stn_data(:,1);
temps = stn_data(:,2);

disp('After assignment:')
whos years temps

    %% Calculate annual means, anomalies
   ref_ind = years >= ref_start & years <= ref_end;       % Reference period indices
   ref_mean = mean(temps(ref_ind), 'omitnan');           % Reference mean, ignore NaNs
   anoms_annual = temps - ref_mean;     
    %% Calculate trendline
x = years(:);
y = anoms_annual(:);

% Ignore NaNs
ind = ~isnan(x) & ~isnan(y);

% Fit first-order polynomial (linear trend)
p = polyfit(x(ind), y(ind), 1);  % p(1) = slope, p(2) = intercept

% Evaluate trend line
anoms_annual_trend = polyval(p, x);
    %% Figure 1: Create line plot and save it to the /Figs directory with a filename that matches the station name
% Find the first year evenly divisible by 10
first_ten_mult = find(mod(years, 10) == 0, 1, 'first');
% Create labels for every 20 years starting from first_ten_mult
year_labels = num2str(years(first_ten_mult:20:end));
fig1 = figure;
plot(years, anoms_annual, 'b-', 'LineWidth', 1.5); hold on;
plot(years, anoms_annual_trend, 'r-', 'LineWidth', 2); % Trend line
xlabel('Year');
ylabel('Temperature Anomaly (°C)');
title([station_name ' - Annual Temperature Anomalies']);
legend('Annual Anomaly', 'Linear Trend', 'Location', 'best');
grid on;

% Save figure
if ~exist('Figs','dir')
    mkdir('Figs')  % create Figs folder if it doesn't exist
end
print('-dpng', fullfile('Figs', [station_name '_timeseries']));
    %% Figure 2: Create a 'Barcode' graph of Annual anomalies and save it to the /Figs directory with a filename that matches the station name
   %%% Rearrange and plot
ref_ind = years >= ref_start & years <= ref_end;
ref_mean = mean(temps(ref_ind), 'omitnan');  % average over reference years

anoms_annual = temps - ref_mean;
   anoms_annual_plot = anoms_annual'; % transpose for plotting
anoms_annual_plot(isnan(anoms_annual_plot)) = 0;

fig2 = figure;
imagesc(anoms_annual_plot);
shading flat;

colormap(cmap);
caxis([-2 2]);

c2 = colorbar;
ylabel(c2,'Temperature Anomaly (°C)');

set(gca,'XTick',[first_ten_mult:20:numel(years)]);
set(gca,'XTickLabels',year_labels);
set(gca,'YTick',[]);

%%% Save figure
print('-dpng', fullfile('Figs', [station_name '_barcode']));
    
    %%% Clear out some variables before the next run
    clear stn_data annual_mean annual_mean* anoms_annual* p ind first_ten_mult year_labels
    pause(4); % 4 second delay (so you can view figures)
    close all % Close figures;
end
