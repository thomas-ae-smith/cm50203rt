function u = uvec( x )

% u = uvec( x )
% u is the unit vector of x, or 0 is x is 0.

s = norm(x);
if s > eps
  u = x/s;
else
  u = x;
end

return;
