###Output generieren für Datawrapper Pilatus Today
output_dw_zentralschweiz <- results[results$Kanton_Short == "LU" |
                                      results$Kanton_Short == "SZ" |
                                      results$Kanton_Short == "OW" |
                                      results$Kanton_Short == "NW" |
                                      results$Kanton_Short == "ZG" |
                                      results$Kanton_Short == "UR" ,
                                      #results$Gemeinde_Nr < 15,
                                    ]

output_dw_zentralschweiz_kantone <- get_output_kantone(output_dw_zentralschweiz)
output_dw_zentralschweiz <- get_output_gemeinden(output_dw_zentralschweiz)

write.csv(output_dw_zentralschweiz,paste0("Output/",vorlagen_short[i],"_dw_pilatustoday.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
write.csv(output_dw_zentralschweiz_kantone,paste0("Output/",vorlagen_short[i],"_dw_pilatustoday_kantone.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper FM1-Today
output_dw_FM1_today <- results[results$Kanton_Short == "SG" |
                                results$Kanton_Short == "TG" |
                                results$Kanton_Short == "GR" |
                                results$Kanton_Short == "AI" |
                                results$Kanton_Short == "AR",]

output_dw_FM1_today <- get_output_gemeinden(output_dw_FM1_today)
write.csv(output_dw_FM1_today,paste0("Output/",vorlagen_short[i],"_dw_FM1_today.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper ZOL
output_dw_ZOL <- results %>%
  filter(Gemeinde_Nr %in% 111:121 |
           Gemeinde_Nr %in% 171:200 |
           Gemeinde_Nr == 226 |
           Gemeinde_Nr == 228 |
           Gemeinde_Nr == 231 |
           Gemeinde_Nr == 296 |
           Gemeinde_Nr == 297)

output_dw_ZOL <- get_output_gemeinden(output_dw_ZOL)
write.csv(output_dw_ZOL,paste0("Output/",vorlagen_short[i],"_dw_ZOL.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

#Output generieren für Nau.ch
output_dw_NAU_Bern <- results[results$Kanton_Short == "BE" |
                                 results$Kanton_Short == "FR",]

output_dw_NAU_Bern <- get_output_gemeinden(output_dw_NAU_Bern)
write.csv(output_dw_NAU_Bern,paste0("Output/",vorlagen_short[i],"_dw_NAU_Bern.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

output_dw_NAU_Basel <- results[results$Kanton_Short == "BS" |
                                results$Kanton_Short == "FL",]

output_dw_NAU_Basel <- get_output_gemeinden(output_dw_NAU_Basel)
write.csv(output_dw_NAU_Basel,paste0("Output/",vorlagen_short[i],"_dw_NAU_Basel.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

output_dw_NAU_Mittelland <- results[results$Kanton_Short == "AG" |
                                 results$Kanton_Short == "SO",]

output_dw_NAU_Mittelland <- get_output_gemeinden(output_dw_NAU_Mittelland)
write.csv(output_dw_NAU_Mittelland,paste0("Output/",vorlagen_short[i],"_dw_NAU_Mittelland.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")


output_dw_NAU_Ostschweiz <- results[results$Kanton_Short == "SG" |
                                 results$Kanton_Short == "TG" |
                                 results$Kanton_Short == "GL" |
                                 results$Kanton_Short == "AI" |
                                 results$Kanton_Short == "AR"|
                                 results$Kanton_Short == "SH",]


output_dw_NAU_Ostschweiz <- get_output_gemeinden(output_dw_NAU_Ostschweiz)
write.csv(output_dw_NAU_Ostschweiz,paste0("Output/",vorlagen_short[i],"_dw_NAU_Ostschweiz.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")




