# starter_folder

This paper contains the R project used in creating the paper "The Key to Success: Education Trends From The 1990/1991 Demographic and Health Survey In Pakistan".

Abstract: We often take our right to free education in Canada for granted while people in third world countries have to pay for education and often times realize they can do without one. In this data study I obtained a National Family Health Survey from Pakistan, hosted by the Demographic and Health Surveys program in the US. I converted the education research table into a usable dataset which I analysed and visualized to observe changes in literacy rate over generations and provinces. In doing so I concluded that literacy rate in Pakistan has been on a steady incline but is rather slow, therefore there should be action taken to promote education for the development of the country.

The repository contains three folders: inputs, outputs, and scripts which are organised as follows:

Inputs: 
  
  Data: the raw and cleaned data csv files obtained from The 1990/1991 Demographic and Health Survey In Pakistan

Outputs:
  
  Materials: Images used in the paper
  
  Paper: R Markdown, a final pdf document, and a bibliography

Scripts:
  
  01-data_cleaning.R: This script downloads, processes, and cleans the data obtained in the DHS final report

To Generate the paper:
  
  Download the repository's main folder
  
  Open Pakistan_HH_Education.Rproj in RStudio
  
  Install libraries using install.packages() and run webshot::install_phantomjs() in the console so the DAGs compile
  
  Run 01-data_cleaning.R to download the pdf report, obtain the cleaned and processed data set
  
  Knit paper.Rmd to reproduce the paper
