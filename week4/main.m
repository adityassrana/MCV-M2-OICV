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

% mu and sigma for each of the classes
mu(1)=mean(image(labelMatrix==1)); 
mu(2)=mean(image(labelMatrix==2)); 
sigma(1)=std(image(labelMatrix==1));
sigma(2)=std(image(labelMatrix==2));

%% Unary term
Y = image(:);
n=size(Y,1); 
Eu=zeros(n,class_number);

for k=1:class_number
    diff_k=Y-repmat(mu(k),[n,1]);
    Eu(:,k)=sum(diff_k*inv(sigma(k)).*diff_k,2)+log(det(sigma(k)));
end

%% Pairwise term 
Nei8 = Nei(labelMatrix);
Ep=zeros(n,class_number);
for k=1:class_number 
    Ep(:,k) = sum(Nei8~=k,2);
end

%% Energy function
alpha = 0.1;%...10;
E = Eu + alpha*Ep;
%X = MRF_Solver(Y, E, class_number);





