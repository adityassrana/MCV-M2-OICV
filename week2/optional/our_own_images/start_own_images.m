clearvars;
dst = double(imread('ufo_dst.jpg'));
src = double(imread('ufo_src.jpg'));
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;

mask_src=logical(imread('ufo_src_mask.png'));
mask_dst=logical(imread('ufo_dst_mask.png'));

if (size(mask_src,3) == 3) 
  mask_src=mask_src(:,:,1); 
end

if (size(mask_dst,3) == 3) 
  mask_dst=mask_dst(:,:,1); 
 end

output_filename = 'ufo_fusion.png';

for nC = 1: nChannels
    
    drivingGrad_i = G1_DiBwd(src(:,:,nC), param.hi) - G1_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = G1_DjBwd(src(:,:,nC), param.hj) - G1_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(dst(:,:,1)));
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G1_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end

imshow(dst1/256)
% imwrite(dst1/256, output_filename)
