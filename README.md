# NR-V2X-AI-Scheduler
Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 (V2P, SUMO & NS3-45)

---

## Overview

This repository contains the dataset and scripts supporting the ICT Express manuscript:

*"Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 Using SUMO for V2P Scenarios."*

It includes NS3-45 training logs, example plots, and scripts for reproducing the AI scheduler performance metrics reported in the manuscript. The dataset focuses on NR-V2X Mode 2 resource allocation for Vehicle-to-Pedestrian (V2P) scenarios using SUMO-generated mobility traces and NS3-45 simulation logs.

---

## Repository Contents

| Folder/File | Description |
|-------------|-------------|
| `data/` | NS3-45 training logs, CSVs, and simulation outputs used to generate performance metrics. |
| `scripts/` | Python scripts for processing logs, computing average reward, collision rate, and plotting figures. |
| `figures/` | Sample plots illustrating training convergence and scheduler performance. |
| `README.md` | This file. |

---

## Dataset Details

The dataset includes:  

- Episode-wise Q-learning metrics: epsilon, average reward, collisions, and penalties.  
- NS3-45 logs and SUMO mobility traces for evaluating the AI scheduler performance.  
- CSV format for easy reproduction and analysis.

**Note:** The dataset corresponds to the simulations reported in the manuscript to be submitted to ICT Express.

---

## Usage Instructions

1. Clone the repository:  
```bash
git clone https://github.com/idris0001/NR-V2X-AI-Scheduler.git
