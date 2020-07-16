% Model must have a q_att member

function [ q ] = startracker(model) 
  q = model.q_att;
  disp([q.w, q.x, q.y, q.z]);
  fflush(stdout);
  % Get Input
  q = zeros(4,1);
  for i = 1:4
    q(i) = scanf("%f", "C");
  endfor 
  q = quaternion(q(1), q(2), q(3), q(4));
  %q.w = q.w + normrnd(0, 1e-8);
  %q.x = q.x + normrnd(0, 1e-8);
  %q.y = q.y + normrnd(0, 1e-8);
  %q.z = q.z + normrnd(0, 1e-8);
  
  q = q./norm(q);
  
endfunction
