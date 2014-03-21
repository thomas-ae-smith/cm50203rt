function obj = CamObj_project( cam, obj )

y = obj.p * cam.proj;
obj.q = y ./ repmat( y(:,4), 1, 4 );



return;
