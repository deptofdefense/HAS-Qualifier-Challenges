function [filter] = make_filter(Q,R,Ts)
  filter = {};

  F = [  1   Ts  0   % pos
         0   1   Ts  % rate 
         0   0   0 ]; % accel 
        
  B = [0 
       0
       1 ];
  
  H = eye(3);


  filter.F = F;
  filter.B = B;
  filter.H = H;
  filter.Q = Q;
  filter.R = R;  
  filter.I = eye(length(F));
endfunction