function y=GBGA_MutateNearbyPos(x,mu, gscidx, ggcidx, gs)

    nVar=numel(x);
    nmu=ceil(mu*nVar);
    %toSwap=randsample(nVar,nmu);
    
    for swapidx = 1 : nmu
        ones = find(x);
        canStart = false;
        while (~canStart)
            randidx1 = ones(randi(numel(ones)));
            %randidx1=randsample(numel(ones),1)
            if (randidx1 ~= gscidx && randidx1 ~= ggcidx)
                 canStart = true;
             end
        end
        canSwap = false;
        while (~canSwap)
            twoColumnMatrix = vec2mat(x,gs(1));
            randdir = randi(8);
            dir = [1 0; 0 1; -1 0; 0 -1; 1 1; 1 -1; -1 1; -1 -1];
            randpos1 =  GBGA_getGridPos(randidx1,gs);
            randpos2 =  randpos1 + dir(randdir,:);
            randidx2 =  GBGA_getGridIndex(randpos2, gs);
            if (randpos2(1) > 0 && randpos2(2) > 0 && randpos2(1) <= gs(1)  && randpos2(2) <= gs(2)  && randidx2 ~= gscidx && randidx2 ~= ggcidx)
                canSwap = true;
            end
        end
        y = x;
        y(randidx1) = x(randidx2);
        y(randidx2) = x(randidx1);
        
    end
end