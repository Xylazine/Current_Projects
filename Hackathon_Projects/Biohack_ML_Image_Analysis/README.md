# Malaria Cell Classifier
## Biohack Spring 2026
### Team: Amanda Gale, Aamna Sheikh, Zahera Khatoon

## Project Description
A machine learning classifier to automatically detect malaria-infected cells from microscopic blood smear images using cell morphology features.

## Dataset
NIH Malaria Cell Images Dataset from Kaggle
- 27,000 total images
- 1992 images used (992 parasitized, 1000 uninfected)

## Features Extracted
- Area
- Perimeter
- Eccentricity
- Mean Intensity

## How to Run
1. Run `main.py` to execute the full pipeline:

## Pipeline
1. `1_import_data.py` — Downloads dataset and extracts features
2. `2_clean_and_shape_data.py` — Cleans and scales data
3. `3_build_model.py` — Builds and evaluates ML models

## Results
- SVM accuracy: 87%
- Random Forest accuracy: 86%

## Requirements
- Python 3.12
- pandas, scikit-learn, scikit-image, kagglehub, numpy