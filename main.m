clear all
clc
populationSize = 50; 
Max_iteration = 100;
runs = 50;

for fn =30


    Function_name=strcat('F',num2str(fn));
    [lb,ub,dim,fobj]=CEC2014(Function_name);
    Best_score_T = zeros(1,runs);
    for run=1:runs
        rng('shuffle');
        [Best_score,Best_pos,WOA_curve]=womaa(populationSize,Max_iteration,lb,ub,dim,fobj);
        Best_score_T(1,run) = Best_score;
    end
    Best_score_Best = min(Best_score_T);
    Best_score_Worst = max(Best_score_T);
    Best_score_Median = median(Best_score_T,2);
    Best_Score_Mean = mean(Best_score_T,2);
    Best_Score_std = std(Best_score_T);
    display(['Fn = ', num2str(fn)]);
    display(['Best, Worst, Median, Mean, and Std. are as: ', num2str(Best_score_Best),'  ', ...
    num2str(Best_score_Worst),'  ', num2str(Best_score_Median),'  ', num2str(Best_Score_Mean),'  ', num2str(Best_Score_std)]);



    display(['The best solution obtained by WOA for ' [num2str(Function_name)],'  is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by WOA  for ' [num2str(Function_name)],'  is : ', num2str(Best_score)]);

figure('Position', [500 400 700 290])
semilogy(WOA_curve, 'Color', 'r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
       
end