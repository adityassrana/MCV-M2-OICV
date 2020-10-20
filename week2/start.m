clearvars;
dst = double(imread('lena.png'));
src = double(imread('girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;

%masks to exchange: Eyes
mask_src=logical(imread('mask_src_eyes.png'));
mask_dst=logical(imread('mask_dst_eyes.png'));

output_filename = 'lena_fusion.png';

for nC = 1: nChannels
    
    drivingGrad_i = G1_DiBwd(src(:,:,nC), param.hi) - G1_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = G1_DjBwd(src(:,:,nC), param.hj) - G1_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(dst(:,:,1)));
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G1_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end
 
%Mouth
%masks to exchange: Mouth
mask_src=logical(imread('mask_src_mouth.png'));
mask_dst=logical(imread('mask_dst_mouth.png'));
for nC = 1: nChannels
    
    drivingGrad_i = G1_DiBwd(src(:,:,nC), param.hi) - G1_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = G1_DjBwd(src(:,:,nC), param.hj) - G1_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j; 
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G1_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
end

imshow(dst1/256)
% imwrite(dst1/256, output_filename)