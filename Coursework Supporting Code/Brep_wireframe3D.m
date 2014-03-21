function [h,varargout] = Brep_wireframe3D( obj, opt )

% [h,hn] = Brep_wireframe3D( obj,opt )
% Plot a wireframe object in 3D and return a graphic handles h.
% If opt is given and differs from 0, the normals are drawn too; in which
% case (i) opt is taken as a scacle factor on the drawn normals and
% (ii) the graphics handles for normals, hn, are set.

% housekeeping for drawing
holdflag = ishold;
hold on;

% make syntax easy
p = obj.p;
tri = obj.tri;
for i = 1:size(tri,1)
  q = p( tri(i,:), : ); % the points
  q(end+1,:) = q(1,:);  % close the polygon
  h(i) = plot3( q(:,1), q(:,2), q(:,3), 'k-');
end

if nargin == 2
  if opt ~= 0
    n = opt*Brep_nrm( obj );
    for i = 1:size(tri,1)
      q = mean( p( tri(i,:), : ), 1 );
      hn(i) = quiver3( q(1),q(2),q(3), n(i,1),n(i,2),n(i,3),0 );
    end
    set(hn,'color','k');
    varargout{1} = hn;
  end
end

if holdflag==0
  hold off;
end
