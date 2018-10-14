% SWAPNIL MARATHE----inspired by travelling sales man problem

%problem statemetn:--place 'n' queens on a chess board in such a way that
%                    no queen attacks any other queen using genetic
%                    algorithm


%    i have mainly written this program for 8-queen problem but u can try for
%    other values of 'n'
%  you can try using different generations and populations

%  for cross over i have used a logic which is given in the attached PDF "crossover logic"

%  to see solution look at 'solution' matrix in workspace.


pop=1000;                                         %total population always
gen=10;                                           %total generations
n=8;
max_fitness=(((n-1)*n)/2);
initpop=zeros(pop,n);                            %initial population
pop_fitness=zeros(pop,1);                        %population fitness matrix
pop_fitness_sorted=zeros(pop,1);                 %for sorted fitness 
fitness_temp=0;                                  %fitness temporary variable used in fitness loops between k and j
actual_pop_temp=zeros(1,n);
actual_pop_sorted=zeros(pop,n);
z=0;                                             %temporary variable used for simplicity
s=1;
w=0;
solution=zeros(100,n);                           % solution matrix

cross_over_temp_mat=zeros(pop/2,n);              %cross-over variables       
cross_over_ready_pop=zeros(pop,n);
cross_over_pop_final=zeros(pop,n);

cross_over_point=0;

cross_over_pop_temp_one=zeros(1,n);
cross_over_pop_temp_two=zeros(1,n);
cross_over_pop_temp_adjust=0;

cross_over_child_two_flipped=zeros(1,n);
cross_over_child_one=zeros(1,n);
cross_over_child_two=zeros(1,n);

mutation_temp_one=0;                             %mutation variables                      
mutation_temp_two=0;
mutation_temp_data=0;
for i=1:pop
    initpop(i,:)=randperm(n);   %random initial population --indicates queen position on board
end;
actual_pop=initpop;                                 %duplication for working on this variable and keeping initial population intact

%generations loop

for q=1:gen                                         
    
    %for one generation
    
    for i = 1:pop                                   
    fitness_temp=0;
    
    %fitness calculation loop
    
    for k=1:(n-1)                                               %calculates fitness by position manipulation
        for j=k+1:n                                         %queen movements have been covered using j and k manipulation
           z=abs(actual_pop(i,k)-actual_pop(i,j));          % for example   : when one queen is at (3,1)--(row,column) 
            if (ne(z,0)&& ne(z,(j-k)))                      %                next queens cant be at {(2,2),(3,2),(4,2) } {(1,3),(3,3),(5,3)}
                 fitness_temp=fitness_temp+1;               %                now you can observe that subtraction of each queen position and next 
            end                                             %                column queen position tells us a lot of information.  
        end                                                 %                remember the actual pop contains queen position dont confuse them with 'i' & 'j'
    end
    pop_fitness(i,1)=fitness_temp;
    end
    
    %sort for individuals with good fitness
    
    pop_fitness_sorted=pop_fitness;  
    actual_pop_sorted=actual_pop;
    for i=1:(pop-1)
        for j=i+1:pop
        if(pop_fitness_sorted(i,1)<pop_fitness_sorted(j,1))
            fitness_temp=pop_fitness_sorted(i,1);
            pop_fitness_sorted(i,1)=pop_fitness_sorted(j,1);
            pop_fitness_sorted(j,1)=fitness_temp;
            
            actual_pop_temp(1,:)=actual_pop_sorted(i,:);
            actual_pop_sorted(i,:)=actual_pop_sorted(j,:);
            actual_pop_sorted(j,:)=actual_pop_temp(1,:);
        end
        end
    end
    
    
    % for unique solution gathering
    %specified a vector of 100 rows 'n' columns
    
    for i=1:pop
        if(pop_fitness_sorted(i,1)==max_fitness)
            for j=1:s
                if actual_pop_sorted(i,:)==solution(j,:)
                    w=w+1;
                else
                    w=w;
                end
            end
            if w==0
                solution(s,:)=actual_pop_sorted(i,:);
                s=s+1;
            else
                continue;
            end
        end
        w=0;
    end
    
    %selection
    
    for i=1:(pop/2)
        cross_over_temp_mat(i,:)=actual_pop_sorted(i,:);
    end
    cross_over_ready_pop=repmat(cross_over_temp_mat,2,1);
    cross_over_pop_final=cross_over_ready_pop;
    
    %cross over part begins
    %for detail explaination cross over logic refer to the pdf attached
    %logic---get random crossover point--then cross over at that point
    %if two same values of rows in one individual..then adjust crossover
    %according to the logic give in the pdf
    while 1,
        cross_over_point=floor(n*rand(1));
        if cross_over_point~=0
            break;
        end
    end
    
    
    i=1;
    while i<(pop-1),
        
        cross_over_pop_temp_one(1,:)=cross_over_ready_pop(i,:);         %copied parents
        cross_over_pop_temp_two(1,:)=cross_over_ready_pop(i+1,:);       %copied parents
        %for child one
        for j=1:cross_over_point
            for k=j:n
                if (cross_over_pop_temp_one(1,j)==cross_over_pop_temp_two(1,k))
                    cross_over_pop_temp_adjust=cross_over_pop_temp_two(1,j);
                    cross_over_pop_temp_two(1,j)=cross_over_pop_temp_two(1,k);
                    cross_over_pop_temp_two(1,k)=cross_over_pop_temp_adjust;
                    break;
                end
            end
        end
        for j=1:cross_over_point
            cross_over_child_one(1,j)=cross_over_pop_temp_one(1,j);
        end
        for j=cross_over_point:n
            cross_over_child_one(1,j)=cross_over_pop_temp_two(1,j);
        end
        
        
        %for child two
        
        cross_over_pop_temp_two(1,:)=cross_over_ready_pop(i,:);         %copied parents
        cross_over_pop_temp_one(1,:)=cross_over_ready_pop(i+1,:);       %copied parents
        
        for j=1:cross_over_point
            for k=j:n
                if (cross_over_pop_temp_one(1,j)==cross_over_pop_temp_two(1,k))
                    cross_over_pop_temp_adjust=cross_over_pop_temp_two(1,j);
                    cross_over_pop_temp_two(1,j)=cross_over_pop_temp_two(1,k);
                    cross_over_pop_temp_two(1,k)=cross_over_pop_temp_adjust;
                    break;
                end
            end
         end
        for j=1:cross_over_point
            cross_over_child_two(1,j)=cross_over_pop_temp_one(1,j);
        end
        for j=cross_over_point:n
            cross_over_child_two(1,j)=cross_over_pop_temp_two(1,j);
        end
        
         cross_over_pop_final(i,:)=cross_over_child_one(1,:);
         cross_over_child_two_flipped=wrev(cross_over_child_two);
         cross_over_pop_final(i+1,:)=cross_over_child_two_flipped(1,:);
         
         i=i+2;
    end
    

    %mutation introduced
    %mutation occours  :at every 5th individual..swapping of two random
    %                   column values(that is queen positions)        
    i=5;
    while i<pop,
        mutation_temp_one=floor(rand(1)*n/2);
        mutation_temp_two=floor(2*(rand(1)*n/2));
        if (mutation_temp_one==0 || mutation_temp_two==0)
            continue;
        else
            mutation_temp_data=cross_over_pop_final(i,mutation_temp_one);
            cross_over_pop_final(i,mutation_temp_one)=cross_over_pop_final(i,mutation_temp_two);
            cross_over_pop_final(i,mutation_temp_two)=mutation_temp_data;
        end
        i=i+5;
    end
    i=0;


    actual_pop=cross_over_pop_final;%the most important statement for my code
end

