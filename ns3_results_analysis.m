% nr_v2p_qlearning.m
% Converted from ns-3 C++ Q-learning example to MATLAB
% Simplified, high-level simulation (no ns-3 radio, just mobility + abstract metrics)

clear; close all; rng('shuffle');

%% --- Parameters (matching the C++ defaults) ---
alpha         = 0.5;      % learning rate
epsilon       = 1.0;      % exploration initial
epsilonMin    = 0.01;
epsilonDecay  = 0.995;
numEpisodes   = 1000;

w1 = 0.7;
w2 = 0.3;
PC_max  = 100.0;
penalty = 1000.0;

numVehicles    = 150;
numPedestrians = 50;
rbNum          = 20;

% Mobility / simulation time
durationSteps = 50; % number of discrete time steps for waypoints (seconds in original)
dt = 1.0;           % time step (s)

%% --- Create mobility traces (waypoints) ---
% Pedestrians: start at startY and move up with stepSize
stepSize = 1.2;
startY = -200.0;

% Pedestrian positions: [x, y] at each time step
pedPos = zeros(numPedestrians, 2, durationSteps);
for p = 1:numPedestrians
    startX = 8.0 + (p-1)*0.5;
    for t = 1:durationSteps
        pedPos(p, :, t) = [startX, startY + (t-1)*stepSize];
    end
end

% Vehicles: for this simplified model create linear motion across X axis
vehiclePos = zeros(numVehicles, 2, durationSteps);
for v = 1:numVehicles
    startX = -100 + rand()*200; % random start x in [-100,100]
    startY_v = -50 + rand()*100; % random y in [-50,50]
    vx = -2 + 4*rand(); % speed in x [-2,2] m/s
    vy = -0.5 + 1.0*rand(); % speed in y [-0.5,0.5] m/s
    for t = 1:durationSteps
        vehiclePos(v, :, t) = [startX + (t-1)*vx, startY_v + (t-1)*vy];
    end
end

%% --- Q-table and bookkeeping ---
Qtable = zeros(numVehicles, rbNum); % each row: vehicle, each column: RB
currentRBChoice = -ones(numVehicles,1);

% Metrics recorders
metrics.episode = (1:numEpisodes)';
metrics.epsilon = zeros(numEpisodes,1);
metrics.avgReward = zeros(numEpisodes,1);
metrics.collisions = zeros(numEpisodes,1);
metrics.penalties = zeros(numEpisodes,1);

%% --- Helper metric stubs (mirrors C++ stubs) ---
% These are simplistic and can be replaced with more detailed channel models.
GetLatency = @(txIdx, rxIdx) (randi(10));         % returns 1..10 ms
GetThroughput = @(txIdx, rxIdx) (randi(100));    % returns 1..100 units
GetPower = @(txIdx, rb) (1.0 + 0.01 * rb);       % simple small function of RB

ChannelOccupied = @(rb, assignment) any(assignment == rb);

ComputeReward = @(v, rb, devices, assignment) computeRewardMat( v, rb, devices, assignment, ...
                                                               GetLatency, GetThroughput, GetPower, ...
                                                               w1, w2, PC_max, penalty );

%% --- List of 'devices' placeholders (we only need indices in this MATLAB model) ---
devices = 1:numVehicles;

%% --- Simulation: episodes of Q-learning ---
for episode = 1:numEpisodes
    episodeRewards = zeros(numVehicles,1);
    collisionCount = 0;
    penaltyCount = 0;
    
    % For each vehicle choose RB and update Q-table (one allocation step per episode)
    for v = 1:numVehicles
        explore = (rand() < epsilon);
        if explore
            chosenRB = randi(rbNum) - 1; % 0-based RB index in C++ -> use 0..rbNum-1 to be consistent
        else
            % exploitation: pick RB with max Q
            [~, idx] = max(Qtable(v, :));
            chosenRB = idx - 1;
        end
        
        reward = ComputeReward(v, chosenRB, devices, currentRBChoice);
        episodeRewards(v) = reward;
        
        % compute max next Q (for same vehicle row)
        maxNextQ = max(Qtable(v, :));
        
        % Update Qtable (note mapping between 0-based chosenRB and MATLAB indexing)
        Qtable(v, chosenRB+1) = Qtable(v, chosenRB+1) + alpha * (reward + 0.9 * maxNextQ - Qtable(v, chosenRB+1));
        
        % track penalty / collisions for metrics
        if GetPower(v, chosenRB) > PC_max
            penaltyCount = penaltyCount + 1;
        end
        if ChannelOccupied(chosenRB, currentRBChoice)
            collisionCount = collisionCount + 1;
        end
        
        % set choice
        currentRBChoice(v) = chosenRB;
    end
    
    % record metrics
    metrics.epsilon(episode) = epsilon;
    metrics.avgReward(episode) = mean(episodeRewards);
    metrics.collisions(episode) = collisionCount;
    metrics.penalties(episode) = penaltyCount;
    
    % decay epsilon
    epsilon = max(epsilonMin, epsilon * epsilonDecay);
end

%% --- Save metrics to CSV ---
T = table(metrics.episode, metrics.epsilon, metrics.avgReward, metrics.collisions, metrics.penalties, ...
    'VariableNames', {'Episode','Epsilon','AvgReward','Collisions','Penalties'});
writetable(T, 'ai_scheduler_metrics.csv');

%% --- Simple plots ---
figure;
subplot(2,1,1);
plot(T.Episode, T.AvgReward);
xlabel('Episode'); ylabel('Average Reward');
title('Average Reward per Episode');

subplot(2,1,2);
yyaxis left; plot(T.Episode, T.Epsilon); ylabel('Epsilon');
yyaxis right; plot(T.Episode, T.Collisions); ylabel('Collisions');
xlabel('Episode'); title('Epsilon decay and Collisions');

disp('Simulation finished. Metrics saved to ai_scheduler_metrics.csv');

%% --- Helper function definitions ------------------------------
function r = computeRewardMat(v, rb, devices, assignment, GetLatency, GetThroughput, GetPower, w1, w2, PC_max, penalty)
    % v: index of vehicle (MATLAB 1-based), but stubs use indices only for randomness
    % rb: chosen resource block (0-based as per conversion)
    % assignment: currentRBChoice vector (0-based values or -1 for unassigned)
    % This function returns the reward value (scalar)
    
    % For consistency with the original C++: latency and throughput are random stubs
    latency = GetLatency(v, []);
    throughput = GetThroughput(v, []);
    
    % Avoid division by zero
    if throughput <= 0
        invThroughput = 1e6;
    else
        invThroughput = 1.0 / throughput;
    end
    
    Z = w1 * latency + w2 * invThroughput;
    reward = -Z;
    
    % check power constraint
    if GetPower(v, rb) > PC_max
        reward = reward - penalty;
    end
    
    % check channel occupied
    if any(assignment == rb)
        reward = reward - penalty;
    end
    
    r = reward;
end
