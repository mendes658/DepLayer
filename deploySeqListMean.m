
posEDUs = [];

singleZoneHigh=[];
singleZoneLow=[];
MBs_singleZone=[];
for i=1:size(singleZone,1)
    MBs_singleZone(i) = MBs(singleZone(i,1),singleZone(i,2));
end
meanSingleZone = mean(MBs_singleZone);

for i=1:size(singleZone,1)
    if(MBs(singleZone(i,1),singleZone(i,2))>=meanSingleZone)
        singleZoneHigh(end+1,:) = singleZone(i,:);
    else
        singleZoneLow(end+1,:) = singleZone(i,:);
    end
end


lengthZoneHigh = size(singleZoneHigh,1);
sector = floor(lengthZoneHigh/(floor(nZoneEDUs/2)));
for ii=1:floor(nZoneEDUs/2)
    
    row = singleZoneHigh(floor((ii)*sector-sector/2),1);
    col = singleZoneHigh(floor((ii)*sector-sector/2),2);
    
    %%%%
    x1s = x1 + (col-1)*(w/M)*cosBeta + (row-1)*(h/N)*sinBeta;
    y1s = y1 + (col-1)*(w/M)*sinBeta - (row-1)*(h/N)*cosBeta;
    x2s = x1 + (col)*(w/M)*cosBeta + (row-1)*(h/N)*sinBeta;
    y2s = y1 + (col)*(w/M)*sinBeta - (row-1)*(h/N)*cosBeta;
    x3s = x1 + (col-1)*(w/M)*cosBeta + (row)*(h/N)*sinBeta;
    y3s = y1 + (col-1)*(w/M)*sinBeta - (row)*(h/N)*cosBeta;
    x4s = x1 + (col)*(w/M)*cosBeta + (row)*(h/N)*sinBeta;
    y4s = y1 + (col)*(w/M)*sinBeta - (row)*(h/N)*cosBeta;
    
    xc = x1s + (x4s-x1s)/2;
    yc = y1s + (y4s-y1s)/2;
    
    
    posX = xc;
    posY = yc;
    
    plot(posX, posY, 's', 'MarkerSize',10,...
        'MarkerEdgeColor','blue',...
        'MarkerFaceColor','blue');
    
    posEDUs(end+1,:) = [posX posY];
    
    
    %plot(posX, posY, 'o', 'MarkerSize',10,...
    %                        'MarkerEdgeColor','black',...
    %                        'MarkerFaceColor','black');
end

lengthZoneLow = size(singleZoneLow,1);
sector = floor(lengthZoneLow/(nZoneEDUs-floor(nZoneEDUs/2)));
for ii=1:(nZoneEDUs-floor(nZoneEDUs/2))
    row = singleZoneLow(floor((ii)*sector-sector/2),1);
    col = singleZoneLow(floor((ii)*sector-sector/2),2);
    
    %%%%
    x1s = x1 + (col-1)*(w/M)*cosBeta + (row-1)*(h/N)*sinBeta;
    y1s = y1 + (col-1)*(w/M)*sinBeta - (row-1)*(h/N)*cosBeta;
    x2s = x1 + (col)*(w/M)*cosBeta + (row-1)*(h/N)*sinBeta;
    y2s = y1 + (col)*(w/M)*sinBeta - (row-1)*(h/N)*cosBeta;
    x3s = x1 + (col-1)*(w/M)*cosBeta + (row)*(h/N)*sinBeta;
    y3s = y1 + (col-1)*(w/M)*sinBeta - (row)*(h/N)*cosBeta;
    x4s = x1 + (col)*(w/M)*cosBeta + (row)*(h/N)*sinBeta;
    y4s = y1 + (col)*(w/M)*sinBeta - (row)*(h/N)*cosBeta;
    
    xc = x1s + (x4s-x1s)/2;
    yc = y1s + (y4s-y1s)/2;
    
    
    posX = xc;
    posY = yc;
    
    plot(posX, posY, 's', 'MarkerSize',10,...
        'MarkerEdgeColor','blue',...
        'MarkerFaceColor','blue');
    
    posEDUs(end+1,:) = [posX posY];
    
    
    %plot(posX, posY, 'o', 'MarkerSize',10,...
    %                        'MarkerEdgeColor','black',...
    %                        'MarkerFaceColor','black');
end