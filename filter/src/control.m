function [u, q_accel, err] = control(currErr, lastErr)
    kp = 0.01;
    kd = 0.10; 
    u = kp * currErr + kd * (currErr - lastErr);
    %u(3) = 0;
    q_accel = quaternion(u(1), u(2), u(3));
    err = currErr;
endfunction