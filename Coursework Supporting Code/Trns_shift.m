function M = Trns_shift( u )

M = [
  1 0 0 0
  0 1 0 0
  0 0 1 0
  u(1) u(2) u(3) 1 ];

return;