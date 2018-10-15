function idx = GBGA_getGridIndex(pos, gs)
    idx = (pos(2)-1)*gs(1) + pos(1);
end