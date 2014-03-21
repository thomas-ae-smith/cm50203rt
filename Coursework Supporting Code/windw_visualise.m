function hwndw = windw_visualise( cam )

% h = windw_visualise( cam )
% visualise the window in the camera
% !!! INCOMPLETE - should return graphics handles in hwndw but returns [];

hwndw = [];

% origin
q = [0 0 1]*inv(cam.K);
q = q/q(3);
plot( q(1),q(2),'k.');
% pixel corners
i = 1:cam.Npix(1); % pixel locations corresponding to x
j = 1:cam.Npix(2); % pixel locations corresponding to y
[x,y] = meshgrid( i,j );
p = [ x(:) y(:) ];
p(:,3) = 1; % locate them at homogeneous depth = 1
p = p*inv(cam.K); % map from fbuff to window coords
p = p(:,1:2) ./ repmat(p(:,3),1,2); % homogeneous division
plot( p(:,1), p(:,2), 'ko' );
% vertical grid lines needs points on the abscissa
p = [[0:cam.Npix(1)]' 0*ones(cam.Npix(1)+1,1) ones(cam.Npix(1)+1,1)];
q = [[0:cam.Npix(1)]' cam.Npix(2)*ones(cam.Npix(1)+1,1) ones(cam.Npix(1)+1,1)];
p = p*inv(cam.K); % map from fbuff to window coords
p = p(:,1:2) ./ repmat(p(:,3),1,2); % homogeneous division
q = q*inv(cam.K);
q = q(:,1:2) ./ repmat(q(:,3),1,2); % homogeneous division
plot( [p(:,1) q(:,1)]', [p(:,2) q(:,2)]', 'k' );


% horizontal grid lines needs points on the ordinate
p = [0*ones(cam.Npix(2)+1,1)  [0:cam.Npix(2)]' ones(cam.Npix(2)+1,1)];
q = [cam.Npix(1)*ones(cam.Npix(2)+1,1)  [0:cam.Npix(2)]' ones(cam.Npix(2)+1,1)];
p = p*inv(cam.K); % map from fbuff to window coords
p = p(:,1:2) ./ repmat(p(:,3),1,2); % homogeneous division
q = q*inv(cam.K);
q = q(:,1:2) ./ repmat(q(:,3),1,2); % homogeneous division
plot( [p(:,1) q(:,1)]', [p(:,2) q(:,2)]', 'k' );
% pixel centres
i = 1:cam.Npix(2); % pixel locations corresponding to x
j = 1:cam.Npix(1); % pixel locations corresponding to y
p = [x(:) y(:)] - 0.5; % shift
p(:,3) = 1; % locate them at homogeneous depth = 1
p = p*inv(cam.K); % map from fbuff to window coords
p = p(:,1:2) ./ repmat(p(:,3),1,2); % homogeneous division
plot( p(:,1), p(:,2), 'k+' );
plot( 0,0,'ro');