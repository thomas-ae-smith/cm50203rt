function n = Brep_nrm( obj )

for i =1:size(obj.tri,1)
  q = obj.p( obj.tri(i,:), 1:3 );
  n(i,:) = cross( q(3,:)-q(1,:), q(1,:)-q(2,:) );
  n(i,:)= n(i,:) / sqrt( n(i,:)*n(i,:)' );
end

