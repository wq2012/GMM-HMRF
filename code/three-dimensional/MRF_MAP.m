function [X, sum_U] = MRF_MAP(X, Y, GMM, k, g, MAP_iter, beta, show_plot)
% MRF_MAP   Maximum A Posteriori (MAP) estimation for 3D MRF labels
%
%   [X, sum_U] = MRF_MAP(X, Y, GMM, k, g, MAP_iter, beta, show_plot)
%
%   Inputs:
%       X           - Initial 3D labels (m x n x p matrix)
%       Y           - 3D volume (m x n x p matrix)
%       GMM         - Gaussian Mixture Model parameters (cell array)
%       k           - Number of label classes
%       g           - Number of GMM components per class
%       MAP_iter    - Maximum number of iterations
%       beta        - Weight for pairwise potential (MRF smoothing)
%       show_plot   - (Optional) 1 to show energy plot, 0 otherwise
%
%   Outputs:
%       X           - Updated 3D labels
%       sum_U       - Final energy value
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    if nargin < 8
        show_plot = 0;
    end

    [m, n, p_dim] = size(Y);
    x = X(:);
    y = Y(:); % For 3D, Y is essentially intensity scaling? 
              % Original 3D code: yi=y-mu. y was Y(:).
              % Wait, original 3D MRF_MAP had yi=y-mu; temp1=yi.*yi/Sigma/2;
              % This implies Y is a scalar field (intensity volume), not vector field?
              % Let's check original 3D MRF_MAP.
              
    % Original 3D logic:
    % y=Y(:);
    % ...
    % yi=y-mu; 
    % temp1=yi.*yi/Sigma/2;
    % So Y is 3D array of SCALARS.
    
    sum_U_MAP = zeros(1, MAP_iter);

    % Precompute neighbor validity mask for vectorization (3D)
    % Kernel for 6-connectivity (Up, Down, Left, Right, Front, Back)
    kernel = zeros(3, 3, 3);
    kernel(2, 2, 1) = 1; kernel(2, 2, 3) = 1; % Front/Back (z-dim)
    kernel(2, 1, 2) = 1; kernel(2, 3, 2) = 1; % Left/Right (cols)
    kernel(1, 2, 2) = 1; kernel(3, 2, 2) = 1; % Top/Bottom (rows)
    
    Count_Valid = convn(ones(m, n, p_dim), kernel, 'same');

    for it = 1:MAP_iter
        if show_plot
            fprintf('  Inner iteration: %d\n', it);
        end
        
        U1 = zeros(m*n*p_dim, k);
        U2 = zeros(m*n*p_dim, k);
        
        for l = 1:k
            for c = 1:g
                mu = GMM{l}.mu(c); % mu is scalar for 3D intensity?
                Sigma = GMM{l}.Sigma(1, 1, c); % Sigma is scalar variance?
                % Note: In original code GMM{l}.Sigma is likely 1x1xc or similar. 
                % Original: Sigma=GMM{l}.Sigma(:,:,c);
                
                p = GMM{l}.ComponentProportion(c);
                
                % Unary potential
                yi = y - mu;
                temp1 = (yi .* yi) / Sigma / 2;
                temp1 = temp1 + log(sqrt(abs(Sigma))); % abs for safety
                U1(:, l) = U1(:, l) + temp1 * p;
            end
            
            % Pairwise potential - Vectorized
            M = (X == l);
            Count_L = convn(double(M), kernel, 'same');
            u2_vec = (Count_Valid(:) - Count_L(:)) / 2;
            U2(:, l) = u2_vec;
        end
        
        U = U1 + U2 * beta;
        
        [min_U, new_x] = min(U, [], 2);
        sum_U_MAP(it) = sum(min_U);
        
        if it >= 3 && std(sum_U_MAP(it-2:it)) < 0.01
             X = reshape(new_x, m, n, p_dim);
             break;
        end
        
        X = reshape(new_x, m, n, p_dim);
        x = new_x;
    end
    
    sum_U = sum_U_MAP(it);
    
    if show_plot
        figure;
        plot(1:it, sum_U_MAP(1:it), 'r');
        title('Sum U MAP');
        xlabel('MAP iteration');
        ylabel('Energy');
        drawnow;
    end
end
