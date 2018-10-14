function y=GBGA_MutatePos(x,mu)

    goodMutate = false;
    
    while (~goodMutate)
        nVar=numel(x);

        nmu=ceil(mu*nVar);
        if mod(nmu, 2) ~= 0
            nmu = nmu + 1;
        end

        j=randsample(nVar,nmu);

        y=x;
        y(j)=1-x(j);
        
        ones_x = numel(find(x));
        ones_y = numel(find(y));
        if mod(ones_x - ones_y, 2) == 0
            goodMutate = true;
        end
    
    end
end