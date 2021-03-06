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

clc;
clear;
close all;


gs = [7 7];
gsc = [1 1];
ggc = [7 7];
cpts = 4;
Shapes = [2 4];
scount  = numel(Shapes);

obsCount = 0;

%% Problem Definition

CostFunction=@(x) GBGA_fitness(x, gs);     % Cost Function

nVar= gs(1)*gs(2);            % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

%% GA Parameters

MaxIt= 100;	% Maximum Number of Iterations
nPop=200;	% Population Size

pc=0;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (also Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants
mu=0.1;                % Mutation Rate


ANSWER=questdlg('Choose selection method:','Genetic Algorith',...
    'Roulette Wheel','Tournament','Random','Roulette Wheel');

UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel');
UseTournamentSelection=strcmp(ANSWER,'Tournament');
UseRandomSelection=strcmp(ANSWER,'Random');

if UseRouletteWheelSelection
    beta=8;         % Selection Pressure
end

if UseTournamentSelection
    TournamentSize=3;   % Tournamnet Size
end

pause(0.01); % Needed due to a bug in older versions of MATLAB

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);

gscidx = GBGA_getGridIndex(gsc,gs);
ggcidx = GBGA_getGridIndex(ggc,gs);

for i=1:nPop
   % Initialize Position
   
   pop(i).Position=zeros(1, nVar);
   
   pop(i).Position(:,gscidx) = 1;
   pop(i).Position(:,ggcidx) = 1;
   
   cptidx = cpts;
   rnd = randi(scount, [1, cpts]);
   while (cptidx ~= 0)
       asspos =randi(nVar);
       if (asspos ~= gscidx && asspos ~= ggcidx && pop(i).Position(:,asspos) == 0)
           pop(i).Position(:,asspos) = Shapes(rnd(cptidx));
           cptidx = cptidx - 1;
       end
   end
   
   %disp(pop(i).Position)
   %disp('------')
   % Evaluation
   pop(i).Cost=CostFunction(pop(i).Position);

end

    
% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;

%% Main Loop

for it=1:MaxIt
    
    % Calculate Selection Probabilities
    if UseRouletteWheelSelection
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);
    end
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        if UseRouletteWheelSelection
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        if UseTournamentSelection
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
        end
        if UseRandomSelection
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Perform Crossover
        [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
        % Evaluate Offsprings
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Perform Mutation
        
        if (rand() < 1)
            popm(k).Position=GBGA_MutateNearbyPos(p.Position,mu,gscidx,ggcidx,gs);
        else
            popm(k).Position=GBGA_MutatePos(p.Position,mu,gscidx,ggcidx);
        end
        % Evaluate Mutant
        popm(k).Cost=CostFunction(popm(k).Position);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

%% Results
%disp( BestSol.Position);
 
    
%{
ones = find(BestSol.Position);
for i = 1: numel(ones)
    posi = GBGA_getGridPos(ones(i), gs);
end
%}
vec2mat(BestSol.Position,gs(1))

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');
grid on;
