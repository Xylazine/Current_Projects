# Gene Expression Cancer Classification: A Machine Learning Approach

## Project Description
This signature project develops and evaluates multiple machine learning models for 
cancer type classification using RNA-Seq gene expression data. The analysis demonstrates 
dimensionality reduction, feature engineering, hyperparameter tuning, and ensemble methods 
on high-dimensional biological data.

## Author Information
**Name**: Amanda Gale  
**Institution**: Northeastern University  
**Term**: Spring 2026

## Dataset Information
### Source
The Cancer Genome Atlas (TCGA) Pan-Cancer Analysis Project gene expression data, 
obtained from the UCI Machine Learning Repository.

### Citation
Weinstein, J. N., et al. (2013). The Cancer Genome Atlas Pan-Cancer analysis project. 
*Nature Genetics*, *45*(10), 1113-1120.

### Characteristics
- **Samples**: 801 tumor samples across 5 cancer types
- **Features**: 20,531 gene expression measurements (RNA-Seq, log2-transformed RSEM values)
- **Target Classes**: 
  - BRCA (Breast Invasive Carcinoma)
  - KIRC (Kidney Renal Clear Cell Carcinoma)
  - COAD (Colon Adenocarcinoma)
  - LUAD (Lung Adenocarcinoma)
  - PRAD (Prostate Adenocarcinoma)
- **Data Quality**: Pre-normalized, minimal missing values
- **Access**: https://archive.ics.uci.edu/ml/datasets/gene+expression+cancer+RNA-Seq

## Project Structure
One main markdown notebook (GaleA_RNAcancer_model.Rmd) carries out all tasks associated with this project.