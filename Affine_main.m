% Moving Object 
clear all;
 image2=double(imread('temp1.jpg')); % read 2nd frame
video=VideoReader('vtest.avi');
for n=1:20
  tic
image1=double(rgb2gray(readFrame(video))); % read 1st frame
% image2=double(rgb2gray(readFrame(video))); % read 1st frame
image1=imresize(image1,0.5);
image2=imresize(image2,0.5);
% I=readFrame(video);
% function [moving_image] = SubtractDominantMotion(image1, image2)

    % Compute the transofmration matrix M relating an image pair It and
    % It1.
    
    
    M = LucasKanadeAffine(image1, image2)
  n
    % Warp It using M so that it is registered to It1, and subtract it from
    % It1.
    ItWarp = medfilt2(warpH(image1,M,[size(image2,1) size(image2,2)]));
    
    deltaI = image2 - ItWarp;
    
    % The locations where the absolute difference exceeds an arbitrary
    % hysteresis threshold can then be declared as corresponding to
    % locations of moving objects.
    deltaI = abs(deltaI)/255;
%     deltaI=im2bw(deltaI);
   
%     se1 = strel('disk',6);
%     se2 = strel('line',4,90);
%     deltaI = imdilate(deltaI,[se2 se2]);
%      deltaI= bwareaopen(deltaI,500);
%     [deltaI L] = bwlabel(deltaI,8);
%     s  = regionprops(deltaI, 'centroid','area','BoundingBox');
%     L
    imshow(deltaI)
%     for i=1:L
%     if s(i).Area>1500
%     centroids = cat(1, s.Centroid);
%     BB=s.BoundingBox;
%           plot(centroids(:,1), centroids(:,2), 'b*')
%     hold off
%     end
%     end
toc
end