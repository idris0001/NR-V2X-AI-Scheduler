%% --- Parameters ---
RSSI_th = -80;        % dBm threshold for packet reception
Pt = 20;              % Transmit power in dBm
PL0 = 40;             % Reference path loss at d0 in dB
d0 = 1;               % Reference distance in meters
n = 2.5;              % Path loss exponent

numTimesteps = length(timestepsData);
numVehicles = length(timestepsData(1).vehicles);
numPedestrians = length(timestepsData(1).pedestrians);

% Preallocate PDR array
PDR = zeros(1, numTimesteps);

%% --- Compute RSSI for V2P and PDR ---
for t = 1:numTimesteps
    successfulPackets = 0;
    totalPackets = numVehicles * numPedestrians;
    
    for v = 1:numVehicles
        vPos = timestepsData(t).vehicles(v).pos;
        for p = 1:numPedestrians
            pPos = timestepsData(t).pedestrians(p).pos;
            
            % Compute distance
            d = sqrt((vPos(1) - pPos(1))^2 + (vPos(2) - pPos(2))^2);
            
            % Path loss model
            PL = PL0 + 10*n*log10(max(d,d0));  % avoid log(0)
            RSSI = Pt - PL;
            
            % Store RSSI
            timestepsData(t).vehicles(v).ped_rssi(p) = RSSI;
            
            % Count successful packet
            if RSSI >= RSSI_th
                successfulPackets = successfulPackets + 1;
            end
        end
    end
    
    % Compute PDR for this timestep
    PDR(t) = successfulPackets / totalPackets;
end

%% --- Plot V2P PDR over timesteps ---
figure;
plot(0:numTimesteps-1, PDR, '-o','LineWidth',1.5);
xlabel('Timestep'); ylabel('V2P Packet Delivery Ratio (PDR)');
title('V2P PDR over Time');
grid on;
ylim([0 1]);
