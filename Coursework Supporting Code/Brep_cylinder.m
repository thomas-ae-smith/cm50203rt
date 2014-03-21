function obj = Brep_cylinder( N, z1,z2 )

% obj = Brep_cylinder( N, z1,z2 )
% make a B-rep model of an (open) cylinder with N points around
% one rim.
% If z1 and z2 are given, then one rim is at z1 the other at z2.
% otherwise z1 = 0, z2 = 1 is set by default.

if nargin == 1
  z1 = 0;
  z2 = 1;
end

obj.Npnt = 2*N;
obj.Nface = 0;

% 3D object points
da = 360/N;
a = [0:da:(360-da)]* (pi/180);
obj.x = [ cos(a)' sin(a)' ];
obj.x(:,3) = z1;
obj.x(:,4) = 1;
obj.x = [obj.x; obj.x];
obj.x( (N+1):end,3) = z2;

% points that store the moved object
obj.p = obj.x;

% points to render in 2D with
obj.q = obj.p;

% join points to make triangles
obj.tri = [];
for i = 1:(N-1);
  obj.tri(end+1,:) = [i , i+1, i+N ];
  obj.tri(end+1,:) = [i+1, i+N+1, i+N];
end
i = N;
obj.tri(end+1,:) = [ i, 1, i+N ];
obj.tri(end+1,:) = [ 1, i+1, i+N ];

obj.Nface = size(obj.tri,1);

return;
