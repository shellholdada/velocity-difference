# README

## Overview

This project implements **Algorithm 2** to generate vibration acceleration profiles with a desired velocity difference.  
It uses a preconstructed dataset and decoding function to efficiently find parameter vectors for given values of fundamental frequency (`f`) and velocity difference (`delta`).

## File Descriptions

- `main.m`  
  Main script that implements **Algorithm 2**.  
  It loads the dataset and generates a list of corresponding parameter vectors (`cp_list`) for the given `f` and `delta`.

- `pv_ds.mat`  
  Dataset constructed by **Algorithm 1**, containing 42,467,328 entries:  
  - **Column 1**: Velocity differences (stored as single precision).  
  - **Column 2**: Compressed integers representing eight amplitude and initial phase parameters corresponding to the velocity differences.  
  - The dataset is sorted in ascending order of velocity difference for efficient searching.

- `gene_pv_ds.m`  
  Implementation of **Algorithm 1**.  
  It systematically varies amplitude and initial phase parameters, calculates the velocity difference for each combination, encodes each parameter vector, and stores the result in `pv_ds.mat`.

- `myencode.m`  
  Encoding function that compresses eight amplitude and initial phase parameters into a single integer.

- `mydecode.m`  
  Decoding function that extracts the eight amplitude and initial phase parameters from the compressed integers stored in `pv_ds.mat`.

## Usage Instructions

1. (Optional) Run `gene_pv_ds.m` to generate `pv_ds.mat` if it does not already exist.
2. Ensure the following files are present in the **current MATLAB folder**:
   - `pv_ds.mat`
   - `mydecode.m`
3. Run `main.m` to generate the desired parameter vectors for a given `f` and `delta`.

## Requirements

- MATLAB Version: **R2021b**
