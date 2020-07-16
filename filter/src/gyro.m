function [ qr, qa ] = gyro(q_rate, q_accel)
  qr = q_rate; 
  qr.w = 0;
  qr.x = qr.x + normrnd(0, 1e-7);
  qr.y = qr.y + normrnd(0, 1e-7);
  qr.z = qr.z + normrnd(0, 1e-7);

  qa = q_accel; 
  qa.w = 0;
  qa.x = qa.x + normrnd(0, 1e-7);
  qa.y = qa.y + normrnd(0, 1e-7);
  qa.z = qa.z + normrnd(0, 1e-7);
  
endfunction 