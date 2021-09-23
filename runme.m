% World Cup Optimization Algorithm 
% kambiz.rahbar@gmail.com, Apr 26, 2021

clc
clear
close all

%% setting parameters
max_iter = 150;

num_of_group = 6;
pop_per_group = 10;
num_play_off_teams = 3;

cost_func_dim = 2;
upper_bound = 10 * ones(pop_per_group, cost_func_dim);
lower_bound = -10 * ones(pop_per_group, cost_func_dim);

% Exploration ensures the algorithm to reach different promising regions of
% the search space, whereas exploitation ensures the searching of optimal
% solutions within the given region.
% 0 gives max exploration
% 1 give max exploitation
alpha = 0.8; % the exploitation rate

%% initialization
cost_value = zeros([num_of_group, size(upper_bound)]);
for k = 1:num_of_group
    cost_value(k,:,:) = (upper_bound - lower_bound).*rand(size(upper_bound))+lower_bound;
end

global_best_fitness = zeros(1, max_iter);
for i = 1:max_iter
    %% evaluation
    cost_fitness = zeros(num_of_group, pop_per_group);
    for k = 1:num_of_group
        group_values = reshape(cost_value(k, :, :), pop_per_group, []);
        cost_fitness(k, :) = cost_function(group_values);
    end
    
    %% rating
    [sorted_fitness, sorted_position] = sort(cost_fitness, 2, 'ascend');
    
    group_1st_best_fitness = sorted_fitness(:, 1);
    group_1st_best_position = sorted_position(:,1);
    
    group_2nd_best_fitness = sorted_fitness(:, 2);
    group_2nd_best_position = sorted_position(:,2);
    
    [global_best_fitness(i), global_best_position] = min(group_1st_best_fitness);
    global_best_value = cost_value(global_best_position,group_1st_best_position(global_best_position),:);
    global_best_value = reshape(global_best_value,1,[]);
    
    %% playoff
    [sorted_fitness_for_playoff, sorted_position_for_playoff] = sort(group_2nd_best_fitness,'ascend');
    play_off_selected_fitness = sorted_fitness_for_playoff(1:num_play_off_teams);
    play_off_selected_position = sorted_position_for_playoff(1:num_play_off_teams);
    
    %% update
    mask = boolean(ones(size(cost_value)));
    for k = 1:num_of_group
        mask(k, group_1st_best_position(k), :) = 0;
    end
    for k = 1:num_play_off_teams
        mask(play_off_selected_position(k), group_2nd_best_position(play_off_selected_position(k)), :) = 0;
    end
    
    new_cost_value = zeros([num_of_group, size(upper_bound)]);
    for k = 1:num_of_group
        new_cost_value(k,:,:) = (upper_bound - lower_bound).*rand(size(upper_bound))+lower_bound;
    end
    
    cost_value(mask) = alpha*cost_value(mask) + (1-alpha)*new_cost_value(mask);
end

%% show results
figure(1);
semilogx(global_best_fitness);
xlabel('iteration number');
ylabel('best fitness');
grid minor;
title(['Final value: ', num2str(global_best_value)]);
