# NR-V2X-AI-Scheduler
Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 (V2P, pedSUMO & MATLAB)
---

## Overview

This repository contains the dataset and scripts supporting the ICT Express manuscript:

"Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 Using pedSUMO for V2P Scenarios."

It includes MATLAB-generated CSV files, example plots, and scripts for reproducing the AI scheduler performance metrics reported in the manuscript. The dataset focuses on NR-V2X Mode 2 resource allocation for Vehicle-to-Pedestrian (V2P) scenarios using pedSUMO-generated mobility traces.

---

## Repository Contents

| Folder/File | Description |
|-------------|-------------|
| `data/` |The CSV dataset was generated from a MATLAB 2024a Q-learning simulation based on pedSUMO mobility traces. The MATLAB script implements a simplified Q-learning model for resource allocation (vehicles selecting resource blocks), inspired by an ns-3 C++ example but without simulating the radio layer. |
| `scripts/` |MATLAB-generated CSVs (ai_scheduler_metrics.csv) with episode-wise Q-learning metrics. |
| `figures/` | Plots illustrating training convergence and scheduler performance. |
| `README.md` | This file. |

---

## Dataset Details

The dataset includes:  

- Episode-wise Q-learning metrics: epsilon, average reward, collisions, and penalties.  

**Note:** The dataset corresponds to the simulations reported in the manuscript to be submitted to ICT Express; The CSV dataset (ai_scheduler_metrics.csv) was generated from a MATLAB 2024a Q-learning simulation implementing a simplified NR-V2X Mode 2 resource allocation model (vehicles selecting resource blocks); pedSUMO mobility traces are used separately for evaluating metrics like PDR, not for generating the CSV.

---

## Usage Instructions

1. Clone the repository:  
```bash
git clone https://github.com/idris0001/NR-V2X-AI-Scheduler.git
