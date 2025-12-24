
This pipeline builds various predictive models designed to classify subtypes of anemia 
based on results from blood tests. If you are a reviewer not intending to execute the 
pipeline, please see the HTML outputs for the project in the *outputs_and_zip_for_reviewers* folder.
If you intend to run the pipeline, there is a fresh zip file located in this folder that can be 
downloaded and run according to the instructions in the *README.md* file very similar to this one. 

This pipeline assumes that all required R packages will be pre-installed and that 
RStudio will have access to a copy of Python in order to create a virtual environment. 
All Python libraries will be installed within the virtual environment created in this
project folder. 

To execute the full pipeline:

1. Ensure that the project directory contains all necessary files listed below.
2. Install the required R packages listed below. 
3. Load the project file *FinalProject.Rproj*. This will ensure everything takes place within this directory.
4. Knit *Main_File.Rmd*. This will automatically render the data pre-processing file, *data_prep.Rmd*.
In order to knit this prep file independently, the first 73 lines of *Main_File.Rmd* must first be executed. 

Troubleshooting: This pipeline will not work if RStudio cannot find a local copy of Python. If this is an issue, you
should run it instead through Posit Cloud.


Required files in directory:
- FinalProject.Rproj
- Main_File.Rmd
- data_prep.Rmd
- README.md

Required R packages:
- reticulate
- RSQLite



