function Brep_fprintf( fid, obj )

fprintf(fid,'[\n');
for i = 1:size(obj.x,1)
  fprintf(fid, '%f ', obj.x(i,1:3) );
  fprintf(fid,'\n');
end
fprintf(fid,']\n');

fprintf(fid,'[\n');
for i = 1:size(obj.tri,1)
  fprintf(fid, '%d ', obj.tri(i,:) );
  fprintf(fid,'\n');
end
fprintf(fid,']');

fprintf(fid,'[\n');
for i = 1:size(obj.colour,1)
  fprintf(fid, '%d ', obj.colour(i,:) );
  fprintf(fid,'\n');
end
fprintf(fid,']');

return
