source("./top_flop/helpers-2144679.R")


#Update data top_flop_fr
ocde_top_fr <- top_flop(ocde,"top","fr")
climat_top_fr <- top_flop(climat,"top","fr")
covid_top_fr <- top_flop(covid,"top","fr")

ocde_flop_fr <- top_flop(ocde,"flop","fr")
climat_flop_fr <- top_flop(climat,"flop","fr")
covid_flop_fr <- top_flop(covid,"flop","fr")


#OCDE TOP
chart_metadata <- dw_retrieve_chart_metadata("RfbP9")
intro_text_fr <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "w5mAf"

dw_data_to_chart(ocde_top_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus favorables à  l'imposition des grandes entreprises selon les standards de l'OCDE",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)

#OCDE FLOP
chart_ID <- "rcSEC"

dw_data_to_chart(ocde_flop_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus opposées à  l'imposition des grandes entreprises selon les standards de l'OCDE",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)


#Climat
#TOP 
chart_metadata <- dw_retrieve_chart_metadata("Px2XF")
intro_text_fr <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "kT6nB"

dw_data_to_chart(climat_top_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus favorables à la loi sur le climat",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "q30wD"

dw_data_to_chart(climat_flop_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus opposées à la loi sur le climat",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#COVID
#TOP
chart_metadata <- dw_retrieve_chart_metadata("zpWBd")
intro_text_fr <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "H8K9m"

dw_data_to_chart(covid_top_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus favorables à la modification de la loi Covid",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "sd3Ky"

dw_data_to_chart(covid_flop_fr,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_fr,
              title = "Les communes les plus opposées à la modification de la loi Covid",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)
