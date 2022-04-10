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

raw_pdf <- pdf_text("inputs/Pakistan National Health Survey.pdf") |>
  read_lines()

raw_data <- raw_pdf[1492:1549] # the section of the pdf with our table (spans 2 pages)

raw_data <- tibble(raw_data)

write.csv(raw_data, "inputs/data/raw_data.csv", row.names=FALSE)

#### What's next? ####

raw_data <- raw_data[-c(1:5, 19, 24,30:34, 48, 53), ]



colnames(raw_data) <- c("x")

# get rid of extra spaces leaving a single space
raw_data <- raw_data |>
  mutate(x=str_squish(x))

# obtain the datapoints to fill a 26x12 matrix
mat <- matrix(rep(0, 198), nrow=22, byrow=TRUE)
counter = 1

for (i in 1:22) {
  
  numbers <- strsplit(raw_data$x[i], " ")[[1]] # get numbers for this row
  
  if (length(numbers) >= 10) {
    
    for (j in 1:length(numbers)) {
      numbers[j] <- str_replace(numbers[j][1], "-", ".") # fix all - into decimal points .
      numbers[j] <- str_replace(numbers[j][1], "_", ".") # fix all - into decimal points .
      numbers[j] <- str_replace(numbers[j][1], " .", ".") # fix all ' '. into decimal points .
      numbers[j] <- str_replace(numbers[j][1], ",", ".")
      numbers[j] <- str_replace(numbers[j][1], "`", ".")
    }
    
    # take in the numbers but start from the back and move forward, until we have 12
    # this avoids the problem of states being in two indices at the front because of their spaces
    numbers <- rev(numbers) # reverse the numbers (hit it from behind)
    numbers <- numbers[1:9] # first 12 are never names/non-numeric (take what we want)
    numbers <- rev(as.numeric(numbers)) # now we have the row values in correct order too (turn it back around)
    
    mat[counter, ] <- numbers # add numbers as a row of mat
    counter <- counter + 1
  }
  # otherwise we reject this row because it was missing data or not a row we care about
}

# column_names <- c(1:23) # TODO: Put the column names here (omit state)
column_names <- c("No Education", "Primary", "Middle", "Secondary+", "Missing", "Total", "Population", "Median years", "Mean years")
# state_names <- c(1:26) # TODO: Put the state names here
row_names <- c("5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65+", "Total Urban", "Major city", "Other urban", "Rural", "Punjab", "Sindh", "NWFP", "Balochistan", "Total")

# after cleaning, construct the final data frame
final_df <- data.frame(mat)
colnames(final_df) <- column_names
final_df$`Background Characteristic` <- row_names

# Make states the first column for visual nice
final_df <- final_df |>
  select(`Background Characteristic`, everything())

# save it to a csv file so we only need to run this script once at the beginning of our journey
write.csv(final_df, "inputs/data/males_data.csv", row.names=FALSE)

raw_data <- raw_data[-c(1:22), ]


mat1 <- matrix(rep(0, 198), nrow=22, byrow=TRUE)
counter = 1

for (i in 1:22) {
  
  numbers <- strsplit(raw_data$x[i], " ")[[1]] # get numbers for this row
  
  if (length(numbers) >= 10) {
    
    for (j in 1:length(numbers)) {
      numbers[j] <- str_replace(numbers[j][1], "-", ".") # fix all - into decimal points .
      numbers[j] <- str_replace(numbers[j][1], "_", ".") # fix all - into decimal points .
      numbers[j] <- str_replace(numbers[j][1], " .", ".") # fix all ' '. into decimal points .
      numbers[j] <- str_replace(numbers[j][1], ",", ".")
      numbers[j] <- str_replace(numbers[j][1], "`", ".")
    }
    if (i == 1){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "~", "40") # fix all - into decimal points .
    }
    }
    if (i == 13){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "~", "0.") # fix all - into decimal points .
      }
    }
    if (i == 18){
      for (j in 1:length(numbers)) {
        numbers[j] <- str_replace(numbers[j][1], "A", ".1") # fix all - into decimal points .
      }
    }
    # take in the numbers but start from the back and move forward, until we have 12
    # this avoids the problem of states being in two indices at the front because of their spaces
    numbers <- rev(numbers) # reverse the numbers (hit it from behind)
    numbers <- numbers[1:9] # first 12 are never names/non-numeric (take what we want)
    numbers <- rev(as.numeric(numbers)) # now we have the row values in correct order too (turn it back around)
    
    mat1[counter, ] <- numbers # add numbers as a row of mat
    counter <- counter + 1
  }
  # otherwise we reject this row because it was missing data or not a row we care about
}

# after cleaning, construct the final data frame
final_df <- data.frame(mat1)
colnames(final_df) <- column_names
final_df$`Background Characteristic` <- row_names

# Make states the first column for visual nice
final_df <- final_df |>
  select(`Background Characteristic`, everything())

# save it to a csv file so we only need to run this script once at the beginning of our journey
write.csv(final_df, "inputs/data/females_data.csv", row.names=FALSE)
         
