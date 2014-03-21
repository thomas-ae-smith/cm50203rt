function scene = scene_fscanf( fid )
% scene = scene_fscanf( fid )
% Read in scene data

Nobj = fscanf( fid, '%d' );

scene.i = [];
scene.x = [];
scene.p = [];
scene.q = [];
scene.tri = [];
scene.n = [];
scene.colour = [];
for i = 1:Nobj  
  % read a new object
  s = '';
  while isempty(s)
    s = fgetl( fid );
  end
  fidobj = fopen( s );
  obj = Brep_fscanf( fidobj );
  fclose( fidobj );
  % read a transform as a string (so can contain commands)
  s = '';
  while isempty(s)
    s = fgetl( fid );
  end
  M = eval(s);
  
  % move the object
  obj = Brep_move( obj, M );
  % compute object surface normals of MOVED object
  obj.n = Brep_nrm( obj );

  % merge it with the last
  k = size(scene.x,1);
  scene.i = [scene.i ; i*ones(size(obj.x,1),1) ];
  scene.x = [scene.x ; obj.x];
  scene.p = [scene.p ; obj.p];
  scene.q = [scene.q ; obj.q];
  scene.tri = [scene.tri ; (k+obj.tri)];
  scene.n = [scene.n ; obj.n];
  scene.colour = [scene.colour ; obj.colour];
end

% read the camera -pixels in x and y, and width in x and y
scene.camera.N = fscanf(fid,'%d',2);
scene.camera.N = scene.camera.N(:)';
scene.camera.w = fscanf(fid,'%f',2);
scene.camera.w = scene.camera.w(:)';

% now read light direction
scene.light.amb = fscanf(fid,'%f', 3 );
scene.light.amb = scene.light.amb(:)';
scene.light.u = fscanf( fid, '%f', 3 );
scene.light.u = uvec(scene.light.u);
scene.light.u = scene.light.u'; % ensure vector is a row

return;
