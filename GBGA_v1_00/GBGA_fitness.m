%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA101
% Project Title: Implementation of Binary Genetic Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function sums=GBGA_fitness(x, gs)
    
    ones = find(x);
    
    sums = 0;
    for i = 1: numel(ones)
        posi = GBGA_getGridPos(ones(i), gs);
        for j = 1: numel(ones)
            if (i ~= j)
                posj = GBGA_getGridPos(ones(j), gs);
                sums = sums + GBGA_getPosDiff(posi, posj);
            end
        end
    end

    if (numel(ones) < 5)
        sums = sums +  (5-numel(ones)) * 30;
    end
    if x(1) ~= 1 || x(25) ~= 1
        sums = sums + 150;
    end
    
    z=sum(x);
end