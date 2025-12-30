function [X, GMM] = HMRF_EM(X, Y, GMM, k, g, EM_iter, MAP_iter, beta)
% HMRF_EM   Expectation Maximization for HMRF segmentation (3D)
%
%   [X, GMM] = HMRF_EM(X, Y, GMM, k, g, EM_iter, MAP_iter, beta)
%
%   Inputs:
%       X           - Initial 3D labels
%       Y           - 3D volume data
%       GMM         - Initial GMM parameters
%       k           - Number of classes
%       g           - Number of GMM components
%       EM_iter     - Max EM iterations
%       MAP_iter    - Max MAP iterations per EM step
%       beta        - MRF weight parameter
%
%   Outputs:
%       X           - Final 3D labels
%       GMM         - Updated GMM parameters
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

%   This function performs the EM algorithm to iteratively improve the
%   segmentation (labels X) and the GMM parameters for 3D volumes.

    sum_U = zeros(1, EM_iter);

    for it = 1:EM_iter
        fprintf('Iteration: %d\n', it);
        
        % Update X (MAP Estimator)
        [X, sum_U(it)] = MRF_MAP(X, Y, GMM, k, g, MAP_iter, beta, 0);

        % Update GMM parameters
        GMM = get_GMM(X, Y, g);
        
        % Check convergence
        if it >= 3 && std(sum_U(it-2:it)) < 0.01
            break;
        end
    end
    
    % Visualize Energy
    figure;
    plot(1:it, sum_U(1:it), 'LineWidth', 2);
    hold on;
    plot(1:it, sum_U(1:it), '.', 'MarkerSize', 20);
    title('Sum of U in each EM iteration');
    xlabel('EM iteration');
    ylabel('Sum of U');
    grid on;

    % Note: 3D Visualization of X is not trivial using imagesc.
    % The user can use other tools to visualize the volume X.
end
