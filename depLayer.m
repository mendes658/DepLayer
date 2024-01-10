close all;

ex = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                     DEFINITIONS                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WINDOWS = 0;
LINUX = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                   INITIALIZATIONS                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opSys = WINDOWS;
%opSys = LINUX;

if(exist('opSys'))
    if(opSys == WINDOWS),
        run(['.\examples\ex' num2str(ex, '%03d') '.m'])
    elseif(opSys == LINUX),
        run(['./examples/ex' num2str(ex, '%03d') '.m'])
    end
else,
    error('Define the operating system through the variable ''opSys''.');
end

if(LOAD)
   %model = 1; %ex=1
   
   model = 3; %ex=2
   
   %axis([0   500   0   500]);
   %xlabel('X');
   %ylabel('Y');
   if(exist('opSys'))
        if(opSys == WINDOWS),
            load(['.\saves\networks_' num2str(ex, '%03d') '_' num2str(model) '.mat'])
        elseif(opSys == LINUX),
            load(['./saves/networks_' num2str(ex, '%03d') '_' num2str(model) '.mat'])
        end
    else,
        error('Define the operating system through the variable ''opSys''.');
    end
else
    placeRandomNetworks;
end

tic


totalNets = sum(nNets);

wMBs = floor(w/sizeMB); %M
hMBs = floor(h/sizeMB); %N
ws = w/wMBs;
hs = h/hMBs;
M = wMBs; %Number of COLUMNs in the grid
N = hMBs; %Number of ROWs in the grid


%
%##OBJECTIVE FUNCTION of CONNECTIVITY LEVEL##
%   f(CTSR) = -'C'ost +'T'hroughput +'S'ecurity +'R'eliability
%
CTSR = 0; % Maximun objective function value, considering a region with all nets overlapping
for i=1:size(paramNets,1),
    CTSR = CTSR - C*paramNets(i).c +  T*paramNets(i).t +  S*paramNets(i).s +  R*paramNets(i).r;
end



%% INITIAL PLOT
color = ['k' 'b' 'm' 'c'];
nC = size(color,2);
if(PLOT_GRAPHS)
    hold on;
    cLegends = [];
    iNets = [];
    for i=1:size(networks,1),
        graphCircle = circle2(networks(i,2), networks(i,3),paramNets( networks(i,1) ).R);
        set(graphCircle,'LineStyle',':','LineWidth',1.5,'EdgeColor',color(mod( networks(i,1),nC )+1));
        
        if(~ismember(networks(i,1),iNets))
            iNets = [iNets, networks(i,1)];
            hline = plot(NaN,NaN,'LineWidth',1.5,'LineStyle',':','Color',color(mod( networks(i,1),nC )+1));
            cLegends = [cLegends paramNets( networks(i,1) ).name];
        end
    end
end

%%% Exclusive zones, there will be more than 1 sensor in a zone...
%%% ... only if all the other zones have at least 1 or there is...
%%% ... not a maxConn value at the other zones
exZonesW = 7; % Quantity of zones through the width
exZonesH = 6; % Quantity of zones through the height

sizeZonesW = ceil(wMBs / exZonesW);
sizeZonesH = ceil(hMBs / exZonesH);

%%
%parfor mIndex=1:wMBs,
zonesByDivision = cell(exZonesH+1, exZonesW+1); % zones organized by exZones divs
zonesByDivAndLevel = cell(1, nConnLevels); % zones organized by exZones divs and ConnLevel

for i=1:nConnLevels
    zonesByDivAndLevel{i} = zonesByDivision;
end

mDiv = 1;
nDiv = 1;

