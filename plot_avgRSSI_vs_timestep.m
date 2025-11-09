% plot_RSSI_10_timesteps.m
clc; clear;

% RSSI values from parseFCDandComputeRSSI
timesteps = 0:9;
avgRSSI = [-76.87, -76.89, -75.25, -75.32, -75.39, -75.27, -75.11, -74.82, -74.63, -74.89];

figure;
plot(timesteps, avgRSSI, '-o','LineWidth',2,'MarkerSize',6);
xlabel('Timestep');
ylabel('Average RSSI (dBm)');
title('Average RSSI per Timestep (First 10 Timesteps)');
grid on;
