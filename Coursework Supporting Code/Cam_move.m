function cam = Cam_move( cam, A )

x = [cam.focus 1]*A;
cam.focus = x(1:3)/x(4);

cam.right = [cam.right ]*A(1:3,1:3);
cam.up = [cam.up ]*A(1:3,1:3);
cam.nrm = [cam.nrm   ]*A(1:3,1:3);
cam.coi = cam.focus + cam.nrm*cam.flen;
% all that is really needed is to move the camera matrix
cam.M = inv(A)*cam.M;

cam.proj = cam.M * cam.P * [cam.K [0;0;0]; [0 0 0 1]];

return;

