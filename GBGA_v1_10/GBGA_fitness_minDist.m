function minDist=GBGA_fitness_minDist(x, gs, gscidx, ggcidx, obsmap)
    
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
             posi = GBGA_getGridPos(ones(i), gs);
             posj = GBGA_getGridPos(ones(j), gs);
             
             reached = false;
             posc = posi;
             distot = 0;
             while(~reached)
                 posdif = posj-posc;
                 if (posdif(1) == 0 && posdif(2) == 0)
                     reached = true;
                     break
                 end
                 if abs(posdif(1)) > abs(posdif(2))
                    if posdif(1) > 0
                        posc = posc + [1 0];
                    else
                        posc = posc + [-1 0];
                    end
                 else 
                    if posdif(2) > 0
                        posc = posc + [0 1];
                    else
                        posc = posc + [0 -1];
                    end
                 end 
                 if obsmap(posc(1),posc(2)) == 1
                    distot = distot + 30;
                 else
                     distot = distot;
                 end
             end
             
             Distable(ones(i), ones(j)) = distot + norm(posi-posj);
         end
    end
    
    for i = 1: size(Perm,1)
        dissum = 0;
        gprev = gscidx;
        for j = 1:size(Perm,2)
            gnext = cptarr(Perm(i,j));
            dissum = dissum + Distable(gprev, gnext);
            if dissum > minDist
                return
            end
            gprev = cptarr(Perm(i,j));
        end
        gnext = ggcidx;
        dissum = dissum + Distable(gprev, gnext);
        if dissum < minDist
            minDist = dissum;
        end
    end
end