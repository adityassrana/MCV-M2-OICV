clearvars;

mask_src = double(imread('fcb_src_mask.png'));
mask_dst = double(imread('fcb_dst_mask.png'));

mask_src = logical(mask_src(:,:,1));
mask_dst = logical(mask_dst(:,:,1));

disp(size(nonzeros(mask_src)))
disp(size(nonzeros(mask_dst)))

imshow(mask_src)

imwrite(mask_src(:,:,1),'fcb_src_mask.png')
imwrite(mask_dst(:,:,1),'fcb_dst_mask.png')