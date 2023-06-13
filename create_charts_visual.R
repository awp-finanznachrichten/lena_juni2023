library(rsvg)
library(magick)
library(DatawRappr)
library(zip)
library(RCurl)

#Working Directory definieren
setwd("C:/Users/sw/OneDrive/LENA_Project/20230618_LENA_Abstimmungen")

###Config: Bibliotheken laden, Pfade/Links definieren, bereits vorhandene Daten laden
source("config.R",encoding = "UTF-8")
source("functions_readin.R", encoding = "UTF-8")

#Vorlagen Codes
vorlage_gemeinde <- c("kDkMR","5NIK3","Idw6B")
vorlage_kantone <- c("Tfr6N","qI7hZ","GAF2u")

#Ordner Codes
folder_de <- "117142"
folder_fr <- "117143"
folder_it <- "117144"

#Datum
datum_de <- "18. Juni 2023"
datum_fr <- "18 juin 2023"
datum_it <- "18 percentuale sì 2023"

#Vorlagen einlesen und Klammern entfernen
##Deutsch
vorlagen <- get_vorlagen(json_data,"de")
vorlagen$text[1] <- "Abstimmung über OECD-Mindeststeuer (Verfassungsänderung)"
vorlagen$text[2] <- "Abstimmung über Klimagesetz (Referendum)"
vorlagen$text[3] <- "Abstimmung über Covid-19-Gesetz (Referendum)"

#Französisch
vorlagen_fr <- get_vorlagen(json_data,"fr")
vorlagen_fr$text[1] <- "Réforme de l'imposition minimale selon les standards de l'OCDE"
vorlagen_fr$text[2] <- "Loi sur le climat"
vorlagen_fr$text[3] <- "Modification de la loi sur le Covid"

vorlagen_it <- get_vorlagen(json_data,"it")

vorlagen$text <- str_replace(vorlagen$text, "\\s*\\([^\\)]+\\)", "")
vorlagen_fr$text <- str_replace(vorlagen_fr$text, "\\s*\\([^\\)]+\\)", "")
vorlagen_it$text <- str_replace(vorlagen_it$text, "\\s*\\([^\\)]+\\)", "")

for (i in 1:length(vorlagen_short) ) {

#Nationale Ergebnisse holen
results_national <- get_results(json_data,i,level="national")
Ja_Anteil <- round(results_national$jaStimmenInProzent,1)
Nein_Anteil <- round(100-results_national$jaStimmenInProzent,1)
Stimmbeteiligung <- round(results_national$stimmbeteiligungInProzent,1)
Staende_Ja <- results_national$jaStaendeGanz+(results_national$jaStaendeHalb/2)
Staende_Nein <- results_national$neinStaendeGanz+(results_national$neinStaendeHalb/2)


#####DEUTSCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen$text[i]
undertitel_text <- paste0("<b>Eidgenössische Volksabstimmung vom ",datum_de,"</b>")

#Undertitel Balken
length_yes <- round(Ja_Anteil/5)
length_no <- round(Nein_Anteil/5)
length_stimmbeteiligung <- round(Stimmbeteiligung/5)
length_Staende_Ja <- round(((Staende_Ja*100)/23)/5)
length_Staende_Nein <- round(((Staende_Nein*100)/23)/5)

undertitel_balken_firstline <- paste0('<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",30),
                                      "</b><b>Volk</b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",60),
                                      "</b><b>Stände</b>"
                                      )

undertitel_balken_secondline <- paste0(strrep("&nbsp;",8),
                                       "Ja ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% Nein",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",10),"</b>",
                                       "Ja ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," Nein"
                                       )

undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('Ja 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'Ja 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 Nein',
                       '0px"></b> 0 Nein',
                       undertitel_all)



footer <- paste0('Quelle: BFS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",28),
                 "</b>Stand: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Grafik: Keystone-SDA"
                 )

###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_kantone[1])

chart_metadata <- dw_retrieve_chart_metadata(new_chart$id)

adapted_list <- chart_metadata[["content"]][["metadata"]][["visualize"]]
adapted_list$`text-annotations`[[1]]$text <- gsub("#voters",paste0(gsub("[.]",",",Stimmbeteiligung),"%"),adapted_list$`text-annotations`[[1]]$text)

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              intro=undertitel_all,
              visualize=adapted_list,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              folderId = folder_de)

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_DE")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als SVG &  EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)


#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom ",datum_de," - ",titel,". Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=Die Infografik kann im Grafikformat EPS und SVG bezogen werden. Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_DEU.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")

###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_gemeinde[1])

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              folderId = folder_de)


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_DE")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN GEMEINDEN ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom ",datum_de," Resultate Gemeinden - ",titel,". Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=Die Infografik kann im Grafikformat EPS und SVG bezogen werden. Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_DEU.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")

#####FRANZÖSISCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen_fr$text[i]
undertitel_text <- paste0("<b>Votation populaire du ",datum_fr,"</b>")


