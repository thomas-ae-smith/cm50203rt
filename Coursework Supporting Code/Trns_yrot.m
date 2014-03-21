function M = Trns_yrot( a )

M = [
  cos(a) 0 -sin(a) 0;
  0      1 0      0;
 sin(a) 0 cos(a) 0;
  0      0 0      1
];

return;