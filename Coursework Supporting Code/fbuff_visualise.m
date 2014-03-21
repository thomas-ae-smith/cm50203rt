function h = fbuff_visualise( cam )

% h = fbuff_visualise( cam )
% visualise the frame buffer in the camera

i = 1:cam.Npix(2); % pixel locations corresponding to x
j = 1:cam.Npix(1); % pixel locations corresponding to y
[y,x] = meshgrid( i,j );
h{1} = plot( 0,0,'k.'); % the origin
h{2} = plot( x,y, 'ko' );
g = [];
for k = 0:length(j)
  g(end+1) = plot( [k k], [0 cam.Npix(2)], 'k' );
end
h{3} = g';
g = [];
for k = 0:length(i)
  g(end+1) = plot( [0 cam.Npix(1)], [k k],  'k' );
end
h{4} = g';
g = [];
for k = 1:length(j)
  g(end+1) = text( j(k),-1, sprintf('%d', j(k)) );
end
h{5} = g';
g = [];
for k = 1:length(i)
  g(end+1) = text( -1,i(k),sprintf('%d', i(k)) );
end
h{6} = g';
h{7} = plot( x-0.5,y-0.5, 'k+' );