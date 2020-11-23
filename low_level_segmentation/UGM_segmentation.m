clear all;
close all;
clc;

im_name='2_1_s.bmp';

% TODO: Update library path
% Add  library paths
basedir='../UGM/';
addpath(basedir);


    
%Set model parameters
%cluster color
K=3; % Number of color clusters (=number of states of hidden variables)

%Pair-wise parameters
smooth_term=[0.0 7]; % Potts Model

%Load images
im = imread(im_name);

[nRows, nCols, nChannels] = size(im);

%Convert to LAB colors space
% TODO: Uncomment if you want to work in the LAB space
%
im = RGB2Lab(im);

% TODO: define the unary energy term: data_term
% nodePot = P( color at pixel 'x' | Cluster color 'c' )  

%Preparing data for GMM fiting
im = double(im);
x = reshape(im, [nRows*nCols,nChannels]);
gmm_color = gmdistribution.fit(x,K);
mu_color = gmm_color.mu;

% Estimate unary potentials
data_term = gmm_color.posterior(x);
[~,c] = max(data_term,[],2);

% nodePot=[];
nodePot = data_term;

%Building 4-grid
%Build UGM Model for 4-connected segmentation
disp('create UGM model');

% Create UGM data
[edgePot,edgeStruct] = CreateGridUGMModel(nRows, nCols, K ,smooth_term);


if ~isempty(edgePot)

    % color clustering
    [~,c] = max(reshape(data_term,[nRows*nCols K]),[],2);
    im_c= reshape(mu_color(c,:),size(im));
    
    % Call different UGM inference algorithms
    display('Loopy Belief Propagation'); tic;
    [nodeBelLBP,edgeBelLBP,logZLBP] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct);toc;
    [~,c] = max(nodeBelLBP,[],2);
    im_lbp = reshape(mu_color(c,:),size(im));
    toc;
    
    % Max-sum
    display('Max-sum'); tic;
    maxSumDecoding = UGM_Decode_LBP(nodePot,edgePot,edgeStruct);
    im_bp= reshape(mu_color(maxSumDecoding,:),size(im));
    toc;
    
    
    % TODO: apply other inference algorithms and compare their performance
    
    % Viterbi
    display('Viterbi'); tic;
    viterbiDecoding = UGM_Decode_Chain(nodePot,edgePot,edgeStruct);
    im_v= reshape(mu_color(viterbiDecoding,:),size(im));
    toc;
    
    % Iterated Conditional Modes (ICM)
    display('Iterated Conditional Modes (ICM)'); tic;
    ICMDecoding = UGM_Decode_ICM(nodePot,edgePot,edgeStruct);
    im_icm= reshape(mu_color(ICMDecoding,:),size(im));
    toc;
    
    % Graph Cuts --> Too slow
    % Greedy Local Search Decoding --> Too slow
    
    display('Gibbs'); tic;
    burnIn = 1000;
    edgeStruct.maxIter = 1000;
    gibbsDecoding = UGM_Decode_Sample(nodePot, edgePot, edgeStruct,@UGM_Sample_Gibbs,burnIn);
    im_g= reshape(mu_color(gibbsDecoding,:),size(im));
    toc;
    
    % ICM with Restarts
    display('ICM with Restarts'); tic;
    ICMrestartDecoding = UGM_Decode_ICMrestart(nodePot,edgePot,edgeStruct,500);
    im_icmr= reshape(mu_color(ICMrestartDecoding,:),size(im));
    toc;
    
    % Mandatory
    figure(1)
    subplot(2,2,1),imshow(Lab2RGB(im));xlabel('Original');
    subplot(2,2,2),imshow(Lab2RGB(im_c),[]);xlabel('Clustering without GM');
    subplot(2,2,3),imshow(Lab2RGB(im_bp),[]);xlabel('Max-Sum');
    subplot(2,2,4),imshow(Lab2RGB(im_lbp),[]);xlabel('Loopy Belief Propagation');
    
    % Optionals
    figure(2)
    subplot(2,2,1),imshow(Lab2RGB(im_v),[]);xlabel('Viterbi');
    subplot(2,2,2),imshow(Lab2RGB(im_icm),[]);xlabel('Iterated Conditional Modes (ICM)');
    subplot(2,2,3),imshow(Lab2RGB(im_g),[]);xlabel('Gibbs');
    subplot(2,2,4),imshow(Lab2RGB(im_icmr),[]);xlabel('ICM with Restarts');
    
else
   
    error('You have to implement the CreateGridUGMModel.m function');

end