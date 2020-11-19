%% Markov Random Fields Implementation
% MRF implementation for binary segmentation of images with noise.
clearvars
% image=imread('brain1.jpeg');
image=imread('beach.png');

figure(1)
imshow(image,[])

image = double(rgb2gray(image));
%image = double(image);

% In order to get the unary term, we suppose a gaussian distribution for 
% the pixel values inside a class. They are whitish or blackish.
% sigma and mu of the two gaussian distributions are computed from an
% initial clustering using kmeans.

% initial labeling
class_number=4;
%X=kmeans(image(:),class_number,'Distance', ...
%    'cityblock', 'Replicates',5);
X=kmeans(image(:),class_number);

[nrows,ncols] = size(image);
labelMatrix = reshape(X,nrows,ncols);
figure(4)
imshow(label2rgb(labelMatrix))
%% Energy function
alpha = 10; % 0.1 ... 10

iter=0;
maxIter=100;
while(iter<maxIter)
    Eu = unaryTerm(image, labelMatrix,class_number);
    Ep = pairwiseTerm(labelMatrix, class_number);
    E = Eu + Ep.*alpha;
    [~,labels]=min(E,[],2);
    labelMatrix = reshape(labels, [nrows ncols]);
    iter=iter+1;
    
    segmentation=reshape(labels,[nrows ncols]);
    figure(2);
    imshow(label2rgb(segmentation));
end
segmentation=reshape(labels,[nrows ncols]);
figure(2);
imshow(label2rgb(segmentation));
