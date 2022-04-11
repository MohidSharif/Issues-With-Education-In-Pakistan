#### Preamble ####
# Purpose: Obtain and setup data from "The DHS Program"
# Author: Mohid Sharif
# Data: 4 April 2022
# Contact: mohid.sharif@mail.utoronto.ca



#### Workspace setup ####
library(pdftools)
library(tidyverse)

# CODE TO DOWNLOAD PDF (save it in inputs/)
download.file(
  "https://dhsprogram.com/pubs/pdf/FR29/FR29.pdf", 
  "inputs/Pakistan National Health Survey.pdf",
  mode="wb"
)

raw_pdf <- pdf_text("inputs/Pakistan National Health Survey.pdf") |> # read the pdf into a variable
  read_lines()

raw_data <- raw_pdf[1492:1549] # the section of the pdf with our table

raw_data <- tibble(raw_data) # create a table of the raw data

write.csv(raw_data, "inputs/data/raw_data.csv", row.names=FALSE) # write the raw data into a cvs file

#### What's next? ####

raw_data <- raw_data[-c(1:5, 19, 24,30:34, 48, 53), ] # get rid of unnecessary lines in the raw data



colnames(raw_data) <- c("x")

# get rid of extra spaces leaving a single space
raw_data <- raw_data |>
  mutate(x=str_squish(x))

# obtain the datapoints to fill a 22x9 matrix
mat <- matrix(rep(0, 198), nrow=22, byrow=TRUE)
counter = 1

for (i in 1:22) {
  
  numbers <- strsplit(raw_data$x[i], " ")[[1]] # get numbers for this row
  
  if (length(numbers) >= 10) {
    
    for (j in 1:length(numbers)) {
      numbers[j] <- str_replace(numbers[j][1], "-", ".") # fix all "-", "_", " .", ",", "`" into decimal points
      numbers[j] <- str_replace(numbers[j][1], "_", ".") 
      numbers[j] <- str_replace(numbers[j][1], " .", ".") 
      numbers[j] <- str_replace(numbers[j][1], ",", ".")
      numbers[j] <- str_replace(numbers[j][1], "`", ".")
    }
    
    # take in the numbers but start from the back and move forward, until we have 9
    numbers <- rev(numbers) # reverse the numbers
    numbers <- numbers[1:9] # first 9 are never names/non-numeric
    numbers <- rev(as.numeric(numbers)) # now we have the row values in correct order
    
    mat[counter, ] <- numbers # add numbers as a row of mat
    counter <- counter + 1 # increase counter by 1
  }
  # otherwise we reject this row because it was missing data or not a row we care about
}

# set up appropriate column names
column_names <- c("No Education", "Primary", "Middle", "Secondary+", "Missing", "Total", "Population", "Median years", "Mean years")
# set up appropriate row names
row_names <- c("5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65+", "Total Urban", "Major city", "Other urban", "Rural", "Punjab", "Sindh", "NWFP", "Balochistan", "Total")

# after cleaning, construct the final data frame
final_df <- data.frame(mat)
colnames(final_df) <- column_names
final_df$`Background Characteristic` <- row_names

# Make the first column background characteristic
final_df <- final_df |>
  select(`Background Characteristic`, everything())

# save it to a csv file
write.csv(final_df, "inputs/data/males_data.csv", row.names=FALSE)

# now get rid of all processed lines
raw_data <- raw_data[-c(1:22), ]

# create our matrix for the second table for "females"
mat1 <- matrix(rep(0, 198), nrow=22, byrow=TRUE)
counter = 1

for (i in 1:22) {
  
  numbers <- strsplit(raw_data$x[i], " ")[[1]] # get numbers for this row
  
  if (length(numbers) >= 10) {
    
    for (j in 1:length(numbers)) {
      numbers[j] <- str_replace(numbers[j][1], "-", ".") # fix all "-", "_", " .", ",", "`" into decimal points
      numbers[j] <- str_replace(numbers[j][1], "_", ".") 
      numbers[j] <- str_replace(numbers[j][1], " .", ".") 
      numbers[j] <- str_replace(numbers[j][1], ",", ".")
      numbers[j] <- str_replace(numbers[j][1], "`", ".")
    }
    # fix all unorthodox cases into decimal points .
    if (i == 1){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "~", "40")
    }
    }
    if (i == 13){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "~", "0.") 
      }
    }
    if (i == 18){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "A", ".1") 
      }
    }
    # take in the numbers but start from the back and move forward, until we have 9
    numbers <- rev(numbers) # reverse the numbers 
    numbers <- numbers[1:9] # first 9 are never names/non-numeric
    numbers <- rev(as.numeric(numbers)) # now we have the row values in correct order
    
    mat1[counter, ] <- numbers # add numbers as a row of mat1
    counter <- counter + 1 # increase counter by 1
  }
  # otherwise we reject this row because it was missing data or not a row we care about
}

# after cleaning, construct the final data frame for our second table
final_df <- data.frame(mat1)
colnames(final_df) <- column_names
final_df$`Background Characteristic` <- row_names

# Make first column background characteristic
final_df <- final_df |>
  select(`Background Characteristic`, everything())

# save it to a csv file
write.csv(final_df, "inputs/data/females_data.csv", row.names=FALSE)
         
