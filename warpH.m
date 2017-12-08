function warp_im = warpH(im, H, out_size,fill_value)
% warpH projective image warping
%   warp_im=warpA(im, A, out_size)
%   Warps a size (w,h,channels) image im using the  (3,3) homography H
%   producing an (out_size(1),out_size(2)) output image warp_im




if ~exist('fill_value', 'var') || isempty(fill_value)
    fill_value = 0;
end

tform = maketform( 'affine', H'); 
warp_im = imtransform( im, tform, 'bilinear', 'XData', [1 out_size(2)], 'YData', [1 out_size(1)], 'Size', out_size(1:2), 'FillValues', fill_value*ones(size(im,3),1));
