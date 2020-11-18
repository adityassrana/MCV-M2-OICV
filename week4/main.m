% https://dpaste.com/C59GW49SC - an iterative (?) approach

%% Markov Random Fields Implementation
% MRF implementation for binary segmentation of images with noise.
%clearvars
image=double(imread('phantom18.bmp'));

figure(1)
imshow(image,[])

% In order to get the unary term, we suppose a gaussian distribution for 
% the pixel values inside a class. They are whitish or blackish.
% sigma and mu of the two gaussian distributions are computed from an
% initial clustering using kmeans.

% initial labeling
class_number=2;
X=kmeans(double(image(:)),class_number);
[nrows,ncols] = size(image);
labelMatrix = reshape(X,nrows,ncols);
%% Energy function
alpha = 0.1;
En = unaryTerm(image, labelMatrix,class_number);
Ep = pairwiseTerm(labelMatrix, class_number);
E = En + Ep*alpha;

%% Solve the Markov Random field
%Y = image(:);
%X = MRF_solver(Y, E, class_number)