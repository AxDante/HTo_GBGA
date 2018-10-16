function y=GBGA_MutatePos(x,mu, gscidx, ggcidx)

    nVar=numel(x);
    nmu=ceil(mu*nVar);
    %toSwap=randsample(nVar,nmu);
    
    for swapidx = 1 : nmu
        ones = find(x);
        canStart = false;
        while (~canStart)
            randidx1=randsample(numel(ones),1);
            if (randidx1 ~= gscidx && randidx1 ~= ggcidx)
                 canStart = true;
             end
        end
        canSwap = false;
        while (~canSwap)
             randidx2=randsample(nVar,1);
             if (randidx2 ~= randidx1 && randidx2 ~= gscidx && randidx2 ~= ggcidx)
                 canSwap = true;
             end
        end
        y = x;
        y(randidx1) = x(randidx2);
        y(randidx2) = x(randidx1);
        
    end
end