% Test script for 3D Volume Segmentation using GMM-HMRF
% This script verifies the basic functionality of 3D segmentation.

function test_3d()
    fprintf('Running 3D Volume Segmentation Tests...\n');
    
    addpath(pwd);
    if is_octave()
        try
            pkg load statistics;
        catch
            warning('Statistics package not found/loaded.');
        end
    end

    %% Test Helper: ind2ijq (3D index conversion)
    fprintf('  Test: ind2ijq... ');
    try
        % m=2, n=2. ind 1->(1,1,1), 2->(2,1,1), 3->(1,2,1), 4->(2,2,1), 5->(1,1,2)
        [i, j, q] = ind2ijq(5, 2, 2);
        assert(i == 1);
        assert(j == 1);
        assert(q == 2);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end
    
    %% Test Core: image_kmeans and HMRF_EM
    % 1. Create a small synthetic 3D volume
    height = 10;
    width = 10;
    depth = 5;
    Y = zeros(height, width, depth);
    
    % Region 1: High intensity
    Y(1:5, 1:5, 1:3) = 200;
    
    % Region 2: Low intensity
    Y(6:10, 6:10, 3:5) = 50;
    
    % Add noise
    Y = Y + randn(size(Y))*5;
    
    k = 2; % Number of regions
    g = 2; % Number of GMM components
    beta = 1;
    EM_iter = 5;
    MAP_iter = 5;
    
    fprintf('  Test: image_kmeans (3D adapter)... ');
    try
        [X, GMM] = image_kmeans(Y, k, g);
        assert(isequal(size(X), size(Y)));
        assert(length(GMM) == k);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        rethrow(ME);
    end
    
    fprintf('  Test: HMRF_EM (3D)... ');
    try
        [X_out, GMM_out] = HMRF_EM(X, Y, GMM, k, g, EM_iter, MAP_iter, beta);
        assert(isequal(size(X_out), size(Y)));
        assert(length(GMM_out) == k);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end
    
    fprintf('All 3D Volume Tests Passed.\n');
end

test_3d();
