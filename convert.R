txt2lipd <- function(txt, core_info){
  file_name = basename(txt)
  sheet_index_core = 0
  row_index_core = 0
  # find core info for the core
  for (i in 2:4){
    row_index = which(allSheets[[i]]['File Name'] == file_name)
    if (!is.null(row_index)){
      sheet_index_core = i
      row_index_core = row_index
      break
    }
  }
  if (is.null(row_index)){
    print(paste('file name', file_name, 'not found!'))
  }
  
  #initialize LiPD file
  L <- list()
  L$dataSetName <- core_info[[sheet_index_core]]['File Name'][row_index_core,]
  L$investigators <- core_info[[sheet_index_core]]['Reference Name'][row_index_core,]
  L$notes <- core_info[[sheet_index_core]]['Comments'][row_index_core,]
  if(is.null(L$notes)){L$notes <- NULL}
  
  L$archiveType <- "MarineSediment" #THIS IS HARDCODED IN!
  
  #make up a datasetId
  L$datasetId <- paste0("BIGMACS",str_remove_all(L$dataSetName,pattern = "[^A-Za-z0-9]"))
  
  #make it random?
  # L$datasetId <- paste0(  L$datasetId ,paste(sample(size = 16,c(letters,LETTERS,replace = TRUE)),collapse = ""))
  
  L$lipdVersion <- 1.3
  L$createdBy <- "https://github.com/nickmckay/paleoDataView2Lipd"
  
  #initialize geo
  geo <- list()
  geo$latitude <- core_info[[sheet_index_core]]['Latitude'][row_index_core,] %>%
    as.numeric()
  geo$longitude <- core_info[[sheet_index_core]]['Longitude'][row_index_core,] %>%
    as.numeric()
  geo$elevation <- core_info[[sheet_index_core]]['Water Depth'][row_index_core,] %>%
    as.numeric() * -1
  
  L$geo <- geo
  
  #pub
  L$pub <- core_info[[sheet_index_core]]['Reference Name'][row_index_core,]
  
  #paleoData
  print(txt)
  txt_content = read.table(txt, col.names = c('Depth', 'Age', 'd18O'), fill=TRUE)
  mt <- vector(mode = "list",length = length(txt_content))
  
  for(m in c(1,3)){
    mt[[m]] <- makeColumn(txt_content[[m]])
    mt[[m]]$number <- m
  }
  
  L$paleoData <- vector(mode = "list",length = 1)
  L$paleoData[[1]]$measurementTable <- list()
  L$paleoData[[1]]$measurementTable[[1]] <- mt
  
  #chronData
  cmt <- vector(mode = "list",length = length(txt_content))
  
  for(m in c(1,2)){
    cmt[[m]] <- makeColumn(txt_content[[m]])
  }
  
  L$chronData <- vector(mode = "list",length = 1)
  L$chronData[[1]]$measurementTable <- list()
  L$chronData[[1]]$measurementTable[[1]] <- cmt
  
  
  return(L)
  
}

makeColumn <- function(col){
  longName <- names(col)
  
  variableName <- "longName"
  units <- "unitless"
  
  values = col[[1]]
  
  out <- list(variableName = variableName,
              units = units,
              values = values,
              longName = longName,
              TSid = createTSid("pdv2l"))
  
  return(out)
  
}