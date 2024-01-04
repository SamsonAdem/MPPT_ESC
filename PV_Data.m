%% Load tempreature and insolation data from excel file.
% Data source: https://re.jrc.ec.europa.eu/pvg_tools/en/#DR
% Data Base: PVGIS-ERA5
% Insolation Data: Direct insolation(W/m2)
% Temperature Data: Temperature value (oC)
% PV-type: BP365, sun tracking data
% PV_spec: Pmax = 65W, Voc = 22.1v, Vmp = 17.6v, Imp = 3.69A, Isc = 3.99A
% Area: Sonderborg, SDU  
% Data for: June, December

% Duration 
x_time = duration(0:23,45,0)';
x = (0:1:23)';

% Import data for June

June_data = readtable("June_Temp_Radiation.xlsx"); % Change the xlsread to readtable function
June_temp = June_data(:,2);
June_Insolation = June_data(:,1);

% Import data for December

December_data = xlsread("December_Temp_Radiation.xlsx");
December_temp = December_data(:,2);
December_Insolation = December_data(:,1);

% Plot Data for December
subplot(2,2,1)
plot(x_time,December_Insolation)
title("Dec Insolation W/m^2")
ylabel("W/m^2")
xlabel("Hours")
grid on

subplot(2,2,3)
plot(x_time,December_temp)
title("Dec T^oC")
ylabel("T^oC")
xlabel("Hours")
grid on

subplot(2,2,2)
plot(x_time,June_Insolation)
title("June Insolation W/m^2")
ylabel("W/m^2")
xlabel("Hours")
grid on

subplot(2,2,4)
plot(x_time,June_temp)
title("June T^oC")
ylabel("T^oC")
xlabel("Hours")
grid on


%% Calculating the True maximum values 
Ptrue = zeros(length(June_Insolation),1); Vmax = zeros(length(June_Insolation),1);
for i = 1: length(June_Insolation)
    Ti = June_temp(i); Gi= June_Insolation(i);
    [P,Ptrue(i),Vmax(i)] = PVfunction(Ti,Gi); 
    
end


%% Interpolation of data
xq = (0:0.1:24)';
Pint = interp1(x,Ptrue,xq);
Vint = interp1(x,Vmax,xq);
Pint(isnan(Pint)) = 0; 
Vint(isnan(Vint)) = 0; 
Ptrue = Pint;
%%  for test data
% [~,Pii,Vmaxii] = PVfunction(25,1000);  %  run this for testing the data
% and pv function 

   
