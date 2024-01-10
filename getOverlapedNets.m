function [overlapedNets] = getOverlapedNets(networks,paramNets,MB_row,MB_col,x1,y1,w,h,M,N,beta)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

overlapedNets = [];

if( exist('x1')&&exist('y1')&&exist('w')&&exist('h')&&exist('M')&&exist('N')&&exist('beta')  )
    mIndex = MB_col;
    nIndex = MB_row;

    cosBeta = cos(beta);
    sinBeta = sin(beta);

    x1s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
    y1s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
    x2s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex-1)*(h/N)*sinBeta;
    y2s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex-1)*(h/N)*cosBeta;
    x3s = x1 + (mIndex-1)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
    y3s = y1 + (mIndex-1)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;
    x4s = x1 + (mIndex)*(w/M)*cosBeta + (nIndex)*(h/N)*sinBeta;
    y4s = y1 + (mIndex)*(w/M)*sinBeta - (nIndex)*(h/N)*cosBeta;

    xc = x1s + (x4s-x1s)/2
    yc = y1s + (y4s-y1s)/2
else
    yc = MB_col;
    xc = MB_row;
end

for i=1:size(networks,1),
            %if a MB is within a network, add the connLevel of this network
            [in, dist] = isWithinNet( xc, yc, networks(i,:), paramNets(networks(i,1)).R );
        
        
            if( in ),
                overlapedNets = [overlapedNets i];
            end
        end
end

