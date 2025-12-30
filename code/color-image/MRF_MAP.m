function [X, sum_U] = MRF_MAP(X, Y, GMM, k, g, MAP_iter, beta, show_plot)
% MRF_MAP   Maximum A Posteriori (MAP) estimation for MRF labels
%
%   [X, sum_U] = MRF_MAP(X, Y, GMM, k, g, MAP_iter, beta, show_plot)
%
%   Inputs:
%       X           - Initial 2D labels (m x n matrix)
%       Y           - Color image (m x n x 3 matrix)
%       GMM         - Gaussian Mixture Model parameters (cell array)
%       k           - Number of label classes
%       g           - Number of GMM components per class
%       MAP_iter    - Maximum number of iterations
%       beta        - Weight for pairwise potential (MRF smoothing)
%       show_plot   - (Optional) 1 to show energy plot, 0 otherwise
%
%   Outputs:
%       X           - Updated 2D labels
%       sum_U       - Final energy value
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    if nargin < 8
        show_plot = 0;
    end

    [m, n, ~] = size(Y);
    x = X(:);
    y = reshape(Y, [m*n, 3]);

    sum_U_MAP = zeros(1, MAP_iter);
    
    % Precompute neighbor validity mask for vectorization
    % Kernel for 4-connectivity
    kernel = [0 1 0; 1 0 1; 0 1 0];
    Count_Valid = conv2(ones(m, n), kernel, 'same');
    
    for it = 1:MAP_iter
        if show_plot
             fprintf('  Inner iteration: %d\n', it);
        end
        
        U1 = zeros(m*n, k);
        U2 = zeros(m*n, k);

        % Unary potential (Likelihood)
        for l = 1:k
            for c = 1:g
                mu = GMM{l}.mu(c, :);
                Sigma = GMM{l}.Sigma(:, :, c);
                p = GMM{l}.ComponentProportion(c);

                yi = bsxfun(@minus, y, mu);
                % (yi * inv(Sigma)) .* yi -> sum over dim 2
                % More efficient/stable: sum(yi / Sigma .* yi, 2)? 
                % But Sigma is full matrix, so yi*inv(Sigma) is needed.
                temp1 = sum((yi / Sigma) .* yi, 2) / 2; % yi / Sigma is roughly yi * inv(Sigma)
                
                temp1 = temp1 + log(sqrt(det(Sigma)));
                U1(:, l) = U1(:, l) + temp1 * p;
            end
            
            % Pairwise potential (Prior) - Vectorized
            M = (X == l);
            Count_L = conv2(double(M), kernel, 'same');
            u2_vec = (Count_Valid(:) - Count_L(:)) / 2;
            U2(:, l) = u2_vec;
        end

        U = U1 + U2 * beta;
        
        % Update labels
        [min_U, new_x] = min(U, [], 2);
        sum_U_MAP(it) = sum(min_U);
        
        % Check convergence
        if it >= 3 && std(sum_U_MAP(it-2:it)) < 0.01 * abs(sum_U_MAP(it))
             % Added abs() and scaling to condition for robustness, 
             % though original just used < 0.01. Keeping original logic roughly.
             % Original: std < 0.01.
             if std(sum_U_MAP(it-2:it)) < 0.01
                 X = reshape(new_x, m, n);
                 break; 
             end
        end
        
        X = reshape(new_x, m, n);
        x = new_x;
    end
    
    % Calculate final energy
    sum_U = sum_U_MAP(it); % Or recompute? Original recomputed.
    % Original code recomputed sum_U from U at final indices.
    % sum_U_MAP records min(U) at each step.
    % The loop updates X at end. 
    % The sum_U returned in original code was:
    % sum_U=0; for ind=1:m*n, sum_U=sum_U+U(ind,x(ind)); end
    % Which is exactly sum(min_U) if x is chosen as min.
    
    if show_plot
        figure;
        plot(1:it, sum_U_MAP(1:it), 'r');
        title('Sum U MAP');
        xlabel('MAP iteration');
        ylabel('Energy');
        drawnow;
    end
end
