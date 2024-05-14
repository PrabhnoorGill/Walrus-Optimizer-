clear all
clc

populationSize = 50;
Max_iteration = 100;
runs = 50;
num_functions = 30;
evaluations_per_run = 60000;

mean_fitness_matrix = zeros(runs, num_functions);

for fn = 1:num_functions
    Function_name = strcat('F', num2str(fn));
    [lb, ub, dim, fobj] = CEC2014(Function_name);
    Best_score_T = zeros(1, runs);

    for run = 1:runs
        rng('shuffle');
        [Best_score, ~, ~] = womaa(populationSize, Max_iteration, lb, ub, dim, fobj);
        Best_score_T(run) = Best_score;
    end

    mean_fitness_matrix(:, fn) = Best_score_T;
end

% Now mean_fitness_matrix stores the mean fitness values for each function after each run
% You can calculate the mean fitness across all runs for each function if needed.
mean_fitness_across_runs = mean(mean_fitness_matrix);
disp('Mean fitness across all runs for each function:');
disp(mean_fitness_across_runs);
