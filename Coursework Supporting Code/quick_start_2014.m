
% Running the following file will generate a 3D scene.
% You can export this to any other format you like.
% Support for exporting to OBJ format is given at the end of the code.
% This will export all the objects in separate OBJ files.

% Load the cylinder geometry, and transform it.
cylinder = Brep_fscanf(fopen('cylinder.brep'));
s = 'Trns_xrot(  1.5708 )*Trns_shift( [-1 1 -1] )';
M = eval(s);
cylinder.p = cylinder.p*M;

% Load the cube, as above.
cube = Brep_fscanf(fopen('cube.brep'));
s = 'Trns_shift( [2 0.5 1] )';
M = eval(s);
cube.p = cube.p*M;
cube.p = cube.p.*2;

% Here are OBJ 'texture' uv coordinates for the cube. You can use any
% images texture for this, as the UVs define the four corners of an image.
% vt 0.0 0.0  # vt=1 is upper left of texture
% vt 0.0 1.0  # vt=2 is lower left of texture
% vt 1.0 0.0  # vt=3 is upper right of texture
% vt 1.0 1.0  # vt=4 is lower right of texture
cube.vt = [0 0;0 1;1 0;1 1];
% The cube has 'cube.tri' values, which relate to faces.
% To texture map, we need UV coordinates relating to faces ones.
% This is so when we know what face to texture, we know where in the image
% to look. We will define a simple to use list here.
cube.tri_uvs = [1 2 4;
                4 3 1;
                2 4 3;
                3 1 2;
                4 3 1;
                1 2 4;
                2 3 1;
                4 3 2;
                1 2 4;
                4 3 1;
                1 2 4;
                4 3 1];             

plane = Brep_fscanf(fopen('plane.brep'));
s = 'Trns_xrot(  1.5708 )';
M = eval(s);
plane.p = plane.p*M;
plane.p = plane.p.*15;

% Note that the transformed values are contained in .p (not .x)

% Let's plot these all out:
plot3(cube.p(:,1),cube.p(:,2),cube.p(:,3),'r.-');
hold on
plot3(cylinder.p(:,1),cylinder.p(:,2),cylinder.p(:,3),'g.-')
plot3(plane.p(:,1),plane.p(:,2),plane.p(:,3),'k.-');

% What about the normals? Let's do this now.
cylinder.n = Brep_nrm( cylinder );
cube.n = Brep_nrm( cube );
plane.n = Brep_nrm( plane );

window = [256 256 1 1]; % you can define the window differently if you like
ambient_light = [0.3 0.3 0.3]; % Use this as a default 
directional_light_1 = [5 5 -5]; % Use this basic light for this scene - you can alter if you like 
directional_light_2 = [-5 5 -5]; % Use this basic light for this scene - you can alter if you like
example_camera = [0 3 -10]; % Here is a basic camera - you can also alter this if you like.


% Let's plot some example lights.
plot3(directional_light_1(1,1),directional_light_1(1,2),directional_light_1(1,3),'y.');
plot3(directional_light_2(1,1),directional_light_2(1,2),directional_light_2(1,3),'y.');

% Let's plot an example camera.
plot3(example_camera(1,1),example_camera(1,2),example_camera(1,3),'k.')

% Enjoy!


% Finally, this code writes the object to an OBJ file (e.g. should you want to
% use a different program). Note however that you will have to apply the
% transformations above again should you wish to use a different program.
% Note also that you can load these objects into Maya, Blender, etc, to get
% an idea of what the scene looks like.

fidOBJ=fopen(['cube.obj'],'w');
for k=1:size(cube.p,1)    
    fprintf(fidOBJ,'v %f %f %f\n',cube.p(k,1),cube.p(k,2),cube.p(k,3));    
end
for k=1:size(cube.n,1)
    fprintf(fidOBJ,'vn %f %f %f\n',cube.n(k,1),cube.n(k,2),cube.n(k,3));    
end
for k=1:size(cube.vt,1)
    fprintf(fidOBJ,'vt %f %f\n',cube.vt(k,1),cube.vt(k,2));    
end
% You can define faces in a number of ways in an obj:
% See: http://en.wikipedia.org/wiki/Wavefront_.obj_file
% In the cube, we use v/vt v/vt v/vt
for k=1:size(cube.tri,1)    
    fprintf(fidOBJ,'f %i/%i %i/%i %i/%i\n',...
        cube.tri(k,1),cube.tri_uvs(k,1),...
        cube.tri(k,2),cube.tri_uvs(k,2),...
        cube.tri(k,3),cube.tri_uvs(k,3));    
end
fclose(fidOBJ);

fidOBJ=fopen(['cylinder.obj'],'w');
for k=1:size(cylinder.p,1)    
    fprintf(fidOBJ,'v %f %f %f\n',cylinder.p(k,1),cylinder.p(k,2),cylinder.p(k,3));    
end
for k=1:size(cylinder.n,1)
    fprintf(fidOBJ,'vn %f %f %f\n',cylinder.n(k,1),cylinder.n(k,2),cylinder.n(k,3));    
end
% In the this object, we define faces simply as v v v
% See: http://en.wikipedia.org/wiki/Wavefront_.obj_file
for k=1:size(cylinder.tri,1)    
    fprintf(fidOBJ,'f %i %i %i\n',...
        cylinder.tri(k,1),cylinder.tri(k,2),cylinder.tri(k,3));    
end
fclose(fidOBJ);

fidOBJ=fopen(['plane.obj'],'w');
for k=1:size(plane.p,1)    
    fprintf(fidOBJ,'v %f %f %f\n',plane.p(k,1),plane.p(k,2),plane.p(k,3));    
end
for k=1:size(plane.n,1)
    fprintf(fidOBJ,'vn %f %f %f\n',plane.n(k,1),plane.n(k,2),plane.n(k,3));    
end
% In the this object, we define faces simply as v v v
% See: http://en.wikipedia.org/wiki/Wavefront_.obj_file
for k=1:size(plane.tri,1)    
    fprintf(fidOBJ,'f %i %i %i\n',...
        plane.tri(k,1),plane.tri(k,2),plane.tri(k,3));    
end
fclose(fidOBJ);
