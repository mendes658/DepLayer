
cLevel = MBs_classes(nIndex,mIndex);

countZones(cLevel) = countZones(cLevel)+1;
zoneList{cLevel}{countZones(cLevel)} = [];

nextMB = [nIndex mIndex];
stackMB(end+1,:) = nextMB;
markedMBs(nextMB(1),nextMB(2)) = cLevel;

%Mark the zone
while(~isempty(stackMB))
    n = stackMB(1,1);
    m = stackMB(1,2);
    
    %markedMBs(n, m) = 1;
    zoneList{cLevel}{countZones(cLevel)}(end+1,:) = [n m];
    
    %row - n
    %col - m
    
    %Adjancecy
    %%
    %SEQUENTIAL ORDER
    if(m+1<=M && (markedMBs(n, m+1)==0) && (MBs_classes(n, m+1)==cLevel) )
        markedMBs(n, m+1) = cLevel;
        stackMB = [stackMB; [n, m+1]];
    end
    
    if(n+1<=N && m+1<=M && (markedMBs(n+1, m+1)==0) && (MBs_classes(n+1, m+1)==cLevel) )
        markedMBs(n+1, m+1) = cLevel;
        stackMB = [stackMB; [n+1, m+1]];
    end
    
    if(n+1<=N && (markedMBs(n+1, m)==0) && (MBs_classes(n+1, m)==cLevel) )
        markedMBs(n+1, m) = cLevel;
        stackMB = [stackMB; [n+1, m]];
    end
    
    if(n+1<=N && m-1>=1 && (markedMBs(n+1, m-1)==0) && (MBs_classes(n+1, m-1)==cLevel) )
        markedMBs(n+1, m-1) = cLevel;
        stackMB = [stackMB; [n+1, m-1]];
    end
    
    if(m-1>=1 && (markedMBs(n, m-1)==0) && (MBs_classes(n, m-1)==cLevel) )
        markedMBs(n, m-1) = cLevel;
        stackMB = [stackMB; [n, m-1]];
    end
    
    if(n-1>=1 && m-1>=1 && (markedMBs(n-1, m-1)==0) && (MBs_classes(n-1, m-1)==cLevel) )
        markedMBs(n-1, m-1) = cLevel;
        stackMB = [stackMB; [n-1, m-1]];
    end
    
    if(n-1>=1 && (markedMBs(n-1, m)==0) && (MBs_classes(n-1, m)==cLevel) )
        markedMBs(n-1, m) = cLevel;
        stackMB = [stackMB; [n-1, m]];
    end
    
    if(n-1>=1 && m+1<=M && (markedMBs(n-1, m+1)==0) && (MBs_classes(n-1, m+1)==cLevel) )
        markedMBs(n-1, m+1) = cLevel;
        stackMB = [stackMB; [n-1, m+1]];
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %SMART ORDER
    % if(m+1<=M && (markedMBs(n, m+1)==0) && (MBs_classes(n, m+1)==cLevel) )
    %     markedMBs(n, m+1) = cLevel;
    %     stackMB = [stackMB; [n, m+1]];
    % end
    % 
    % if(n+1<=N && m-1>=1 && (markedMBs(n+1, m-1)==0) && (MBs_classes(n+1, m-1)==cLevel) )
    %     markedMBs(n+1, m-1) = cLevel;
    %     stackMB = [stackMB; [n+1, m-1]];
    % end
    % 
    % if(n+1<=N && (markedMBs(n+1, m)==0) && (MBs_classes(n+1, m)==cLevel) )
    %     markedMBs(n+1, m) = cLevel;
    %     stackMB = [stackMB; [n+1, m]];
    % end
    % 
    % if(n+1<=N && m+1<=M && (markedMBs(n+1, m+1)==0) && (MBs_classes(n+1, m+1)==cLevel) )
    %     markedMBs(n+1, m+1) = cLevel;
    %     stackMB = [stackMB; [n+1, m+1]];
    % end
    % 
    % if(m-1>=1 && (markedMBs(n, m-1)==0) && (MBs_classes(n, m-1)==cLevel) )
    %     markedMBs(n, m-1) = cLevel;
    %     stackMB = [stackMB; [n, m-1]];
    % end
    % 
    % if(n-1>=1 && m-1>=1 && (markedMBs(n-1, m-1)==0) && (MBs_classes(n-1, m-1)==cLevel) )
    %     markedMBs(n-1, m-1) = cLevel;
    %     stackMB = [stackMB; [n-1, m-1]];
    % end
    % 
    % if(n-1>=1 && (markedMBs(n-1, m)==0) && (MBs_classes(n-1, m)==cLevel) )
    %     markedMBs(n-1, m) = cLevel;
    %     stackMB = [stackMB; [n-1, m]];
    % end
    % 
    % if(n-1>=1 && m+1<=M && (markedMBs(n-1, m+1)==0) && (MBs_classes(n-1, m+1)==cLevel) )
    %     markedMBs(n-1, m+1) = cLevel;
    %     stackMB = [stackMB; [n-1, m+1]];
    % end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    stackMB = stackMB(2:end,:); %REMOVE FIRST
end