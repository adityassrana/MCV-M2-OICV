clearvars;
dst = double(imread('rainbow_dst.png'));
src = double(imread('rainbow_src.png'));
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;

mask_src=logical(imread('rainbow_src_mask.png'));
mask_dst=logical(imread('rainbow_dst_mask.png'));

%flag to use mixing gradients
mixing_gradients = 1;

output_filename = 'rainbow_fusion.png';

for nC = 1: nChannels
    
    drivingGrad_i = G1_DiBwd(src(:,:,nC), param.hi) - G1_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = G1_DjBwd(src(:,:,nC), param.hj) - G1_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(dst(:,:,1)));

    if mixing_gradients
        
        % --- start optional: mixing gradients
    
        drivingGrad_i_dst = G1_DiBwd(dst(:,:,nC), param.hi) - G1_DiFwd(dst(:,:,nC), param.hi);
        drivingGrad_j_dst = G1_DjBwd(dst(:,:,nC), param.hj) - G1_DjFwd(dst(:,:,nC), param.hj);
        driving_on_dst_aux = drivingGrad_i_dst + drivingGrad_j_dst;
        
        driving_mix = cat(3, driving_on_src(mask_src(:)), driving_on_dst_aux(mask_dst(:)));
        [~, idx] = max(abs(driving_mix), [], 3);
        
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:)).*(idx==1) + driving_on_dst_aux(mask_dst(:)).*(idx==2);
        
        % --- end optional: mixing gradients
    else
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    end
        
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G1_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end

imshow(dst1/256)
% imwrite(dst1/256, output_filename)