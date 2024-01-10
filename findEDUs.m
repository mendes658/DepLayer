totalMBs = max(size(find(MBs_classes~=0)));

maxx = nConnLevels;

for j=1:nConnLevels
    
    levelMBs(j) = max(size(find(MBs_classes==j)));
    factorr = (maxx-j+1);
    %%nEDUs_byLevel(j) = floor( nEDUs*( (factorr/levelSum) + (levelMBs(j)/totalMBs) )/2  );
    %nEDUs_byLevel(j) = floor( nEDUs*( (levelSum/factorr) * (levelMBs(j)/totalMBs) )  );
    %nEDUs_byLevel(j) = floor( nEDUs*( (factorr) * (levelMBs(j)/totalMBs) )  );
    %nEDUs_byLevel(j) = floor( nEDUs*( (levelSum/j) * (levelMBs(j)/totalMBs) )  );
    nEDUs_byLevel(j) = floor( nEDUs*( (1/j) * (levelMBs(j)/totalMBs) )  );
end

%levelMBs
%nEDUs_byLevel
%sum(nEDUs_byLevel)
%levelMBs./nEDUs_byLevel

nEDUs_byLevel__Corrected = round(nEDUs*nEDUs_byLevel/sum(nEDUs_byLevel));
%sum(nEDUs_byLevel__Corrected)

%levelMBs./nEDUs_byLevel__Corrected




for cLevel=1:nConnLevels
    for jj = 1:size(zoneList{cLevel},2)
        singleZone = zoneList{cLevel}{jj};
        lengthZone = size(singleZone,1);
        
        nZoneEDUs = round(nEDUs_byLevel__Corrected(cLevel)*lengthZone/levelMBs(cLevel));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %deployCentroid;    %#See v1
        %deploySeqList;     %#See v1
        deploySeqListMean;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
end





for i=1:nNets,
    %viscircles([networks(i).Ap(1), networks(i).Ap(2)],networks(i).R,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1));
    %cLegends = [cLegends networks(i).name];
    graphCircle = circle2(networks(i).Ap(1), networks(i).Ap(2),networks(i).R);
    %set(h,'LineStyle',':','LineWidth',1,'Color',color(mod(i,nC)+1),'DisplayName',networks(i).name);
    set(graphCircle,'LineStyle',':','LineWidth',1.5,'EdgeColor',color(mod(i,nC)+1));
end

legend(cLegends);