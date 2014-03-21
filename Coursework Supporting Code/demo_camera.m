%% Demonstrate a camera model

clear all;
close all;

%% make a model of a camera
% the camera has N pixels per side
% note that the "horizontal size" of the camera is N(1) and/or w(1)
% and the "vertical size" is N(2) and/or w(2)
N = [16 8];  % number of pixels over 'x' and 'y' (right and up)
w = [1 1/2]; % physical width over 'x' and 'y' (right and up)
cam = Cam_canonical( N, w  );

%return;

%move the camera
if 0
  % move the camera, the various points and vectors of the camera
  % are defined in workd space so should be moved
  A = rotY( -(95)*pi/180,1 ) * rotX( 10*pi/180,1 ) * dispXYZ( [0.2 .3 1] );
  cam = Cam_move( cam, A );

  % change an internal parameter
  cam = Cam_flen_set( cam, 3 );
end


%% visualise the raw frame buffer
figure
hold on
hfbuff = fbuff_visualise( cam );
axis equal off tight ij


%% visualise the internal window points in the plane
figure
hold on;
hwndw = windw_visualise( cam );
axis equal tight


%% visualise camera in 3D, with points to show pixel centres
% This visualisation shows the camera is a RIGHT-HANDED coordinate system.
figure
hold on
hc = Cam_visualise( cam,2 );
quiver3( 0,0,0,1,0,0, 'k' );
quiver3( 0,0,0,0,1,0, 'k' );
quiver3( 0,0,0,0,0,1, 'k' );
text( 1,0,0, 'x', 'FontSize', 14);
text( 0,1,0, 'y', 'FontSize', 14);
text( 0,0,1, 'z', 'FontSize', 14);
p = cam.focus+cam.nrm*cam.flen+cam.right;
text( p(1),p(2),p(3), 'right', 'FontSize', 14 );
p = cam.focus+cam.nrm*cam.flen+cam.up;
text( p(1),p(2),p(3), 'up', 'FontSize', 14 );

view( [0 0 1] )
axis equal off xy;


% projection
x = [[0 0 1 1];
     [0 0 2 1];
     [1/4 0 1 1]
     [1/4 0 2 1]
     [1/2 0 1 1]
     ];
y = x*cam.proj;
y = y(:,1:4) ./ repmat( y(:,4),1,size(y,2) );
figure(1);
plot3( y(:,1), y(:,2), y(:,3), 'r*' );
axis tight



