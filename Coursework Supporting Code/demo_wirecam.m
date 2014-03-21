%% A demo of various camera locations around a cylinder

clear all;
close all;

%% modelling
% make a model of an object
obj = Brep_cylinder( 10, 0, 1);
% make a camera
cam = Cam_canonical( 8 );

%% Rendering
% project the object
obj = CamObj_project( cam, obj );

%% visualise current state
figure
% make a picture of the 3D situation
subplot( 2,1,1);
[hc,ho] = demo_wirecam_visual( cam, obj );
% make a picture of the projection
axis equal;
subplot(2,1,2);
hi = Brep_wireframe( obj );
set(hi,'color','k');
axis equal;



%% Animation
% move the camera backwards - the object appears to move forwards!
A = Trns_shift( [0 0 -4] );
cam = Cam_move( cam,  A );

%% Rendering
% project the object
obj = CamObj_project( cam, obj );

%% visualise current state
figure
% make a picture of the 3D situation
subplot( 2,1,1);
[hc,ho] = demo_wirecam_visual( cam, obj );
% make a picture of the projection
axis equal;
subplot(2,1,2);
hi = Brep_wireframe( obj );
set(hi,'color','k');
axis equal;


%% change focal length
cam = Cam_flen_set( cam, 3 );

%% Rendering
% project the object
obj = CamObj_project( cam, obj );

%% visualise current state
figure
% make a picture of the 3D situation
subplot( 2,1,1);
[hc,ho] = demo_wirecam_visual( cam, obj );
% make a picture of the projection
axis equal;
subplot(2,1,2);
hi = Brep_wireframe( obj );
set(hi,'color','k');
axis equal;

return;

