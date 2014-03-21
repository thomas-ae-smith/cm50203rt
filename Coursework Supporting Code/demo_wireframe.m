%% A camera model

clear all;
close all;

% make a model of an object
N = 10;
obj = Brep_cylinder( N, 1, 3);

figure
axis equal;
hold on;
Brep_wireframe( obj );
title('the model object');
% turn the perspective on

% make a model of a camera
C = [
  1 0 0 0
  0 1 0 0
  0 0 1 1
  0 0 0 0
  ];



%% Use MATLAB to render the model
% as a wireframe
% project
p = obj.p *C;
p = p ./ repmat( p(:,4),1,4 );
tri = obj.tri;
figure
hold on;
axis equal
plot3( p(:,1), p(:,2), p(:,3), 'k.');
for i = 1:size(tri,1)
  q = p( tri(i,:), : );
  q(end+1,:) = q(1,:);
  plot3( q(:,1), q(:,2), q(:,3), 'k-');
end
title('wireframe under C');


%% A different camera
f = 10;
K = [
  1 0 0 0
  0 1 0 0
  0 0 1 0
  0 0 0 1/f];

C*K

M = [
  1 0 0 0
  0 1 0 0
  0 0 1 0
  0 0 -10 1];
M = inv(M);

%% Use MATLAB to render the model
% as a wireframe
% project
p = obj.p *(M*C*K);
p = p ./ repmat( p(:,4),1,4 );
tri = obj.tri;
figure
hold on;
axis equal
plot3( p(:,1), p(:,2), p(:,3), 'k.');
for i = 1:size(tri,1)
  q = p( tri(i,:), : );
  q(end+1,:) = q(1,:);
  plot3( q(:,1), q(:,2), q(:,3), 'k-');
end
title('wireframe under (M*C*K)');
