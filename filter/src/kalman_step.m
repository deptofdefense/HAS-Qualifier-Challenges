
% f has static elements of filter: F, B, H, Q, R
% x is the current estimate
% u is current input 
% z is current measurement
function [x, P, xh] = kalman_step(f, P, x, u, z)
  
  xh = f.F*x + f.B*u;
  P = f.F * P * f.F' + f.Q;
  
  y = z - f.H * xh;
  S = f.H * P * f.H' + f.R ;
  K = P * f.H' * inv(S);
  x = xh + K * y;
  P = (f.I - K * f.H) * P;
  
endfunction