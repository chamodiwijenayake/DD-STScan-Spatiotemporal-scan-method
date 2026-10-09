# DD-STScan: An Adaptive Spatio-Temporal Scan for Irregular Cluster Detection

## Overview

DD-STScan is a research project focused on developing an adaptive spatio-temporal scan approach for detecting irregular clusters across geographic regions and time periods. The methodology investigates how spatial and temporal relationships can be integrated to identify potential clusters in spatio-temporal data.

This repository contains research code, simulation scripts, analysis notebooks, data files, parameter configurations, and computational results associated with the DD-STScan project.

## Research Objectives

The project investigates methods for detecting irregular spatio-temporal clusters and evaluating their performance through simulation studies and computational experiments.

Key research activities include:

* Developing and evaluating an adaptive spatio-temporal scanning method.
* Generating simulated datasets for methodological evaluation.
* Conducting cylindrical and elliptical scan analyses.
* Evaluating cluster-detection performance using simulation results.
* Supporting computational reproducibility through code, data files, and documentation.

## Repository Contents

### Source Code

* `DD-STScan.R` — Main DD-STScan implementation.
* `DD-STScan Data Simulation.R` — Simulation code for generating datasets used in the research.
* `New.precog.sim.R` — Supporting simulation code associated with the PreCoG-based workflow.
* `New.mst.all.R` — Additional supporting research code.

### Notebooks and Parameter Files

* `Cylindrical/Elliptical.ipynb` — Notebook for cylindrical and elliptical scan analyses.
* `prm4` — SaTScan parameter file used in the associated analysis.

### Data

* `Simulated Data/` — Simulated datasets used in the computational experiments.
* `Simulated Null Datasets/` — Simulated datasets generated under null conditions.
* `data_pop_summary.csv` — Population summary data.
* `NMgeo.csv` — Geographic data associated with the analysis.
* `adj_matrix.csv` — Spatial adjacency matrix.
* `datapop.csv` — Population data.
* `state_coordinates.csv` — Geographic coordinate data.

### Results and Documentation

* `Results for Sim Data.pdf` — Summary of simulation results.
* `Null Data Results.csv` — Results associated with null-data experiments.
* `README_Reproducibility_Guide.pdf` — Supplementary reproducibility documentation.

## Software and Dependencies

The repository includes R scripts, a Jupyter notebook, CSV data files, and a SaTScan parameter file.

Required software packages, dependencies, and versions should be identified from the source code and reproducibility guide before running the analyses.

## Reproducibility

To explore or reproduce the computational experiments:

1. Clone or download this repository.
2. Review `README_Reproducibility_Guide.pdf` for the available instructions.
3. Install the required software and dependencies.
4. Verify that input files and file paths are configured correctly.
5. Run the relevant scripts and notebook according to the documented workflow.

The execution order and configuration requirements should be verified against the accompanying code and reproducibility documentation.

## Research and Citation

This repository contains computational materials associated with the research project.

**Research title:** *An Adaptive Spatio-Temporal Scan for Irregular Cluster Detection*

Please refer to the associated research manuscript for methodological details and formal citation information. Publication details can be added when finalized.

## Contributors

* Chamodi Wijenayake
* Dr. James Greene
* Dr. Mohammad Meysami

Contributor attribution should reflect the research team's agreed authorship and contribution arrangements.

## License

No license has been specified. Please consult the research contributors and applicable institutional policies before reusing, modifying, or redistributing the code.
