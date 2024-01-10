offset = 50; %minimum distance from a Access Point (AP) to an edge of the monitoring area

xMax = max([x1,x2,x3,x4]);
xMin = min([x1,x2,x3,x4]);
yMax = max([y1,y2,y3,y4]);
yMin = min([y1,y2,y3,y4]);

for i=1:size(nNets,2)
    for j=1:nNets(i)
        st = xMin+offset; sp = xMax-offset; qtt = 1;
        sx = (sp-st).*rand(qtt,1) + st;
        APx = sx;
        
        st = yMin+offset; sp = yMax-offset; qtt = 1;
        sy = (sp-st).*rand(qtt,1) + st;
        APy = sy;
        
        APi = [APx, APy];
        networks = [networks; [i APi]];
    end
end

