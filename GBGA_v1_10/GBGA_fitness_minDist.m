function minDist=GBGA_fitness_minDist(x, gs, gscidx, ggcidx)
    
    ones = find(x);
    cptarr1 = ones(ones~=gscidx);
    cptarr = cptarr1(cptarr1~= ggcidx);
    cpts = numel(cptarr);
   
    minDist = Inf;
    Permi = perms(1:cpts);
    
    if size(Permi,1) > 25
        samps = randsample(size(Permi,1), 25)';
        Perm = Permi(samps, :);
    else
        Perm = Permi;
    end
    
    Distable = zeros(numel(x));
    for i = 1 : numel(ones)
         for j = 1 : numel(ones)
             posi =  GBGA_getGridPos(ones(i), gs);
             posj = GBGA_getGridPos(ones(j), gs);
             Distable(ones(i), ones(j)) = norm(posi-posj);
         end
    end
    
    for i = 1: size(Perm,1)
        dissum = 0;
        gprev = gscidx;
        for j = 1:size(Perm,2)
            gnext = cptarr(Perm(i,j));
            dissum = dissum + Distable(gprev, gnext);
            gprev = cptarr(Perm(i,j));
        end
        gnext = ggcidx;
        dissum = dissum + Distable(gprev, gnext);
        if dissum < minDist
            minDist = dissum;
        end
    end
    
end