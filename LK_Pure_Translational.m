clear all;
% video=VideoReader('C:\Users\DELL\Desktop\Computer_vision\Assignment_1\vtest.avi');
%% Load images
% frame1=readFrame(video);
frame1=imread('2.jpg');

figure();
subplot 211
imshow(frame1);
img1 = im2double(rgb2gray(frame1));  % original image
% frame2=readFrame(video); 
frame2=imread('3.jpg');
subplot 212
imshow(frame2);
img2 = im2double(rgb2gray(frame2));  % template image

%% Define the template window size for Lucas-Kanade method
window = 40;
w = round(window/2);

% Reduce the size of the image
scale = 1/2;
img2_scaled = imresize(img2, scale); 

% find harrish corner
Corner1 = corner(img2_scaled);
Corner1 = Corner1*(1/scale);

% Discard coners near the margin of the image
k = 1;
for i = 1:size(Corner1,1)
    x_i = Corner1(i, 2);
    y_i = Corner1(i, 1);
    if x_i-w>=1 && y_i-w>=1 && x_i+w<=size(img1,1)-1 && y_i+w<=size(img1,2)-1
      Corner(k,:) = Corner1(i,:);
      k = k+1;
    end
end

% Plot corners on the image to get the patch for calulating optical flow
figure();
imshow(frame2);
hold on
plot(Corner(:,1), Corner(:,2), 'r*'); 

%% Implementing Lucas Kanade Method for Pure translational to calculate optical flow
% for each point, calculate I_x, I_y, I_t (calculate warp parameters W(x;p) I_x= u & I_y = v)
Ix_m = conv2(img1,[-1 1; -1 1], 'valid'); % partial derivative on x  (dI/dx) 
Iy_m = conv2(img1, [-1 -1; 1 1], 'valid'); % partial derivative on y  (dI/dy)
It_m = conv2(img1, ones(2), 'valid') + conv2(img2, -ones(2), 'valid'); % partial derivative on t (dI/dt) 

u = zeros(length(Corner),1);
v = zeros(length(Corner),1);
 
%% Warp Image with W(x;p) to compute I(W(x;p)) within window w * w 
for k = 1:length(Corner(:,2))
    i = Corner(k,2);
    j = Corner(k,1);
% withine a window of +20 & -20 from corner point location
      Ix = Ix_m(i-w:i+w, j-w:j+w);  
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);
      
      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:); % get b here
      A = [Ix Iy]; % get A here

 %%% calculate velocity component for each corner point
      nu = pinv(A)*b;  
      u(k)=nu(1);
      v(k)=nu(2);
end;

%% Draw the optical flow vectors
figure();
imshow(frame2);
hold on;
quiver(Corner(:,1), Corner(:,2), u,v, 1,'r')