clear all;close all;clc

%% Characterization Of Photovoltaic Panel Using Single Diode Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
it=input('Enter the number of curves you aim to plot: 1,2...N: ');
for N=1:it
%% PV Module DATA
T=input('Enter the value of T en °C: ');                    % Temperature of the celle en °C
G=input('Enter the value of solar irradiance en °W/m2: ');  % Solar Irradiance en W/m2
ai=0.034/100;                     % Current Tmperature coefficient(ki)
av=-0.34/100;                     % Voltage Tmperature coefficient(kv)
Isc_r=5.3;                        % Short-circuit current
Voc_r=44.2;                       % Opent circuit voltage
Vm=36;                            % Maximum voltage @ STC
Im=4.87;                          % Maximum current @ STC
Pm=175;                           % Maximum power   @ STC
Ns=72;                            % nomber of Cells   
n=1.3;                            % Diode ideality factor

%% Internal parameters%%%%%%%%%%%%%
Gr=1000;                          % reference irradiance
T=T+273.6;                        % 
Tr= 25 +273.6;                    % Temperature reference
dT=T-Tr;
Isc=Isc_r+ai*dT;                  % variation of Isc with T°
Voc=Voc_r+av*dT;                  % variation de Vco with T°
q=1.60217646*power(10,-19);       % charge constant
K=1.3806503*power(10,-23);        % Boltzmann constant
Vt=(Ns*n*K*T/q);                  % Thermal voltage 
Eg=1.12;                          % gap energy
Iph=Isc*(G/Gr);                   % photo-current
Iss=(Isc)/(   exp( Voc/Vt )-1 );  % saturation current
Is=Iss*( (T/Tr)^3 ) * exp ( ( (q*Eg)/(n*K) )*((1/Tr)-(1/T)) );%saturation current
Rs=0.2;                           % series resistance 
Rp=230;                           % parallele resistance
%%
I=Iph;             % initial codition
V=0:(Voc/100):Voc; % input voltage array
for n1=1:length(V) 
    
        
    for n2=1:20                          % Newton-Raphson loop for calculating output current
    Vd= (V(n1)+Rs*I);                    % Diode Voltage
    Id=Is*( exp(Vd/Vt) -1);              % Diode current
    Ip=Vd/Rp;                            % Parallele resistance Current
    f=Iph-I-Id-Ip;                       % f(I)=0
    df=-1-(Is*Rs/Vt)*exp(Vd/Vt)-(Rs/Rp); % f'(I)=0
    I=I-f/df;% Newton-Raphson formula
    
    end % end of Newton-Raphson
    
    if I<0
        I=0;
    end
    Ipv(n1)=I;                           % Accumulation of output currant 

end 
%%
P=Ipv.*V;% Output power
figure(1)
hold on
plot(V,Ipv,'linewidth',N)%  
grid on
figure(2)
plot(V,P,'linewidth',N)% 
hold on
grid on
end