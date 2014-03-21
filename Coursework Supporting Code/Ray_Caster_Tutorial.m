

% Overview:
%
% In this lab, we are going to start playing with cameras, parametric
% lines, and viewing planes. This complements the coursework, and the lecture
% notes should provide enough detail for you to complete it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Set up a simple camera
%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1) Define a vector e as being an 'eye point', and define a RH coordinate system
% for it (3 unit vectors, u,v and w). Place the eye point at 0,0,0 - with the u, v
% and w coordinates along the x,y and z axis respectively.
% Code goes here:



% 2) Draw the u, v and w axis - and place a visible point at the eye
% using, e.g. plot3(ex,ey,ez,'r.');
% Code goes here:


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Draw an 'image plane'
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) OK, now let's define some sort of image plane w.r.t. this camera.
% Define top, bottom, left and right w.r.t the camera, as discussed in the
% lectures. Use any size image plane you like for now.
% Code goes here:
%


% 2) Draw the outer boundary of the image plane as a rectangle. Include the
% camera axis in this plot. Using 'hold on' after the first plot in matlab
% will allow you to stop overwriting the camera.
% Code goes here:


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3 - Move the camera and image plane.
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) OK, that's great. We now have a camera, and an image plane. 
% This is currently, in ray generation terms, a parallel projection.
% Translate the camera and image plane +10 along the w axis.
% Code goes here:



%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 4 - Generate some parallel rays
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) Now we know how to move our camera around. As you can see, if we now 
% place an object into the scene at the world origin (0,0,0), we could
% potentially generate/render different views of it w.r.t. the camera.

% Starting at the top-left image plane position, generate a parametric
% line into the world. So find the u,v for the top-left position, set t0 as
% this point, and begin moving along -w, into the scene.
% Use a reasonable increment for t, and plot the line as you increment.
% Code goes here:


% 2) Increment u by a sensible amount (although not too small right now)
% and generate a new ray
% Code goes here:


% 3) When u = r, decrement v by a sensible amount - again not to small.
% This moves you to the next row in our image plane. Now generate a new set
% of rays for this row.
% Code goes here:  


% 4) Combine 1,2 and 3 into a loop, such that rays can be generated for the
% whole image plane. Consider having the increments as parameters you can
% change, along with the top, bottom, left and right image plane positions.
% This will help somewhat when you begin to consider writing into pixel values.
% Code goes here:


% Now, you have a simple ray generator (parallel rays)! 
% Think about how this relates to the coursework.


