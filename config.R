#Bibliotheken laden
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(ggplot2)
library(stringr)
library(stringi)
library(xml2)
library(rjson)
library(jsonlite)
library(readxl)
library(git2r)
library(DatawRappr)
library(lubridate)
library(httr)
cat("Benoetigte Bibliotheken geladen\n")

#Welche Abstimmung?
abstimmung_date <- "Juni2023"

res <- GET("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20230618-eidgAbstimmung.json")
json_data <- fromJSON(rawToChar(res$content), flatten = TRUE)


#download.file("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20230618-eidgAbstimmung.json",
#              destfile = "Data/sd-t-17-02-20230618-eidgAbstimmung.json",
#              method = "curl")
#json_data <- fromJSON("Data/sd-t-17-02-20230618-eidgAbstimmung.json", flatten = TRUE)

res <- GET("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20230618-kantAbstimmung.json")
json_data_kantone <- fromJSON(rawToChar(res$content), flatten = TRUE)

#download.file("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20230618-kantAbstimmung.json",
#              destfile = "Data/sd-t-17-02-20230618-eidgAbstimmung.json",
#              method = "curl")
#json_data_kantone <- fromJSON("Data/sd-t-17-02-20230618-kantAbstimmung.json", flatten = TRUE)

cat("Aktuelle Abstimmungsdaten geladen\n")

#Kurznamen Vorlagen (Verwendet im File mit den Textbausteinen)
vorlagen_short <- c("OECD_Mindeststeuer","Klima_Gesetz","Covid_Gesetz")

###Kurznamen und Nummern kantonale Vorlagen
kantonal_short <- c("BE_Elternzeit","BE_Schuldenbremse","AG_Klimaschutz","AG_Taktfahrplan","SO_Zwillingsinitiative 1","SO_Zwillingsinitiative 2",
                    "JU_Autorites","FR_MHNF","VD_Climat","GE_Conge_Parental","GE_Solidarite","GE_LEFI")

#Nummer in JSON 
kantonal_number <- c(2,2,8,8,5,5,13,4,11,12,12,12) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
kantonal_add <- c(2,1,3,2,2,3,1,1,1,2,3,6)

###Kurznamen und Nummern kantonale Vorlagen Spezialfaelle
#kantonal_short_special <- c("ZH_Krankenkassen","BS_Klimagerechtigkeit")

#Nummer in JSON 
#kantonal_number_special <- c(1,4) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
#kantonal_add_special <- c(1,1)

#Spezialfälle
other_check <- FALSE

#Kantonale Vorlagen Titel
Kantonale_Vorlagen_Titel <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                          sheet = "Kantonale_Abstimmungen_Overview"))

###Vorhandene Daten laden
daten_co2_bfs <- read_excel("Data/daten_co2_bfs.xlsx",skip=5)
daten_covid1_bfs <- read_excel("Data/daten_covid1_bfs.xlsx",skip=5)
daten_covid2_bfs <- read_excel("Data/daten_covid2_bfs.xlsx",skip=5)

cat("Daten zu historischen Abstimmungen geladen\n")

#Metadaten Gemeinden und Kantone
meta_gmd_kt <- read_csv("Data/MASTERFILE_GDE.csv")

cat("Metadaten zu Gemeinden und Kantonen geladen\n")

#Datawrapper-Codes
datawrapper_codes <- as.data.frame(read_excel("Data/metadaten_grafiken.xlsx"))
datawrapper_codes_kantonal <- as.data.frame(read_excel("Data/metadaten_grafiken_kantonal.xlsx"))
datawrapper_codes_kantonal <- datawrapper_codes_kantonal[,c(1:5)]

datawrapper_auth(Sys.getenv("DW_KEY"), overwrite = TRUE)

gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}


