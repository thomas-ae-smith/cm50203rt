function [hc,ho,hi] = demo_wirecam_visual( cam, obj, opt )

if nargin == 2
  opt = 1;
end

% visualise world space
quiver3( 0,0,0,1,0,0, 'k' );
quiver3( 0,0,0,0,1,0, 'k' );
quiver3( 0,0,0,0,0,1, 'k' );
text( 1,0,0, 'x', 'FontSize', 14);
text( 0,1,0, 'y', 'FontSize', 14);
text( 0,0,1, 'z', 'FontSize', 14);


% visualise the camera
hc = Cam_visualise( cam,opt );
p = cam.focus+cam.nrm*cam.flen+cam.right;
text( p(1),p(2),p(3), 'right', 'FontSize', 14 );
p = cam.focus+cam.nrm*cam.flen+cam.up;
text( p(1),p(2),p(3), 'up', 'FontSize', 14 );

% visualise the object
ho = Brep_wireframe3D( obj );
set(ho, 'color', 'r');

% % % visualise the image
% hi = Brep_wireframe( obj );
% set(hi,'color','g');

