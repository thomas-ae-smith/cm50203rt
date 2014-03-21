function cam = Cam_canonical( N, w )

%% cam = Cam_canonical( N, w )
% Make a canonical camera.
% The focus at the origin,
% The window the xy plane with centre of interest at [0,0,1]
% The right vector [1 0 0] and up [0 1 0].
% The camera has N(2) pixels in the "vertical" direction and
% N(1) pixels in the "horizontal" direction.
% The window is of corresponding physical width w(2) and w(1).
% If N has length 1 then both directions are taken to have the same number
% of pixels. If w is missing, width is assumed to be 1.

if length(N) == 1
  N = [N N];
end
if nargin ==1
  w = [1 1]; % width of a square window
end


cam.Npix =  N; % number of pixels (size of frame buffer)
cam.width = w/2; % half width

pixelwidth = (2*cam.width)./cam.Npix;

a = 0*pi/180;
cam.focus = [0 0 0]; % focal point
cam.right = uvec([cos(a) -sin(a) 0]); % vector to right in window
cam.up =    uvec([sin(a) cos(a) 0 ]); % vector upwards in window
cam.nrm = uvec(cross( cam.right, cam.up )); % normal to window
cam.flen = 1; % deistance from focus to window
cam.coi = cam.focus+cam.nrm*cam.flen; % centre of window

% distance between pixels (samples)
dx = 2*cam.width ./ cam.Npix;

% make the camera project from world space (x,y,z) to frame buffer (j,i)
cam.M = [
  cam.right 0;
  cam.up    0;
  cam.nrm   0
 -cam.focus   1];
cam.P = [
  1 0 0 0
  0 1 0 0
  0 0 0 1/cam.flen
  0 0 0 0];
cam.K = [
  1/dx(1) 0 0
  0 -1/dx(2) 0
  (N(1)+1)/2 (N(2)+1)/2 1 ];





% a single projection matrix
cam.proj = cam.M * cam.P * [[cam.K(1:2,:) [0;0]]; [0 0 0 0]; [cam.K(3,:) 1]];

return;