MBs = zeros(hMBs,wMBs);
MBs_classes = zeros(hMBs,wMBs);
for mIndex=1:wMBs

    if (mod(mIndex,sizeZonesW) == 0 && mIndex ~= 1)
        mDiv = mDiv + 1;
    end

    for nIndex=1:hMBs  
        if (mod(nIndex,sizeZonesH) == 0)
            nDiv = nDiv + 1;
        end

        if (nIndex == 1)
            nDiv = 1;
        end

        x1s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
        y1s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
        x2s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
        y2s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
        x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
        y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
        x4s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
        y4s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
        
        xc = x1s + (x4s-x1s)/2;
        yc = y1s + (y4s-y1s)/2;
        
        
        %##OBJECTIVE FUNCTION of CONNECTIVITY LEVEL##
        %   f(CTSR) = -'C'ost +'T'hroughput +'S'ecurity +'R'eliability
        connLevel = 0;
        for i=1:size(networks,1),
            %if a MB is within a network, add the connLevel of this network
            [in, dist] = isWithinNet( xc, yc, networks(i,:), paramNets(networks(i,1)).R );
        
        
            if( in ),
                connLevel = connLevel + (-C*paramNets(networks(i,1)).c + T*paramNets(networks(i,1)).t + S*paramNets(networks(i,1)).s + R*paramNets(networks(i,1)).r)/CTSR;
            end
        end
        
        MBs(nIndex,mIndex) = connLevel;
        
        if( connLevel < connLevelMin),
            %
            MBs_classes(nIndex,mIndex) = 0;
            if(DOTTED)
                rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'LineStyle',':','EdgeColor',[.9,.9,.9]);
            end
        else
            for i=1:nConnLevels,
                if( connLevel >= connLevelRange(i) && connLevel < connLevelRange(i+1)),
                    if(PLOT_GRAPHS)
                        hold on;
                        if(DOTTED)
                            rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'LineStyle',':','EdgeColor',[.4,.4,.4],'FaceColor',levelColors(i));
                        else
                            rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'EdgeColor',levelColors(i),'FaceColor',levelColors(i));
                        end
                    end
                    MBs_classes(nIndex,mIndex) = i;
                    
                    zonesByDivision{nDiv,mDiv} = [zonesByDivision{nDiv,mDiv}, struct("m", mIndex, "n", nIndex, "l", i)];
                    zonesByDivAndLevel{i}{nDiv,mDiv} = [zonesByDivAndLevel{i}{nDiv,mDiv}, struct("m", mIndex, "n", nIndex, "l", i)];
                end
            end
        end
        
        if(PLOT_GRAPHS && PLOT_MBS),
            hold on;
            %%patch([x1s, x2s, x4s, x3s],[y1s, y2s, y4s, y3s],[.9 .9 .9])
            %line([x1s x2s],[y1s y2s],'Color','r','LineStyle',':','LineWidth',1.0);
            %line([x2s x4s],[y2s y4s],'Color','r','LineStyle',':','LineWidth',1.0);
            %line([x4s x3s],[y4s y3s],'Color','r','LineStyle',':','LineWidth',1.0);
            %line([x3s x1s],[y3s y1s],'Color','r','LineStyle',':','LineWidth',1.0);
            
            grayColor = [.7 .7 .7];
            line([x1s x2s],[y1s y2s],'Color',grayColor,'LineStyle',':','LineWidth',1.0);
            line([x2s x4s],[y2s y4s],'Color',grayColor,'LineStyle',':','LineWidth',1.0);
            line([x4s x3s],[y4s y3s],'Color',grayColor,'LineStyle',':','LineWidth',1.0);
            line([x3s x1s],[y3s y1s],'Color',grayColor,'LineStyle',':','LineWidth',1.0);
        end
        
    end
end

placeSensors;
%plotGraphsSensors;

%% PLOTs
x2 = x1 + w*cos(beta);
y2 = y1 + w*sin(beta);
x3 = x1 + h*sin(beta);
y3 = y1 - h*cos(beta);
x4 = x1 + h*sin(beta) + w*cos(beta);
y4 = y1 - h*cos(beta) + w*sin(beta);

if(PLOT_GRAPHS)
    line([x1 x2],[y1 y2],'Color','k');
    line([x2 x4],[y2 y4],'Color','k');
    line([x4 x3],[y4 y3],'Color','k');
    line([x3 x1],[y3 y1],'Color','k');
    legend(cLegends);
end


if(PLOT_GRAPHS)
    for i=1:size(networks,1),
        graphCircle = circle2(networks(i,2), networks(i,3),paramNets( networks(i,1) ).R);
        set(graphCircle,'LineStyle',':','LineWidth',1.5,'EdgeColor',color(mod( networks(i,1),nC )+1));
    end 

    legend(cLegends);
end

%%
markedMBs = zeros(N,M);

fifoMB = [];
stackMB = [];
RiskZone = [];
zoneList = cell(1,nConnLevels);
countZones = zeros(1,nConnLevels);

for nIndex=1:hMBs,
	for mIndex=1:wMBs,
        %if it was found a zone...
        if( (markedMBs(nIndex,mIndex)==0) && (MBs_classes(nIndex,mIndex)~=0) )
            %matrixBFS;         %#See v1
            %matrixBFSmodLine;  %#See v1
            matrixDFS;
        end
    end
end

toc 

%%


%%
%deployEDUs




%axis([-100 600 -100 600]);%
%     %axis([0 240 0 180]);%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     grid;
%     xl = xlim;
%     yl = ylim;
%     pbaspect([1 (yl(2)-yl(1))/(xl(2)-xl(1)) 1]); 