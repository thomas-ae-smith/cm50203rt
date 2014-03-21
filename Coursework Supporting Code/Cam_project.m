function y = Cam_project( x, cam )

y = x * cam.proj;
y = y ./ repmat( y(:,4), 1, 4 );

return;
