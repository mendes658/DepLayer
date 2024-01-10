color = ['y' 'k' 'r' 'b' 'g' 'm' 'c' 'w'];
nC = size(color,2);

hold on;
cLegends = [];
for i=1:nNets,
    %viscircles([networks(i).Ap(1), networks(i).Ap(2)],networks(i).R,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1));
    %cLegends = [cLegends networks(i).name];
    graphCircle = circle2(networks(i).Ap(1), networks(i).Ap(2),networks(i).R);
    %set(h,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1),'DisplayName',networks(i).name);
    set(graphCircle,'LineStyle',':','LineWidth',1.5,'EdgeColor',color(mod(i,nC)+1));
    
    hline = plot(NaN,NaN,'LineWidth',1.5,'LineStyle',':','Color',color(mod(i,nC)+1));
    cLegends = [cLegends networks(i).name];
end


for mIndex=1:wMBs,
    for nIndex=1:hMBs,
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
        
        
        connLevel = MBs(nIndex,mIndex);
        
        if( connLevel > connLevelMin),
            for i=1:nConnLevels,
                if( connLevel >= connLevelRange(i) && connLevel < connLevelRange(i+1)),
                    hold on;
                    rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'EdgeColor',levelColors(i),'FaceColor',levelColors(i));
                end
            end
        end
        
        
        if(PLOT_GRAPHS),
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






x2 = x1 + w*cos(beta);
y2 = y1 + w*sin(beta);
x3 = x1 + h*sin(beta);
y3 = y1 - h*cos(beta);
x4 = x1 + h*sin(beta) + w*cos(beta);
y4 = y1 - h*cos(beta) + w*sin(beta);


line([x1 x2],[y1 y2],'Color','k');
line([x2 x4],[y2 y4],'Color','k');
line([x4 x3],[y4 y3],'Color','k');
line([x3 x1],[y3 y1],'Color','k');
legend(cLegends);



for i=1:nNets,
    %viscircles([networks(i).Ap(1), networks(i).Ap(2)],networks(i).R,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1));
    %cLegends = [cLegends networks(i).name];
    graphCircle = circle2(networks(i).Ap(1), networks(i).Ap(2),networks(i).R);
    %set(h,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1),'DisplayName',networks(i).name);
    set(graphCircle,'LineStyle',':','LineWidth',1.5,'EdgeColor',color(mod(i,nC)+1));
end

legend(cLegends);