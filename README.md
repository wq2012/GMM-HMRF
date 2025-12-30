# GMM-HMRF Image Segmentation Library

GMM-Based Hidden Markov Random Field (GMM-HMRF) for Color Image and 3D Volume Segmentation.

This library provides an implementation of the GMM-HMRF framework for segmenting color images and 3D volumes. It uses Gaussian Mixture Models (GMM) for modeling the intensity distributions and Hidden Markov Random Fields (HMRF) for spatial regularization.

## Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Color Image Segmentation](#color-image-segmentation)
  - [3D Volume Segmentation](#3d-volume-segmentation)
- [Code Structure](#code-structure)
- [References](#references)

## Getting Started

Clone the repository to your local machine:
```bash
git clone https://github.com/wq2012/GMM-HMRF.git
```

## Prerequisites

- **MATLAB** or **Octave**
- `statistics` package
- `image` package

To install the packages in Octave:
```matlab
pkg install -forge statistics
pkg install -forge image
```

## Testing
To run the included unit tests:
```matlab
% In code/color-image/
test_color_image

% In code/three-dimensional/
test_3d
```

## Usage

### Color Image Segmentation

Navigate to `code/color-image/`.

1. **Compile MEX files** (if not already compiled):
   The library uses C++ helper functions for boundary handling.
   ```matlab
   mex BoundMirrorExpand.cpp
   mex BoundMirrorShrink.cpp
   ```

2. **Run Demo**:
   Running `demo.m` will segment the provided sample image.
   ```matlab
   demo
   ```

3. **Use in your own code**:
   ```matlab
   % Load image
   Y = double(imread('image.jpg'));
   
   % Parameters
   k = 3;      % Number of classes
   g = 3;      % Components per GMM
   beta = 1;   % MRF smoothing factor
   
   % Initial segmentation (k-means)
   [X, GMM] = image_kmeans(Y, k, g);
   
   % Run GMM-HMRF
   [X_final, GMM_final] = HMRF_EM(X, Y, GMM, k, g, 10, 10, beta);
   
   % Display result
   imagesc(X_final);
   ```

### 3D Volume Segmentation

Navigate to `code/three-dimensional/`.

1. **Run Demo**:
   `demo.m` generates a synthetic 3D volume and segments it.
   ```matlab
   demo
   ```

## Code Structure

- **`code/color-image/`**: Contains the implementation for 2D color images.
  - `HMRF_EM.m`: Main function running the EM algorithm.
  - `MRF_MAP.m`: Maximization step (MAP estimation) using MRF.
  - `image_kmeans.m`: Initialization using K-means.
  - `demo.m`: Demonstration script.
  - `test_color_image.m`: Unit tests.
  - `is_octave.m`: Helper for environment detection.
  - `mex/`: MEX files for boundary handling.

- **`code/three-dimensional/`**: Contains the implementation for 3D volumes.
  - Similar structure to `color-image`.
  - Includes `test_3d.m` for unit testing.

## References

If you use this code, please cite:
**Quan Wang**. GMM-Based Hidden Markov Random Field for Color Image and 3D Volume Segmentation. *arXiv:1212.4527 [cs.CV]*, 2012.
[https://arxiv.org/abs/1212.4527](https://arxiv.org/abs/1212.4527)

```
@article{wang2012gmm,
  title={GMM-based hidden Markov random field for color image and 3D volume segmentation},
  author={Wang, Quan},
  journal={arXiv preprint arXiv:1212.4527},
  year={2012}
}
```