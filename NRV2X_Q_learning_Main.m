%% --- Q-learning Training Loop (Revised for V2P) ---
clc; clear; close all;

% --- Parameters ---
numVehicles    = 150;
numPedestrians = 50;           % added for V2P
numEntities    = numVehicles + numPedestrians; % total agents

rbNum         = 30;           % increased resource blocks
numEpisodes   = 2000;
T             = 50;           % time steps per episode

alpha = 0.2;                  % learning rate
gamma = 0.95;                 % discount factor
epsilonStart = 0.4;           % exploration start
epsilonMin   = 0.01;          % min epsilon
epsilonDecay = 0.995;         % decay per episode
exploitAfter = 1500;          % pure exploitation after this episode

% Reward weights
w1 = 0.3; w2 = 0.3; w3 = 0.3; w4 = 0.5;

% --- Initialize ---
Q = zeros(numEntities, rbNum);
AvgReward   = zeros(numEpisodes,1);
Collisions  = zeros(numEpisodes,1);
EpsilonHist = zeros(numEpisodes,1);

%% --- Training Episodes ---
epsilon = epsilonStart;
for ep = 1:numEpisodes
    totalReward = 0;
    collisions  = 0;

    for t = 1:T
        for v = 1:numEntities

            % --- Action selection ---
            if rand < epsilon
                r = randi(rbNum);     % explore
            else
                [~,r] = max(Q(v,:));  % exploit
            end

            % --- Environment feedback ---
            % Different utilities for vehicles vs pedestrians
            if v <= numVehicles
                L = rand;   % latency utility (0-1 normalized)
                Tt= rand;   % throughput utility
                S = rand;   % safety utility
                C = rand < 0.2; % collision chance
            else
                % pedestrians may have lower throughput relevance
                L = rand;   
                Tt= 0;      
                S = rand;   % safety important
                C = rand < 0.1; % lower collision probability
            end

            % --- Reward function ---
            R = (w1*L + w2*Tt + w3*S)*5 - w4*3*C;

            % --- Q-update ---
            Q(v,r) = Q(v,r) + alpha * (R + gamma*max(Q(v,:)) - Q(v,r));

            totalReward = totalReward + R;
            collisions  = collisions + C;
        end
    end

    % --- Logging ---
    AvgReward(ep)   = totalReward / (numEntities*T);
    Collisions(ep)  = collisions;
    EpsilonHist(ep) = epsilon;

    % --- Epsilon schedule ---
    if ep < exploitAfter
        epsilon = max(epsilon*epsilonDecay, epsilonMin);
    else
        epsilon = 0; % pure exploitation
    end
end

%% --- Plotting ---
figure('Color','w','Position',[100 100 700 500]);

subplot(2,1,1);
plot(movmean(AvgReward,20),'LineWidth',1.8);
xlabel('Episode'); ylabel('Average Reward');
title('Average Reward per Episode (Smoothed)'); grid on;

subplot(2,1,2);
yyaxis left
plot(EpsilonHist,'--','LineWidth',1.5);
ylabel('Epsilon'); ylim([0 1.05]);
yyaxis right
plot(movmean(Collisions,20),'LineWidth',1.8);
ylabel('Collisions'); xlabel('Episode');
title('Epsilon Decay and Collisions (Smoothed)'); grid on;
