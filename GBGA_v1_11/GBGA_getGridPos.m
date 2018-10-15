function pos = GBGA_getGridPos(i,gs)
    pos(1) = mod(i-1, gs(1))+1;
    pos(2) = floor((i-1)/gs(1))+1;
end