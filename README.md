# NR-V2X-AI-Scheduler
Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 (V2P, pedSUMO & MATLAB)
---

This repository contains the MATLAB scripts, the generated mobility trace, and the dataset supporting the ICT Express manuscript:

"Adaptive Q-Learning for Collision-Aware Resource Allocation in NR-V2X Mode 2 Using pedSUMO for V2P Scenarios."

It includes MATLAB-generated CSV files, example plots, scripts for reproducing the AI scheduler performance metrics, and a generated mobility trace for evaluation. The dataset focuses on NR-V2X Mode 2 resource allocation for Vehicle-to-Pedestrian (V2P) scenarios. PedSUMO-generated mobility traces are included only as generated outputs, **not the original network files**.

---

## Repository Contents

| Folder/File | Description |
|-------------|-------------|
| `data/` | CSV dataset (`ai_scheduler_metrics.csv`) generated from a MATLAB 2024a Q-learning simulation. Implements a simplified Q-learning model for resource allocation (vehicles selecting resource blocks). Also contains the generated mobility trace `mobility_trace_with_timestamp.xml`, capturing vehicle and pedestrian states at each timestep (limited to the first 10 timesteps for file size). |
| `scripts/` | MATLAB code (`nr_v2p_qlearning_base.m`) and CSV metrics (`ai_scheduler_metrics.csv`). |
| `figures/` | Plots illustrating training convergence and scheduler performance. |
| `README.md` | This file. |

---

## Dataset & Mobility Trace Details

The dataset includes:  

- Episode-wise Q-learning metrics: epsilon, average reward, collisions, and penalties.  
- Mobility trace (`mobility_trace_with_timestamp.xml`): generated from the original pedSUMO network (`BasicNetwork.net.xml`), routes (`BasicDemand_.rou.xml`), and GUI settings (`BasicView.xml`). Captures positions, speeds, and lane/edge assignments for vehicles and pedestrians at each timestep. **Note:** To reduce file size, this version includes only the first 10 timesteps.

**Important:** The CSV dataset was generated independently in MATLAB. The included mobility trace is for evaluation and visualization; the original pedSUMO files are **not** part of this repository. Users can generate full mobility traces using the original pedSUMO files if needed.

---

## Usage Instructions

1. Clone the repository:  
```bash
git clone https://github.com/idris0001/NR-V2X-AI-Scheduler.git
```
2. Open MATLAB and run nr_v2p_qlearning_base.m to reproduce the Q-learning metrics stored in ai_scheduler_metrics.csv.
3. Load mobility_trace_with_timestamp.xml in SUMO or any FCD-compatible viewer to analyze vehicle and pedestrian states over time. The trace contains only the first 10 timesteps for demonstration purposes.
