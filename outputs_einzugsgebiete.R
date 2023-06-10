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


