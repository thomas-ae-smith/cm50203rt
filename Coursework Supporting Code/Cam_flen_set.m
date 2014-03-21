function cam = Cam_flen_set( cam, flen )

cam.flen = flen;
cam.P = [
  1 0 0 0
  0 1 0 0
  0 0 0 1/flen
  0 0 0 0];

cam.proj = cam.M * cam.P * [cam.K [0;0;0]; [0 0 0 1]];

return;
