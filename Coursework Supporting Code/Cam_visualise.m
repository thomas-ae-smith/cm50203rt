function h = Cam_visualise( cam, opt )

hflag = ishold;
hold on;


p = [cam.focus; cam.focus+cam.nrm*cam.flen];
q = [cam.right; cam.up ];
d = [cam.width*q
     cam.width*[-1 0; 0 1]*q
    -cam.width*q;
    cam.width*[1 0; 0 -1]*q 
    ];
  
%  q = [cam.right*cam.width(1); cam.up*cam.width(2) ];
%  q(1,:)+q(2,:)

  
d = d + repmat( cam.focus + cam.nrm*cam.flen, 4,1);
h(1) = plot3( p(1,1), p(1,2), p(1,3), 'b*' ); % focus
h(2) = plot3( p(2,1), p(2,2), p(2,3), 'bo' ); % coi
h(3) = plot3( p(:,1), p(:,2), p(:,3), 'b' );  % line from f to c
h(4) = quiver3( p(2,1),p(2,2),p(2,3), q(1,1),q(1,2),q(1,3), 0, 'b' );
h(5) = quiver3( p(2,1),p(2,2),p(2,3), q(2,1),q(2,2),q(2,3), 0, 'b' );
h(6) = patch( d(:,1), d(:,2), d(:,3), 'c' );
e = [d(1,:); d(2,:); p(1,:) ];
h(7) = patch( e(:,1), e(:,2), e(:,3), 'c' );
e = [d(2,:); d(3,:); p(1,:) ];
h(8) = patch( e(:,1), e(:,2), e(:,3), 'c' );
e = [d(3,:); d(4,:); p(1,:) ];
h(9) = patch( e(:,1), e(:,2), e(:,3), 'c' );
e = [d(4,:); d(1,:); p(1,:) ];
h(10) = patch( e(:,1), e(:,2), e(:,3), 'c' );
set( h(6:10), 'FaceAlpha', 0.25, 'EdgeColor', 'c' );

if nargin == 2
  C = cam.K; % [cam.K [0;0;0]; [0 0 0 1]]; % cam.proj *[ cam.K [0;0;0]; [0 0 0 1]];
  if opt~=0
    i = 1:cam.Npix(2); % pixel locations corresponding to x
    j = 1:cam.Npix(1); % pixel locations corresponding to y
    [y,x] = meshgrid( i,j );
    p = [ x(:) y(:) ];
    p(:,3) = 1;
    p = p*inv(cam.K);
    p = p ./ repmat( p(:,3),1,3 );
    p(:,3) = cam.flen;
    p(:,4) = 1;
    p = p*inv(cam.M);
    p = p ./ repmat( p(:,4),1,4 );
    h(11) = plot3( p(:,1), p(:,2), p(:,3), 'b+', 'MarkerSize', 4 );
  end
end

return;

