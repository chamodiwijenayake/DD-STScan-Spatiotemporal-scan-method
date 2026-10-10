# DD-STScan: An Adaptive Spatio-Temporal Scan for Irregular Cluster Detection

## Overview
**DD-STScan** is a research project focused on developing an adaptive spatio-temporal scan approach for detecting irregular clusters across geographic regions and time periods. The methodology investigates how spatial and temporal relationships can be integrated to identify potential clusters in spatio-temporal data.

This repository contains research code, simulation scripts, analysis notebooks, data files, parameter configurations, and computational results associated with the DD-STScan project.

---

## Research Objectives
The project investigates methods for detecting irregular spatio-temporal clusters and evaluating their performance through simulation studies and computational experiments.

Key research activities include:
* Developing and evaluating an adaptive spatio-temporal scanning method.
* Generating simulated datasets for methodological evaluation.
* Conducting cylindrical and elliptical scan analyses.
* Evaluating cluster-detection performance using simulation results.
* Supporting computational reproducibility through code, data files, and documentation.

---

## Repository Structure

```text
DD-STScan-Spatiotemporal-scan-method/
├── data/                             # Input and simulation datasets
│   ├── Simulated Data/               # Simulated datasets for methodological experiments
│   ├── Simulated Null Datasets/      # Datasets generated under null conditions
│   ├── data_pop_summary.csv          # Population summary data
│   ├── datapop.csv                   # Population data
│   ├── NMgeo.csv                     # Geographic data for analysis
│   ├── state_coordinates.csv        # Geographic coordinate data
│   └── adj_matrix.csv                # Spatial adjacency matrix
├── docs/                             # Documentation and supplementary materials
│   └── README_Reproducibility_Guide.pdf
├── notebooks/                        # Jupyter Notebooks for analysis
│   ├── Cylindrical_Elliptical.ipynb  # Notebook for cylindrical and elliptical scan analyses
│   └── prm4                          # SaTScan parameter file used in analysis
├── outputs/                          # Computational results and summary reports
│   ├── Results for Sim Data.pdf      # Summary of simulation results
│   └── Null Data Results.csv         # Results associated with null-data experiments
├── src/                              # R source code and algorithm implementations
│   ├── DD-STScan.R                   # Main DD-STScan implementation
│   ├── DD-STScan Data Simulation.R   # Simulation code for dataset generation
│   ├── New.precog.sim.R              # PreCoG-based workflow simulation code
│   └── New.mst.all.R                 # Supporting research code
└── README.md                         # Main repository overview
