library(lipdR)
library(tidyverse)
library(readxl)

stackFilePath <- "~/Documents/Work/Lorraine/Stacking/Stack/Merged/"
stackMetaPath <- "~/Documents/Work/Lorraine/Stacking/Stack/Merged/core_info.xlsx"

source("~/Documents/Work/Lorraine/Stacking/Stack/R/convert.R")

# get all data files
txt_list <- list.files(stackFilePath,pattern = "txt",full.names = TRUE)

# get core info excel
es = excel_sheets(stackMetaPath)
allSheets <- vector(mode = "list",length = length(es))
for(i in 1:length(es)){
  allSheets[[i]] <- read_excel(stackMetaPath,sheet = i)
}

# mass convert to lipd
for(i in 1:length(txt_list)){
  txt2lipd(txt_list[i], allSheets)
}

#make a LiPD object
L <- lipdR:::new_lipd(L)

#write
writeLipd(L, path="~/Documents/Work/Lorraine/Stacking/Stack/R/")

