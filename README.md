# Face-Reconstruction-using-PCA
Principal Component Analysis (PCA) is a technique used in data analysis and machine learning to reduce the dimensionality of a dataset while retaining as much information as possible. Commonly used for visualization purposes while dealing with high-dimensional data, it transforms a dataset with a large number of features into smaller set of new features, called principal components which are linear combinations of the original features.  

Brief Overview of Working of PCA: 

Step 1: Before applying PCA, it is important to normalize the features to have mean 0 and variance 1. This ensures that features with larger scales don’t dominate the analysis.  

Step 2: PCA calculates the covariance matrix of the normalized data. The covariance matrix represents the relationships between different features, capturing how they vary together.  

Step 3: The next step involves eigenvalue decomposition (EVD) of the covariance matrix. This process yields eigenvectors and eigenvalues. The eigenvectors represent the directions (axes) of maximum variance in the data, and the eigenvalues indicate the magnitude of variance along these directions. The sum of all the eigenvalues is equal to the total variance. The singular value decomposition (SVD) is a generalization of the EVD to arbitrary rectangular matrices, is applied directly to the matrix, which doesn’t have to be standardized but it has to at least be centered. This results in a set of positive singular values that are proportional to the square roots of the eigenvalues of the covariance matrix.  

Step 4: After this the principal components are chosen. The eigenvectors are ranked based on their corresponding eigenvalues, with higher eigenvalues indicating more important directions in the data. PCA selects the top k eigenvectors (principal components) that capture most of the variance in the data.  

Step 5 (projection for data reduction): Finally, PCA projects the original data onto the selected principal components. Each data point is transformed into a new coordinate system defined by these components. This transformation reduces the dimensionality of the data while preserving the most significant information. 

Step 6: Reconstruction (verification). 

Case Description:
The objective of this case is to implement a MATLAB script for image reconstruction using PCA (Principal Component Analysis). PCA is a dimensionality reduction technique commonly used in image processing and computer vision tasks. We have a dataset of facial images from the AT&T Database of Faces. Each image in the dataset is represented as a grayscale image with dimensions 112x92 pixels. The goal is to perform PCA on this dataset, visualize eigenfaces, and demonstrate the reconstruction of a specific facial image using a subset of principal components. 
