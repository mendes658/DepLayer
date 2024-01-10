%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Example to Journal    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               DEFINITIONS              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PLOT_GRAPHS = 1;
PLOT_MBS = 0;
DOTTED = 0;
LOAD = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            AREA PLOT, Ex = 1           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = 5000;     %monitoring area            5000 8000        
w = 8000;
%h_mf = 500;  %mf: monitoring field - larger area where the monitoting area is within                               
%w_mf = 500;                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Coordinates of vertix A        
x1 = 50; %what if the area has been rotated?
y1 = x1+h; %what if the area has been rotated?
beta = 0*pi/180;
cosBeta = cos(beta);
sinBeta = sin(beta);

x2 = x1 + w*cosBeta;
y2 = y1 + w*sinBeta;
x3 = x1 + h*sinBeta;
y3 = y1 - h*cosBeta;
x4 = x1 + h*sinBeta + w*cosBeta;
y4 = y1 - h*cosBeta + w*sinBeta;

%sizeMB = 1; %Meters
%sizeMB = 2; %Meters
%sizeMB = 5; %Meters
%sizeMB = 10; %Meters
%sizeMB = 15; %Meters
%sizeMB = 20; %Meters
sizeMB = 50; %Meters 50
%sizeMB = 75; %Meters





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          NETWORKS DEFINITION           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%https://ovyl.io/insights-and-news/wireless-technologies

paramNets = []; %list of parameters from each network
networks = [];
netMin = 1;
netMax = 5;

%Network 1 - WiFi
Rn1 = 100; %meters of Range of communiucation
nm1 = "WiFi";
c1 = 2; %cost
t1 = 4; %throughput
s1 = 5; %security level
r1 = 4; %reliability
paramNets = [paramNets; struct('R', Rn1, 'name', nm1, 'c', c1, 't', t1, 's', s1, 'r', r1)];

%Network 2 - 5G
Rn2 = 400; %meters of Range of communiucation
nm2 = "5G";
c2 = 5;
t2 = 5;
s2 = 3;
r2 = 2;
paramNets = [paramNets; struct('R', Rn2, 'name', nm2, 'c', c2, 't', t2, 's', s2, 'r', r2)];

%Network 3 - 6LoWPAN
Rn3 = 150; %meters of Range of communiucation
nm3 = "6LoWPAN";
c3 = 3;
t3 = 3;
s3 = 2;
r3 = 3;
paramNets = [paramNets; struct('R', Rn3, 'name', nm3, 'c', c3, 't', t3, 's', s3, 'r', r3)];

%Network 4 - LoRa
Rn4 = 1000; %75 meters of Range of communiucation
nm4 = "LoRa";
c4 = 5;
t4 = 1;
s4 = 2;
r4 = 4;
paramNets = [paramNets; struct('R', Rn4, 'name', nm4, 'c', c4, 't', t4, 's', s4, 'r', r4)];

nNets = [50, 50, 50, 2];

%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      OBJECTIVE FUNCTION PARAMETERS     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = 1; %'C'ost
T = 1; %'T'hroughput
S = 1; %'S'ecurity
R = 1; %'R'eliability (of packet delivering - depends on the DISTANCE to the Access Point)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           CONNECTIVITY LEVELS          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nConnLevels = 3; % Number of connectivity levels
%nConnLevels = 4;
%nConnLevels = 5;
constConnLevels = 0:nConnLevels; %0 - No connectivity; 1 - Lowest connectivity; (...) ; nConnLevels - Highest connectivity
connLevelMin = 0.00001;
connLevelRange = connLevelMin:(1-connLevelMin)/nConnLevels:1; %Range of values of each connectivity level
%%%%%%
connLevelRange(nConnLevels+1) = Inf;
%%%%%%


levelSum = nConnLevels*(1+nConnLevels)/2;

%levelColors = ['b','c','r','y','g'];  %Colors of PLOT of each connectivity level - Lowest to Highest
%levelColors = ['c','r','y','g'];
levelColors = ['r','y','g'];


nEDUs = 150;