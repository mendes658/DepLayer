%function p = placeSensors(mb_classes)

%%%

kPercen = 20;           % Max percentage of possible dpconn loss
searchSide = 100;        % Size(blocks) of the sides of the "Search square" 
                        % around a max DpConn block, to help finding 
                        % the ideal area coverage
maxOverLeapRatio = 12;  % Max percentage of overleaped blocks in a sensor's area
outOfBoundsWeight = 9;  % Weight of out of bounds blocks, higher = sensors are going to be placed
                        % inside the city square more often

%%%

sensorType1 = struct('id', 1, 'r', 250, 'qtt', 140); % 1 250 140

totalByLevel = [0,0,0];
totalArea = 0;

% Print MBs heatmap
% for mIndex=1:wMBs
%    for nIndex=1:hMBs
%         status = MBs(nIndex,mIndex);
%         gLevel = 0;
%         if (status > 1)
%             status = 1;
%             gLevel = (status - 1) * 2;
%         end
% 
%         x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
%         y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
%         hold on
%         rectangle('Position',[x3s y3s ws hs], 'FaceColor', [status,gLevel,0,status], 'EdgeColor', [status,gLevel,0, status]);
%     end
% end


%% Print zonesByDivision
% for i=1 : exZonesH+1
%     for j = 1: exZonesW+1
%         %zns = zonesByDivision{i, j};
%         zns = zonesByDivAndLevel{3}{i, j};
%         [dd,sz] = size(zns);
% 
%         for k=1 :sz
%             zn = zns(k);
% 
%             mIndex = zn.m;
%             nIndex = zn.n;
% 
%             x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
%             y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
% 
%             if (mod(i,2) == 0 && mod(j,2) ~=0 || mod(i,2) ~= 0 && mod(j,2) ==0)
%                 rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'FaceColor', 'black');
%                 hold on
%             else 
%                 rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'FaceColor', 'cyan');
%                 hold on
%             end
%         end
%     end
% end

%%% matrix where 0 = outside sensor radius and 1 = inside sensor radius
sensorsAreas = zeros(hMBs, wMBs);

%%% matrix with double the radius of each sensor area
usedAreasMap = zeros(hMBs,wMBs);

testMap = zeros(hMBs, wMBs);
                                 
copyMBs_classes = MBs_classes;
nowMaxConn = nConnLevels; % max connectivity level in the area

lastQtt = 0; % checks the last quantity of sensors, in order not to get... 
             %... in infinite loops
lastMax = 0;
sensorOverflow = 0;

% going through the zones and placing sensors

