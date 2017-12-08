
%%  Lucas-Kanade Affine


function [M] = LucasKanadeAffine(It, It1)
    
    [m, n] = size(It);
    [X, Y] = meshgrid(1:n, 1:m);
    X = X(:);
    Y = Y(:);

       count = 0;
    p = zeros(6,1);
    % The affine matrix for template rotation and translation
    W_xp = [ 1+p(1) p(3) p(5); p(2) 1+p(4) p(6); 0 0 1];
    
     % 1: Warp I with W(x;p) to compute I(W(x;p))
    I_warped = affine_transform_2d_double(I,x,y,W_xp);
    
    
    [Ix, Iy] = gradient(It);
    deltaI = It1 - It;

 

    while(count < 10)
        count = count + 1;
        Ix = Ix(:);
        Iy = Iy(:);
        deltaI = deltaI(:);

        % Compute the steepest descent images. 
        A = [X.*Ix Y.*Ix Ix X.*Iy Y.*Iy Iy]; 

        % Compute the optimized solution for the minimization
        % which yields the change in position.
        deltaP = -(A'*A)\A'*deltaI;

        % Update the warp points. 
        p = p + deltaP;
        
        % Conclude that the change in position is below some arbitrary
        % threshold.
        if (norm(deltaP) < 0.0001)
            break
        end
        
        % Compute the affine matrix for the warp.
        M = [1+p(1)   p(2)    p(3); 
             p(4)     1+p(5)  p(6); 
             0        0       1];

        % Warp the next image to the current template.
        ItWarp = medfilt2(warpH(It,M,[size(It1,1) size(It1,2)]));

        % Find the error image - difference between the next frame
        % warped to the image and the template itself.
        deltaI = (It1 - ItWarp);
        [Ix, Iy] = gradient(ItWarp, 1/n, 1/m);
        

    end
end
