clear all;
pkg load quaternion;
pkg load statistics;

%% 
% Configuration
Ts    = 0.05;            % Seconds
steps = 120/Ts;          % Run for x minutes
rate  = (2*pi)/(90*60);  % 1 rad/sec
err_thresh = 1*pi/180. ;   % 1 Degree error max

seed = getenv("SEED");
if size(seed) == 0
    seed_i = time();
else
    seed_i = sscanf(seed, "%ld");
endif
rand('seed', seed_i);

%% 
% Setup Initial State 
% Initial position and rate
angle_0 = (rand(1) * 0.2 - 0.1) * 2 * pi;
q_rate_0 = rate * quaternion(1, 0, 0);
q_att_0  = eul2quat([angle_0,0,0]);
% Target tracks the goal orientation of the satellite
% Feeds control loop error
target.q_att  = q_att_0;
target.q_rate = q_rate_0;
target.time   = 0;

% Actual model of the system, observed by sensors
% Not used directly by the filter
actual.q_att  = q_att_0;
actual.q_rate = q_rate_0;
actual.time   = 0;

%% 
% Setup Filters
P = diag([1, 0.01, 0]) * 1e-5;
Q = diag([1e-7, 1e-7, 0.0])^2;
R = diag([1e-1, 1e-3, 1e-3])^2 ;

filters = [ 
    make_filter(Q,R,Ts)    % Roll
    make_filter(Q,R,Ts)    % Pitch
    make_filter(Q,R,Ts)    % Yaw
];

% Original State
x = [ 
    quat2eul(q_att_0)'
    q_rate_0.x, q_rate_0.y, q_rate_0.z
    zeros(1,3)  
];
Ps = zeros(3,3,3);
for i = 1:3
    Ps(:,:,i) = P;
endfor 

%% 
% Setup Control loop
lastErr = [0, 0, 0];

% Original Input
u = [0 0 0];
q_accel = quaternion(u(1), u(2), u(3));
%%
% Main Control loop

for i = 1:steps
    % Calculate Error
    q_est = eul2quat(x(1,:));
    err = quat2eul(quat_diff(q_est, target.q_att))';
    
    % Check error bounds
    if max(abs(err)) > err_thresh
        disp("Error: Estimator error too large... Goodbye");
        disp(q_est);
        disp(target.q_att);
        break;
    endif

    % Calculate the correction 
    if mod(i, 5) == 0
        [u, q_accel, lastErr] = control(err, lastErr);
        actual.q_rate = actual.q_rate + q_accel;
    endif 
    
    % Step States
    target = state_step(target, Ts);
    actual = state_step(actual, Ts);

    % Check we're still safe...
    [v,a] = q2rot(quat_diff(actual.q_att, target.q_att));
    if abs(v(2)*a) >  (pi/8)
        disp("Uh oh, better provide some information!");
        disp(getenv("FLAG"))
        break;
    endif

    % Get Observations
    q_att = startracker(actual);

    [q_rate, q_acc] = gyro(actual.q_rate, q_accel);
    z = [ 
        quat2eul(q_att)'
        q_rate.x, q_rate.y, q_rate.z
        q_acc.x,  q_acc.y,  q_acc.z 
    ];

    % Filter
    for j = 1:3
        [x(:,j), Ps(:,:,j), _] = kalman_step(filters(j), Ps(:,:,j), x(:,j), u(j), z(:,j));
    endfor

endfor