undertitel_balken_firstline <- paste0('<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",20),
                                      "</b><b>Majorité du peuple</b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",35),
                                      "</b><b>Majorité des Cantons</b>"
)

undertitel_balken_secondline <- paste0(strrep("&nbsp;",8),
                                       "Oui ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% Non",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",10),"</b>",
                                       "Oui ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," Non"
)


undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('Oui 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'Oui 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 Non',
                       '0px"></b> 0 Non',
                       undertitel_all)

#Stimmbeteiligung
footer <- paste0('Source: OFS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",30),
                 "</b>Etat: ",format(Sys.time(),"%d.%m.%Y %Hh%M"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",22),
                 "</b>Infographie: Keystone-ATS"
                 )
###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_kantone[2])

chart_metadata <- dw_retrieve_chart_metadata(vorlage_kantone[2])

adapted_list <- chart_metadata[["content"]][["metadata"]][["visualize"]]
adapted_list$`text-annotations`[[1]]$text <- gsub("#voters",paste0(gsub("[.]",",",Stimmbeteiligung),"%"),adapted_list$`text-annotations`[[1]]$text)

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="fr-CH",
              intro=undertitel_all,
              visualize=adapted_list,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              visualize = list("legend"=list("title"="pourcentage de oui")),
              folderId = folder_fr)

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_FR")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SUISSE VOTATION POPULAIRE ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votation populaire du ",datum_fr," - ",titel,". Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infographie peut être obtenue aux formats graphiques EPS et SVG. Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_FR.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")


###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_gemeinde[2])

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="fr-CH",
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              visualize = list("legend"=list("title"="pourcentage de oui")),
              folderId = folder_fr)


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_FR")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SUISSE VOTATION POPULAIRE COMMUNES ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votation populaire du ",datum_fr," - ",titel,". Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infographie peut être obtenue aux formats graphiques EPS et SVG. Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen

zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_FR.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")


#####ITALIENISCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen_it$text[i]
undertitel_text <- paste0("<b>Votatzione popolare del ",datum_it,"</b>")

undertitel_balken_firstline <- paste0('<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",28),
                                      "</b><b>Popolo</b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",58),
                                      "</b><b>Cantoni</b>"
)

undertitel_balken_secondline <- paste0(strrep("&nbsp;",8),
                                       "sì ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% no",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",17),"</b>",
                                       "sì ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," no"
)

undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('sì 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'sì 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 no',
                       '0px"></b> 0 no',
                       undertitel_all)


#Stimmbeteiligung
block_stimmbeteiligung <- paste0('<b>Tasso di partecipazione</b><br>',
                                 '<b style="background:	#FFFFFF; color:black; padding:1px 3px">',
                                 strrep("&nbsp;",6),"</b>",
                                 '<b style="background:	#696969; color:black; padding:1px 6px">',
                                 strrep("&nbsp;",length_stimmbeteiligung),"</b>",
                                 '<b style="background:		#DCDCDC; color:black; padding:1px 6px">',
                                 strrep("&nbsp;",20-length_stimmbeteiligung),"</b><br>",
                                 strrep("&nbsp;",16),
                                 gsub("[.]",",",Stimmbeteiligung),"%")
block_stimmbeteiligung
footer <- paste0('Fonte: UTS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",32),
                 "</b>Stato: ",format(Sys.time(),"%d.%m.%Y %Hh%M"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Infografica: Keystone-ATS"
                 )

###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_kantone[3])

chart_metadata <- dw_retrieve_chart_metadata(vorlage_kantone[3])

adapted_list <- chart_metadata[["content"]][["metadata"]][["visualize"]]
adapted_list$`text-annotations`[[1]]$text <- gsub("#voters",paste0(gsub("[.]",",",Stimmbeteiligung),"%"),adapted_list$`text-annotations`[[1]]$text)

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="it-CH",
              intro=undertitel_all,
              visualize=adapted_list,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              visualize = list("legend"=list("title"="percentuale sì")),
              folderId = folder_it)

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_IT")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als SVG und EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SVIZZERA VOTATZIONE POPOLARE ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votatzione popolare del ",datum_it," - ",titel,". Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infografica può essere ottenuta nei formati grafici EPS e SVG. Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_IT.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")


###Vorlage kopieren
new_chart <-dw_copy_chart(vorlage_gemeinde[3])


#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="it-CH",
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_",tolower(abstimmung_date),"/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              visualize = list("legend"=list("title"="percentuale sì")),
              folderId = folder_it)

metadata <- dw_retrieve_chart_metadata(new_chart$id)


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_IT")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SVIZZERA VOTATZIONE POPOLARE COMUNI ",toupper(titel),"\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votatzione popolare del ",datum_it," - ",titel,". Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infografica può essere ottenuta nei formati grafici EPS e SVG. Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_IT.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Chart löschen
dw_delete_chart(new_chart$id)

setwd("..")
setwd("..")


}
