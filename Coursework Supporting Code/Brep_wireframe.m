function h = Brep_wireframe( obj )

% h = Brep_wireframe( obj )
% Plot a wireframe image of an object

holdflag = ishold;

p = obj.q;
tri = obj.tri;

hold on;
for i = 1:size(tri,1)
  q = p( tri(i,:), : );
  q(end+1,:) = q(1,:);
  h(i) = plot3( q(:,1), q(:,2), q(:,3), 'k-');
end

if holdflag==0
  hold off;
end
