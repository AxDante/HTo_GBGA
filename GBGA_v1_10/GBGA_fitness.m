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
    
end