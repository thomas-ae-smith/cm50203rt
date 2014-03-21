function obj = Brep_fscanf( fid )
% obj = Brep_fscanf( fid )
% Read an object from a text file, which is open with handle fid.
% This is a very simple function that is not robust to errors in files.
% The format of files is of three matrices first data points,
% second triangles, finally colours. Each matrix has 3 columns, and
% each matrix opens with [ and closes with ]. Each row in the point matrix
% is a point. "Triangles" are indices into the point matrix, each row of
% the trinagle matrix indexes three points of the triangle. Each row of the
% colour matrix corresponds to a triangle. Colours are in rgb format with
% every entry in the range [0,1].

% ...points...
% skip whitespaces
a = ']';
while a ~= '['
  a = fscanf(fid,'%c',1);
end
% read until next ']'
buf = [];
while a ~= ']'
  a = fscanf(fid,'%c',1);
  if a ~= ']'
    buf(end+1) = a;
  end
end
buf = char(buf);
obj.x = sscanf(buf,'%f');
obj.x = reshape( obj.x, 3, [] )';
obj.x(:,4) = 1;
obj.p = obj.x;
obj.q = obj.p;

% ...triangles...
while a ~= '['
  a = fscanf(fid,'%c',1);
end
% read until next ']'
buf = [];
while a ~= ']'
  a = fscanf(fid,'%c',1);
  if a ~= ']'
    buf(end+1) = a;
  end
end
buf = char(buf);
obj.tri = sscanf(buf,'%f');
obj.tri = reshape( obj.tri, 3, [] )';

% ...colour...
while a ~= '['
  a = fscanf(fid,'%c',1);
end
% read until next ']'
buf = [];
while a ~= ']'
  a = fscanf(fid,'%c',1);
  if a ~= ']'
    buf(end+1) = a;
  end
end
buf = char(buf);
obj.colour = sscanf(buf,'%f');
obj.colour = reshape( obj.colour, 5, [] )';


return;

