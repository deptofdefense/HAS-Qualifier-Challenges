
function [ quat ] = eul2quat(angles)
  cr = cos(angles(1)/2);
  sr = sin(angles(1)/2);
  cp = cos(angles(2)/2);
  sp = sin(angles(2)/2);
  cy = cos(angles(3)/2);
  sy = sin(angles(3)/2);
  quat = quaternion(cy*cp*cr + sy*sp*sr, 
                    cy*cp*sr - sy*sp*cr,
                    sy*cp*sr + cy*sp*cr,
                    sy*cp*cr - cy*sp*sr);
endfunction