
%__________________________________________________________________ %
%                          Multi-Objective                          %
%                Multi-objective Artificial Vultures                %
%                    Optimization Algorithm (MOAVOA)                %
%                                                                   %
%                                                                   %
%                  Developed in MATLAB R2022a (MacOs)               %
%                                                                   %
%                      Author and programmer                        %
%                ---------------------------------                  %
%                      Nima Khodadadi (ʘ‿ʘ)                        %
%                             e-Mail                                %
%                ---------------------------------                  %
%                         nkhod002@fiu.edu                          %
%                                                                   %
%                            Homepage                               %
%                ---------------------------------                  %
%                    https://nimakhodadadi.com                      %
%                                                                   %
%                                                                   %
%                                                                   %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %




function [Archive_F]=MOAVOA(max_iter,Archive_size,pop_size,obj_no,method,m)



if method==3

    TestProblem=sprintf('P%d',m);

    fobj= Ptest(TestProblem);

    xrange  = xboundaryP(TestProblem);
    variables_no=max(size(xrange));
  
    lower_bound=xrange(:,1)';
    upper_bound=xrange(:,2)';

end
%

% Repository Size

Alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
Beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2;
X=CreateEmptyParticle(pop_size);
current_vulture_X=CreateEmptyParticle(pop_size);
Best_vulture1_X=CreateEmptyParticle(pop_size);
Best_vulture2_X=CreateEmptyParticle(pop_size);
for i=1:pop_size
    current_vulture_X(i,:).Position=zeros(1,variables_no);
    Best_vulture1_X(i,:).Position=zeros(1,variables_no);
    Best_vulture2_X(i,:).Position=zeros(1,variables_no);
    current_vulture_X(i,:).Cost=zeros(1,obj_no);
    Best_vulture1_X(i,:).Cost=inf(1,obj_no);
    Best_vulture2_X(i,:).Cost=inf(1,obj_no);
    current_vulture_X(i,:).Velocity=0;
    X(i,:).Velocity=0;
    X(i,:).Position=zeros(1,variables_no);


    current_vulture_X(i,:).Best.Position=current_vulture_X(i,:).Position;
    X(i,:).Best.Position=X(i,:).Position;
    current_vulture_X(i,:).Best.Cost=X(i,:).Cost;
    X(i,:).Best.Cost=X(i,:).Cost;
    X(i,:).Position=initialization(1,variables_no,upper_bound,lower_bound);
    X(i,:).Cost=fobj(X(i,:).Position');


end


X=DetermineDominations(X);
Archive=GetNonDominatedParticles(X);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,Alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end


%%  Controlling parameter
p1=0.6;
p2=0.4;
p3=0.6;
alpha=0.8;
betha=0.2;
Gamma=2.5;

%%Main loop

for current_iter=1: max_iter
    Leader=SelectLeader(Archive,Beta);

    a=unifrnd(-2,2,1,1)*((sin((pi/2)*(current_iter/max_iter))^Gamma)+cos((pi/2)*(current_iter/max_iter))-1);
    P1=(2*rand+1)*(1-(current_iter/max_iter))+a;

    % Update the location
    for i=1:pop_size
        current_vulture_X(i).Position = X(i).Position;  % pick the current vulture back to the population
        F=P1*(2*rand()-1);

        random_vulture_X(i).Position=random_select(current_vulture_X(i).Position, Leader.Position,alpha,betha);

        if abs(F) >= 1 % Exploration:
            current_vulture_X(i).Position = exploration(current_vulture_X(i).Position,random_vulture_X(i).Position, F, p1, upper_bound, lower_bound);
        elseif abs(F) < 1 % Exploitation:
            current_vulture_X(i).Position= exploitation(current_vulture_X(i).Position,  random_vulture_X(i).Position,Leader.Position, random_vulture_X(i).Position, F, p2, p3, variables_no, upper_bound, lower_bound);
        end

        current_vulture_X(i).Position= boundaryCheck( current_vulture_X(i).Position, lower_bound, upper_bound);

        current_vulture_X(i).Cost=fobj(current_vulture_X(i).Position');

    end

    current_vulture_X(i).Position= boundaryCheck( current_vulture_X(i).Position, lower_bound, upper_bound);

    current_vulture_X(i).Cost=fobj(current_vulture_X(i).Position');


    current_vulture_X=DetermineDominations(current_vulture_X);
    non_dominated_current_vulture_X=GetNonDominatedParticles(current_vulture_X);

    Archive=[Archive
        non_dominated_current_vulture_X];

    Archive=DetermineDominations(Archive);
    Archive=GetNonDominatedParticles(Archive);


    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end

    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);

        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,Alpha);

    end

    disp(['In iteration ' num2str(current_iter) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results

    % Results

    Archive_F=GetCosts(Archive);
end
end
