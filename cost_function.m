function [v] = cost_function(u)
    % Define your cost function bellow,
    % the algorithm tries to find its minimum.
    %
    % u the input vector is a (pop_per_group x cost_func_dim) vector
    % Each row represents a data
    
    v = sum(u.^2, 2);
end

