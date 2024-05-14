



%%% Designed and Developed by Pavel Trojovský and Mohammad Dehghani %%%


function[Best_score,Best_pos,WOA_curve]=WOA(populationSize,Max_iteration,lb,ub,dim,fobj)

lb=ones(1,dim).*(lb);                              % Lower limit for variables
ub=ones(1,dim).*(ub);                              % Upper limit for variables

%% INITIALIZATION
for i=1:dim
    X(:,i) = lb(i)+rand(populationSize,1).*(ub(i) - lb(i));                          % Initial population
end

for i =1:populationSize
    L=X(i,:);
    fit(i)=fobj(L);
end
%%

for t=1:Max_iteration
    %% update the best condidate solution
    [best , location]=min(fit);
    if t==1
        Xbest=X(location,:);                                           % Optimal location
        fbest=best;                                           % The optimization objective function
    elseif best<fbest
        fbest=best;
        Xbest=X(location,:);
    end
    
    SW=Xbest;% strongest walrus with best value for objective function
    %%
    for i=1:populationSize
        %% PHASE 1: FEEDING STRATEGY (EXPLORATION)
        I=round(1+rand(1,1));
        X_P1(i,:)=X(i,:)+rand(1,dim) .* (SW-I.*X(i,:));% Eq(3)
        X_P1(i,:) = max(X_P1(i,:),lb);X_P1(i,:) = min(X_P1(i,:),ub);
        
        % update position based on Eq (4)
        L=X_P1(i,:);
        F_P1=fobj(L);
        if(F_P1<fit(i))
            X(i,:) = X_P1(i,:);
            fit(i) = F_P1;
        end
        %% END PHASE 1: FEEDING STRATEGY (EXPLORATION)
        %%
        %% PHASE 2: MIGRATION
        I=round(1+rand(1,1));
        
        K=randperm(populationSize);K(K==i)=[];%Eq(5)
        X_K=X(K(1),:);%Eq(5)
        F_RAND=fit(K(1));%Eq(5)
        if fit(i)> F_RAND%Eq(5)
            X_P2(i,:)=X(i,:)+rand(1,1) .* (X_K-I.*X(i,:));%Eq(5)
        else
            X_P2(i,:)=X(i,:)+rand(1,1) .* (X(i,:)-X_K);%Eq(5)
        end
        
        % update position based on Eq (6)
        X_P2(i,:) = max(X_P2(i,:),lb);X_P2(i,:) = min(X_P2(i,:),ub);
        L=X_P2(i,:);
        F_P2=fobj(L);
        if(F_P2<fit(i))
            X(i,:) = X_P2(i,:);
            fit(i) = F_P2;
        end
        %% END PHASE 2: MIGRATION
        
        %%
        %% PHASE3: ESCAPING AND FIGHTING AGAINST PREDATORS (EXPLOITATION)
        LO_LOCAL=lb./t;%Eq(8)
        HI_LOCAL=ub./t;%Eq(8)
        I=round(1+rand(1,1));
        
        X_P3(i,:)=X(i,:)+LO_LOCAL+rand(1,1).*(HI_LOCAL-LO_LOCAL);% Eq(7)
        X_P3(i,:) = max(X_P3(i,:),LO_LOCAL);X_P3(i,:) = min(X_P3(i,:),HI_LOCAL);
        X_P3(i,:) = max(X_P3(i,:),lb);X_P3(i,:) = min(X_P3(i,:),ub);
        
        % update position based on Eq (9)
        L=X_P3(i,:);
        F_P3=fobj(L);
        if(F_P3<fit(i))
            X(i,:) = X_P3(i,:);
            fit(i) = F_P3;
        end
        
        %% END PHASE3: ESCAPING AND FIGHTING AGAINST PREDATORS (EXPLOITATION)
    end% i=1:populationSize
    
    best_so_far(t)=fbest;
    average(t) = mean(fit);
    
end
Best_score=fbest;
Best_pos=Xbest;
WOA_curve=best_so_far;
end

