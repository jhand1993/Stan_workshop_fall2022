# PITT 2022 Stan Workshop
## Getting started
If you want to use the conda environment I use, from the repository's base directory run the following in your terminal:
>conda env create -f environment.yml.

Alternatively (or if the environment.yml install method fails), we will be using the following packages for Python 3.9:
- PyStan 3.5 (install with pip)
- matplotlib
- scipy
- numpy
- corner (install with pip)
- JupyterLab or Jupyter Notebook 
- pandas
- nest_asyncio (install with pip).

You may need to install in your Python environment libgfortran even after installing a conda environment from the yaml provided:
>conda install -c conda-forge libgfortran.

PyStan is compatible with macOS and some Linux distributions, so make sure your computer is compatible before embarking on this workshop.

Note: we are using PyStan 3, which is a significant rewrite of PyStan and is not compatible with PyStan 2.  Make sure to install PyStan via pip to get the latest stable PyStan 3!

## Workshop 1
This notebook introduces Stan and its python wrapper PyStan 3.  Learn basic syntax and how to run some linear regression models!