% Test script for Color Image Segmentation using GMM-HMRF
% This script verifies the basic functionality of HMRF_EM and helper functions.

function test_color_image()
    fprintf('Running Color Image Segmentation Tests...\n');
    
    addpath(pwd);
    if is_octave()
        try
            pkg load statistics;
            pkg load image;
        catch
            warning('Packages (statistics/image) not found or failed to load.');
        end
    end
    
    % Try to compile mex files if they don't exist
    if exist('BoundMirrorExpand', 'file') ~= 3
        try
            mex BoundMirrorExpand.cpp;
        catch
            warning('Could not compile BoundMirrorExpand.cpp. Using slightly slower matlab code if available or failing.');
        end
    end
    if exist('BoundMirrorShrink', 'file') ~= 3
        try
            mex BoundMirrorShrink.cpp;
        catch
             warning('Could not compile BoundMirrorShrink.cpp.');
        end
    end

    %% Test Helper: ind2ij
    fprintf('  Test: ind2ij... ');
    try
        [i, j] = ind2ij(5, 3); % 3 rows. ind 5 -> col 2, row 2? 3*1+2 = 5.
        % ind2ij code: i=mod(ind-1,m)+1; j=floor((ind-1)/m)+1;
        % ind=5, m=3: 4%3+1 = 2. floor(4/3)+1 = 2. Correct.
        assert(i == 2);
        assert(j == 2);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end

    %% Test Helper: gaussianBlur
    fprintf('  Test: gaussianBlur... ');
    try
        img = zeros(10, 10);
        img(5, 5) = 1;
        blurred = gaussianBlur(img, 1);
        % Check peak is still roughly at 5,5 and spread out
        assert(blurred(5, 5) < 1); 
        assert(blurred(5, 5) > 0);
        assert(blurred(4, 5) > 0);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end

    %% Test Core: image_kmeans and HMRF_EM
    % 1. Create a small synthetic image
    width = 10;
    height = 10;
    Y = zeros(height, width, 3);
    
    % Region 1: Red-ish
    Y(1:5, 1:5, 1) = 200;
    Y(1:5, 1:5, 2) = 10;
    Y(1:5, 1:5, 3) = 10;
    
    % Region 2: Blue-ish
    Y(6:10, 6:10, 1) = 10;
    Y(6:10, 6:10, 2) = 10;
    Y(6:10, 6:10, 3) = 200;
    
    % Add some noise
    Y = Y + randn(size(Y))*5;
    
    k = 2; % Number of regions
    g = 2; % Number of GMM components
    beta = 1;
    EM_iter = 5;
    MAP_iter = 5;
    
    fprintf('  Test: image_kmeans... ');
    try
        [X, GMM] = image_kmeans(Y, k, g);
        assert(all(size(X) == [height, width]));
        assert(length(GMM) == k);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end
    
    fprintf('  Test: HMRF_EM... ');
    try
        [X_out, GMM_out] = HMRF_EM(X, Y, GMM, k, g, EM_iter, MAP_iter, beta);
        assert(all(size(X_out) == [height, width]));
        assert(length(GMM_out) == k);
        fprintf('PASSED\n');
    catch ME
        fprintf('FAILED\n');
        disp(ME.message);
        exit(1);
    end
    
    fprintf('All Color Image Tests Passed.\n');
end

test_color_image();
