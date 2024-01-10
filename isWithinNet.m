function [in, d] = isWithinNet(x,y,network,R)

    xn = network(1,2);
    yn = network(1,3);
    
    d = sqrt((x-xn)^2 + (y-yn)^2);
    
    if( d <= R )
        in = 1;
    else
        in = 0;
    end
    
end

