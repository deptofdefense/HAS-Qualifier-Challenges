function [q_diff] = quat_diff(q_from, q_to)
  q_diff = unit(q_to * inv(q_from));  
endfunction