while (sensorType1.qtt > 0)
    if (sensorType1.qtt == lastQtt)
        nowMaxConn = nowMaxConn - 1;
    end
    
    if (nowMaxConn == 0)
        break;
    end

    lastQtt = sensorType1.qtt;

    for m = 1 : exZonesH+1

        for p = 1: exZonesW+1
            %zns = zonesByDivision{i, j};
            zns = zonesByDivAndLevel{nowMaxConn}{m, p};

            [dd,sz] = size(zns);
            
            maxConn = -1;
            maxConnM = 0;
            maxConnN = 0;

            % Finding the highest DPConn within the area
            for k=1 : sz
                zn = zns(k);
                mIndex = zn.m;
                nIndex = zn.n;

                if (MBs(nIndex, mIndex) > maxConn && sensorType1.qtt > 0 ...
                        && sensorsAreas(nIndex, mIndex) ~= 1)

                    maxConnM = mIndex;
                    maxConnN = nIndex;
                    maxConn = MBs(nIndex, mIndex);

                end
            end
            
            if (maxConn == -1)
                continue;
            end

            minPosConn = maxConn - (maxConn/100)*kPercen;

            firstBSearchM = maxConnM - ceil(searchSide/2);
            firstBSearchN = maxConnN - ceil(searchSide/2);        

            maxCoverageStatus = -1;
            maxNonOLBlocks = -1;
            maxSensorValue = -1;
            maxCovN = 0;
            maxCovM = 0;

            % Searching a square area around the selected block, in order to
            % maximize the coverage
            for m1=firstBSearchM : firstBSearchM + searchSide
                for n1=firstBSearchN : firstBSearchN + searchSide

                    %n1
                    %m1
                    
                    %plot(n1, m1, '.', 'Color', 'black', 'MarkerSize', 10);

                    nowCoverageStatus = 0;
                    oLeapBlocks = 0;
                    outOfBounds = 0;
                    nonOLeapBlocks = 0;
                    dpConnSum = 0;
                    mIndex = m1;
                    nIndex = n1;
                    
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
                    
                    
                    if(m1 < wMBs && n1 < hMBs && m1 > 0 && n1 > 0)
                        nowConn = MBs(n1, m1);

                        %Print search area around sensor
                        %rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5, 'FaceColor','cyan');
                        
                        if (nowConn >= minPosConn)                        

                            xcS = xc;
                            ycS = yc;
                            wsInRad = ceil(sensorType1.r / ws);
                            hsInRad = ceil(sensorType1.r / hs);
                            
                            cnt2 = 0;
                            for i = m1 : m1 + wsInRad * 2
                                cnt = 0;
                                for j = n1 : n1 + hsInRad * 2
                                    
                                    x1s = x1 + (i-1)*(w/M)*cosBeta + (j-1)*(h/N)*sinBeta;
                                    y1s = y1 + (i-1)*(w/M)*sinBeta - (j-1)*(h/N)*cosBeta;
                                    x4s = x1 + (i)*(w/M)*cosBeta + (j)*(h/N)*sinBeta;
                                    y4s = y1 + (i)*(w/M)*sinBeta - (j)*(h/N)*cosBeta;
        
                                    xc = x1s + (x4s-x1s)/2;
                                    yc = y1s + (y4s-y1s)/2;
    
                                    oLeap = 0;
                                    outCounter = 4;
    
                                    if (getDistance(xcS, ycS, xc, yc) <= sensorType1.r)
                                        if (j < hMBs && j > 0 && i < wMBs  && i > 0)

                                            if (sensorsAreas(j, i) == 1)
                                                oLeapBlocks = oLeapBlocks + 1;
                                                dpConnSum = dpConnSum + MBs_classes(n1, m1);
                                            else
                                                nonOLeapBlocks = nonOLeapBlocks + 1;
                                            end
                                        else
                                            outOfBounds = outOfBounds + 1;
                                        end
                                        
                                        %nowCoverageStatus = nowCoverageStatus + (1*noOverleapW + oLeap*overleapW);
                                        
                                        if (cnt < -1)
                                           if (j + cnt < hMBs && j + cnt > 0 && i < wMBs && i > 0)

                                                if (sensorsAreas(j + cnt, i) == 1)
                                                    oLeapBlocks = oLeapBlocks + 1;
                                                    dpConnSum = dpConnSum + MBs_classes(n1, m1);
                                                else
                                                    nonOLeapBlocks = nonOLeapBlocks + 1;
                                                end
                                           else
                                                outOfBounds = outOfBounds + 1;
                                           end
                                        end

                                        % if (j + cnt < hMBs && j + cnt > 0 && cnt < -1 && i < wMBs  && i > 0)
                                        %     outCounter = outCounter - 1;
                                        % 
                                        %     if (sensorsAreas(j + cnt, i) == 1)
                                        %         oLeapBlocks = oLeapBlocks + 1;
                                        %     else
                                        %         nonOLeapBlocks = nonOLeapBlocks + 1;
                                        %     end
                                        % 
                                        %     %nowCoverageStatus = nowCoverageStatus + (noOverleapW + oLeap*overleapW);
                                        % end
        
                                        if (cnt2 < -1)
                                            if (i + cnt2 < wMBs && i + cnt2 > 0 && j < hMBs && j > 0)

                                                if (sensorsAreas(j, i + cnt2) == 1)
                                                    oLeapBlocks = oLeapBlocks + 1;
                                                    dpConnSum = dpConnSum + MBs_classes(n1, m1);
                                                else
                                                    nonOLeapBlocks = nonOLeapBlocks + 1;
                                                end
                                            else
                                                outOfBounds = outOfBounds + 1;
                                            end
                                        end

                                        % if (i + cnt2 < wMBs && i + cnt2 > 0 && cnt2 < -1 && j < hMBs && j > 0)
                                        %     outCounter = outCounter - 1;
                                        % 
                                        %     if (sensorsAreas(j, i + cnt2) == 1)
                                        %         oLeapBlocks = oLeapBlocks + 1;
                                        %     else
                                        %         nonOLeapBlocks = nonOLeapBlocks + 1;
                                        %     end
                                        % 
                                        %     %nowCoverageStatus = nowCoverageStatus + (noOverleapW + oLeap*overleapW);
                                        % end
                                        
                                        if (cnt2 < -1)
                                            if (j + cnt < hMBs && i + cnt2 < wMBs && j + cnt > 0 && i + cnt2 > 0)
                                                    
                                                if (sensorsAreas(j + cnt, i + cnt2) == 1)
                                                    oLeapBlocks = oLeapBlocks + 1;
                                                    dpConnSum = dpConnSum + MBs_classes(n1, m1);
                                                else
                                                    nonOLeapBlocks = nonOLeapBlocks + 1;
                                                end

                                            else
                                                outOfBounds = outOfBounds + 1;
                                            end
                                        end

                                        % if (j + cnt < hMBs && i + cnt2 < wMBs && j + cnt > 0 && i + cnt2 > 0 && cnt2 < -1)
                                        %     outCounter = outCounter - 1;
                                        % 
                                        %     if (sensorsAreas(j + cnt, i + cnt2) == 1)
                                        %         oLeapBlocks = oLeapBlocks + 1;
                                        %     else
                                        %         nonOLeapBlocks = nonOLeapBlocks + 1;
                                        %     end
                                        % 
                                        %     %nowCoverageStatus = nowCoverageStatus + (noOverleapW + oLeap*overleapW);
                                        % end

                                    end
    
                                    cnt = cnt-2;
                                end
                                cnt2 = cnt2-2;
                            end
                        end
                    end
                    

                    ratioOL = (oLeapBlocks + outOfBounds) / (oLeapBlocks+nonOLeapBlocks+outOfBounds);
                    totalMbs = oLeapBlocks+nonOLeapBlocks+outOfBounds;

                    sensorValue = dpConnSum * ( oLeapBlocks - (outOfBounds/3) / totalMbs);

                    % if (ratioOL < (maxOverLeapRatio / 100))
                    % 
                    %     if (m1 == maxConnM && n1 == maxConnN)
                    %         if (nonOLeapBlocks > maxNonOLBlocks)
                    %             maxNonOLBlocks = nonOLeapBlocks;
                    %             maxCovM = m1;
                    %             maxCovN = n1;
                    %         end
                    %     end
                    % 
                    %     if (nonOLeapBlocks > maxNonOLBlocks)
                    %         maxNonOLBlocks = nonOLeapBlocks;
                    %         maxCovM = m1;
                    %         maxCovN = n1;
                    %     end
                    % 
                    % end
                    
                    if (ratioOL < (maxOverLeapRatio / 100))
                        if (m1 == maxConnM && n1 == maxConnN)
                            if (sensorValue == maxSensorValue)
                                maxSensorValue = sensorValue;
                                maxCovM = m1;
                                maxCovN = n1;
                            end
                        end
                            
                        if (sensorValue > maxSensorValue)
                            maxSensorValue = sensorValue;
                            maxCovM = m1;
                            maxCovN = n1;
    
                        end
                    end

                    % if (nowCoverageStatus > maxCoverageStatus)
                    % 
                    %     maxCoverageStatus = nowCoverageStatus;
                    %     maxCovM = m1;
                    %     maxCovN = n1;
                    % 
                    % end
                end
            end
            
            if (maxSensorValue ~= -1)
                totalByLevel(MBs_classes(maxCovN, maxCovM)) = totalByLevel(MBs_classes(maxCovN, maxCovM)) + 1;

                %Placing sensor
                x1s = x1 + (maxCovM-1)*(w/M)*cosBeta + (maxCovN-1)*(h/N)*sinBeta;
                y1s = y1 + (maxCovM-1)*(w/M)*sinBeta - (maxCovN-1)*(h/N)*cosBeta;
                x4s = x1 + (maxCovM)*(w/M)*cosBeta + (maxCovN)*(h/N)*sinBeta;
                y4s = y1 + (maxCovM)*(w/M)*sinBeta - (maxCovN)*(h/N)*cosBeta;
    
                xc = x1s + (x4s-x1s)/2;
                yc = y1s + (y4s-y1s)/2;
    
                c = circle2(xc, yc, sensorType1.r);
                set(c, 'LineStyle','-', 'EdgeColor', 'black', 'LineWidth', 3);
                hold on
    
                plot(xc, yc, '.', 'Color', 'black', 'MarkerSize', 4);
                hold on
    
                %rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'EdgeColor','b');
                hold on
                sensorType1.qtt = sensorType1.qtt - 1;
                
                xcS = xc;
                ycS = yc;
    
                cnt2 = 0;
                for i = maxCovM : maxCovM + wsInRad * 2
                    cnt = 0;
                    for j = maxCovN : maxCovN + hsInRad * 2
                        
                        x1s = x1 + (i-1)*(w/M)*cosBeta + (j-1)*(h/N)*sinBeta;
                        y1s = y1 + (i-1)*(w/M)*sinBeta - (j-1)*(h/N)*cosBeta;
                        x4s = x1 + (i)*(w/M)*cosBeta + (j)*(h/N)*sinBeta;
                        y4s = y1 + (i)*(w/M)*sinBeta - (j)*(h/N)*cosBeta;
    
                        xc = x1s + (x4s-x1s)/2;
                        yc = y1s + (y4s-y1s)/2;
    
                        oLeap = 0;
    
                        if (getDistance(xcS, ycS, xc, yc) <= sensorType1.r)
                            sensorsAreas(j, i) = 1;
    
                            if (j + cnt < hMBs && j + cnt > 0 && cnt < -1)
                                 sensorsAreas(j + cnt, i) = 1;
                            end
    
                            if (i + cnt2 < wMBs && i + cnt2 > 0 && cnt2 < -1)
                                 sensorsAreas(j, i + cnt2) = 1;
                            end
    
                            if (j + cnt < hMBs && i + cnt2 < wMBs && j + cnt > 0 && i + cnt2 > 0 && cnt2 < -1)
                                 sensorsAreas(j + cnt, i + cnt2) = 1;
                            end
                        end
    
                        cnt = cnt-2;
                    end
                    cnt2 = cnt2-2;
                end
            end

        %     for k=1 :sz
        %         zn = zns(k);
        % 
        %         mIndex = zn.m;
        %         nIndex = zn.n;
        % 
        %         x1s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
        %         y1s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
        %         x2s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
        %         y2s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
        %         x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
        %         y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
        %         x4s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
        %         y4s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
        % 
        %         xc = x1s + (x4s-x1s)/2;
        %         yc = y1s + (y4s-y1s)/2;
        % 
        %         % placing sensor circles
        %         %if (MBs_classes(nIndex, mIndex) == nowMaxConn && sensorType1.qtt > 0)
        %         %if (xc > 120 && yc > 120 && sensorType1.qtt > 0)
        %         if (sensorOverflow == 0)
        %             areasToComp = usedAreasMap;
        %         else
        %             areasToComp = sensorsAreas;
        %         end
        % 
        %         if (MBs_classes(nIndex, mIndex) == nowMaxConn && sensorType1.qtt > 0 && ...
        %                 areasToComp(nIndex, mIndex) ~= 1)
        %             xcS = xc;
        %             ycS = yc;
        % 
        %             c = circle2(xcS, ycS, sensorType1.r);
        %             set(c, 'LineStyle','-', 'EdgeColor', 'black', 'LineWidth', 3);
        %             hold on
        % 
        %             plot(xcS, ycS, '.', 'Color', 'black', 'MarkerSize', 4);
        %             hold on
        % 
        %             %rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5,'EdgeColor','b');
        %             hold on
        %             sensorType1.qtt = sensorType1.qtt - 1;
        % 
        %             wsInRad = ceil(sensorType1.r / ws);
        %             hsInRad = ceil(sensorType1.r / hs);
        %             doubleRadius = sensorType1.r * 2;
        % 
        %             cnt2 = 0;
        %             for i = mIndex : mIndex + wsInRad * 2
        %                 cnt = 0;
        %                 for j = nIndex : nIndex + hsInRad * 2
        % 
        %                     x1s = x1 + (i-1)*(w/M)*cosBeta + (j-1)*(h/N)*sinBeta;
        %                     y1s = y1 + (i-1)*(w/M)*sinBeta - (j-1)*(h/N)*cosBeta;
        %                     x4s = x1 + (i)*(w/M)*cosBeta + (j)*(h/N)*sinBeta;
        %                     y4s = y1 + (i)*(w/M)*sinBeta - (j)*(h/N)*cosBeta;
        % 
        %                     xc = x1s + (x4s-x1s)/2;
        %                     yc = y1s + (y4s-y1s)/2;
        % 
        %                     %%% Updating sensorsAreas
        %                     if (getDistance(xcS, ycS, xc, yc) <= doubleRadius)
        %                         usedAreasMap(j, i) = 1;
        % 
        %                         if (j + cnt < hMBs && j + cnt > 0 && cnt < -1)
        %                              usedAreasMap(j + cnt, i) = 1;
        %                         end
        % 
        %                         if (i + cnt2 < wMBs && i + cnt2 > 0 && cnt2 < -1)
        %                              usedAreasMap(j, i + cnt2) = 1;
        %                         end
        % 
        %                         if (j + cnt < hMBs && i + cnt2 < wMBs && j + cnt > 0 && i + cnt2 > 0 && cnt2 < -1)
        %                              usedAreasMap(j + cnt, i + cnt2) = 1;
        %                         end
        %                     end 
        % 
        %                     %%% Updating usedAreasMap
        %                     if (getDistance(xcS, ycS, xc, yc) <= sensorType1.r)
        %                         sensorsAreas(j, i) = 1;
        %                         copyMBs_classes(j, i) = -1;
        % 
        %                         if (j + cnt < hMBs && j + cnt > 0 && cnt < -1)
        %                              sensorsAreas(j + cnt, i) = 1;
        %                              copyMBs_classes(j + cnt, i) = -1;
        %                         end
        % 
        %                         if (i + cnt2 < wMBs && i + cnt2 > 0 && cnt2 < -1)
        %                              sensorsAreas(j, i + cnt2) = 1;
        %                              copyMBs_classes(j, i + cnt2) = -1;
        %                         end
        % 
        %                         if (j + cnt < hMBs && i + cnt2 < wMBs && j + cnt > 0 && i + cnt2 > 0 && cnt2 < -1)
        %                              sensorsAreas(j + cnt, i + cnt2) = 1;
        %                              copyMBs_classes(j + cnt, i + cnt2) = -1;
        %                         end
        %                     end
        % 
        %                     cnt = cnt-2;
        %                 end
        %                 cnt2 = cnt2-2;
        %             end
        % 
        %             break
        %         end
        %     end
        end
    end 
end



% Print sensorAreas
% for mIndex=1:wMBs
%    for nIndex=1:hMBs
%         status = sensorsAreas(nIndex,mIndex);
% 
%         x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
%         y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
% 
%         if (status == 1)
%             rectangle('Position',[x3s y3s ws hs],'LineWidth',0.5, 'FaceColor','cyan');
%         end
%     end
% end

%Get total coverage
totalArea = 0;

for mIndex=1:wMBs
   for nIndex=1:hMBs
        status = sensorsAreas(nIndex,mIndex);

        x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
        y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;

        if (status == 1)
            totalArea = totalArea + 1;
        end
    end
end

totalArea