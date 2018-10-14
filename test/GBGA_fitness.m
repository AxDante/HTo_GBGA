function f = GBGA_fitness(x)
    f =  100 * (x(1)^2 - x(2)) ^2 + (1 - x(1))^2;
end