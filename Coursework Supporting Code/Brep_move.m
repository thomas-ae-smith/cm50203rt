function obj = Brep_move( obj, M )

% obj = Brep_move( obj, M )
% move the object from its starting position (where it was originally
% defined).

obj.p = obj.x*M;

return;
