
%%%%%%%%%%%%%%
TYPE_OF_GRAPH = 0;   % 0 =  Sensors connectivity levels and total coverage 
                     % by max possible overleap ratio
                     % 1 = Sensors connectivity levels and total coverage 
                     % by max allowed dpconn loss
                     % 2 = Sensors connectivity levels and total coverage 
                     % by size of the sides of the "Search Square"

%%%%%%%%%%%%%%%

kPercen = 20;           % Max percentage of dpconn loss
searchSide = 100;       % Size of the sides of the "Search square" 
                        % around a max DpConn block, to help finding 
                        % the ideal area coverage
maxOverLeapRatio = 10;  % Max percentage of overleaped blocks in a sensor area

totalAreas = [];
totalLevel1 = [];
totalLevel2 = [];
totalLevel3 = [];
totalSensors = [];
chosenRatios = [];
chosenKPercens = [];
chosenSides = [];

switch(TYPE_OF_GRAPH)
    case 0
        maxOverLeapRatio = 0;
        while (maxOverLeapRatio <= 100)
            placeSensorsWoPlot;
            totalAreas = [totalAreas, totalArea];
            totalLevel1 = [totalLevel1, totalByLevel(1)];
            totalLevel2 = [totalLevel2, totalByLevel(2)];
            totalLevel3 = [totalLevel3, totalByLevel(3)];
            chosenRatios = [chosenRatios, maxOverLeapRatio];
            totalSensors = [totalSensors, totalByLevel(1) + totalByLevel(2) + totalByLevel(3)];
            maxOverLeapRatio = maxOverLeapRatio + 2;
        end
    
    case 1
        kPercen = 0;
        while (kPercen <= 99)
            placeSensorsWoPlot;

            totalAreas = [totalAreas, totalArea];
            totalLevel1 = [totalLevel1, totalByLevel(1)];
            totalLevel2 = [totalLevel2, totalByLevel(2)];
            totalLevel3 = [totalLevel3, totalByLevel(3)];

            chosenKPercens = [chosenKPercens, kPercen];

            totalSensors = [totalSensors, totalByLevel(1) + totalByLevel(2) + totalByLevel(3)];
            
            kPercen = kPercen + 3;
        end

     case 2
        searchSide = 1;
        while (searchSide <= 100)
            placeSensorsWoPlot;

            totalAreas = [totalAreas, totalArea];
            totalLevel1 = [totalLevel1, totalByLevel(1)];
            totalLevel2 = [totalLevel2, totalByLevel(2)];
            totalLevel3 = [totalLevel3, totalByLevel(3)];

            chosenSides = [chosenSides, searchSide];

            totalSensors = [totalSensors, totalByLevel(1) + totalByLevel(2) + totalByLevel(3)];
            
            searchSide = searchSide + 3;
        end
end

switch(TYPE_OF_GRAPH)
    case 0
        yyaxis left;
        plot(chosenRatios, totalAreas, 'Color', 'b');
        hold on;
        
        yyaxis right;
        
        plot(chosenRatios, totalLevel1, 'Color', 'r', 'LineStyle', '--');
        hold on;
        
        plot(chosenRatios, totalLevel2, 'Color', 'g');
        hold on;
        
        plot(chosenRatios, totalLevel3, 'Color', 'black', 'LineStyle', '--');
        hold on;
        
        plot(chosenRatios, totalSensors, 'LineStyle', ':', 'Color', [0.8,0,0.9], 'LineWidth', 2);
        hold on;
        
        legend('Total Coverage (blocks)','Sensors In ConnLevel 1', ...
            'Sensors In ConnLevel 2', 'Sensors In ConnLevel 3', 'Total Sensors')
        
        title('Sensors levels and total coverage by max possible overleap ratio')
        
        xlabel('Max overleap percentage (%)')
        
        yyaxis left;
        
        ylabel('Total coverage')
    
    case 1
        yyaxis left;
        plot(chosenKPercens, totalAreas, 'Color', 'b');
        hold on;
        
        yyaxis right;
        
        plot(chosenKPercens, totalLevel1, 'Color', 'r', 'LineStyle', '--');
        hold on;
        
        plot(chosenKPercens, totalLevel2, 'Color', 'g');
        hold on;
        
        plot(chosenKPercens, totalLevel3, 'Color', 'black', 'LineStyle', '--');
        hold on;
        
        plot(chosenKPercens, totalSensors, 'LineStyle', ':', 'Color', [0.8,0,0.9], 'LineWidth', 2);
        hold on;
        
        legend('Total Coverage (blocks)','Sensors In ConnLevel 1', ...
            'Sensors In ConnLevel 2', 'Sensors In ConnLevel 3', 'Total Sensors')
        
        title('Sensors levels and total coverage by max percentage of DPConn Loss')
        
        xlabel('Max percentage of DPConn Loss (%)')
        
        yyaxis left;
        
        ylabel('Total coverage')

     case 2
        yyaxis left;
        plot(chosenSides, totalAreas, 'Color', 'b');
        hold on;
        
        yyaxis right;
        
        plot(chosenSides, totalLevel1, 'Color', 'r', 'LineStyle', '--');
        hold on;
        
        plot(chosenSides, totalLevel2, 'Color', 'g');
        hold on;
        
        plot(chosenSides, totalLevel3, 'Color', 'black', 'LineStyle', '--');
        hold on;
        
        plot(chosenSides, totalSensors, 'LineStyle', ':', 'Color', [0.8,0,0.9], 'LineWidth', 2);
        hold on;
        
        legend('Total Coverage (blocks)','Sensors In ConnLevel 1', ...
            'Sensors In ConnLevel 2', 'Sensors In ConnLevel 3', 'Total Sensors')
        
        title('Sensors levels and total coverage by size of "Search Squares" sides')
        
        xlabel('Size of "Search Squares" sides (Blocks)')
        
        yyaxis left;
        
        ylabel('Total coverage')
end


