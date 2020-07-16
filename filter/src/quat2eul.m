% ZYX Form
function [ angles ] = quat2eul(q) 
  angles = [ atan2( 2 * (q.w*q.x + q.y*q.z) , 1 - 2*(q.x^2 + q.y^2) );
             asin(  2 * (q.w*q.y - q.z*q.x) ) ;
             atan2( 2 * (q.w*q.z + q.x*q.y) , 1 - 2*(q.y^2 + q.z^2) ) ];
endfunction
