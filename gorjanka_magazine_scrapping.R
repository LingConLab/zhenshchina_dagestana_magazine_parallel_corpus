library(tidyverse)
library(rvest)
# create folder for each language (if the one does not exist yet)
langs <- c('rus','avar','kumyk','tabas','lezg','lak','darg')

for (lang in langs){
  if (!dir.exists(lang)) {dir.create(lang)}
}

## loop through the pages and collect links to pdfs
#https://xn--80aaaanefedv8cbg8cp7h.xn--p1ai/edition_archive_x #initial page
#https://xn--80aaaanefedv8cbg8cp7h.xn--p1ai/edition_archive_x?page=1 #suffixed next page

# def function to download pdf
download = function(link,language,issue_volume){
  if (str_detect(link,language)){
    
    # unify names of issues
    issue_volume = str_remove_all(issue_volume,"[:alpha:]+")
    issue_volume = str_remove_all(issue_volume,"[№\\.,\\(\\)]")
    
    issue_volume = str_replace_all(issue_volume,"[/-]","_")
    issue_volume = str_replace_all(issue_volume,"\\s+","_")
    issue_volume = str_replace_all(issue_volume,"_+","_")
    issue_volume = str_remove_all(issue_volume,"^_")
    issue_volume = str_remove_all(issue_volume,"_$")
    issue_volume = str_squish(issue_volume)
    
    #place the volume after the year
    issue_volume = ifelse(str_detect(issue_volume,"^(\\d_|\\d_\\d_)(\\d{4})$"),
      str_replace_all(issue_volume,"^(\\d_|\\d_\\d_)(\\d{4})$",
                                   "\\2_\\1"), issue_volume)
    issue_volume = str_remove_all(issue_volume,"_$")

    if (!file.exists(paste0(language,"/",paste0(language,"_",issue_volume),".pdf"))){
      
      download.file(link,paste0(language,"/",paste0(language,"_",issue_volume),".pdf"), mode="w")}
  }
}



for (page in c("","?page=1","?page=2","?page=3")){ #add more pages in the future if needed
  gorjanka_arxiv_page <- read_html(paste0("https://xn--80aaaanefedv8cbg8cp7h.xn--p1ai/edition_archive_x",page))
  # find nodes with an issue mini-archive
  list_of_desc <- gorjanka_arxiv_page %>% html_nodes("[class='edition_desc']")

    for (issue in list_of_desc){
    # названия мини-архивов
    volume <- issue %>% html_nodes("[class='edition_title']") %>% html_text()
    # ссылки внутри мини-архивов
    pdf_links <- issue %>% html_elements("a") %>% html_attr('href')
    
    for (link in pdf_links){
      for (lang in langs){
        download(link,lang,volume)
      }
    }
  }
} 

####  extra troubleshooting and notes
# one Russian issue has a different pattern for .pdf download link, do it manually:
rus_link = "http://xn--80aaaanefedv8cbg8cp7h.xn--p1ai/sites/default/files/jendag_editions/selection.pdf"
if (!file.exists("rus/rus_2017_2.pdf")){
  download.file(rus_link,"rus/rus_2017_2.pdf", mode="w")}

## On the archive page something was messed up with № 5 - 2021 [by the state at 18.06.2023]
# There is a lezgin version instead of tabasaran: # 5_lezginskiy_5.pdf">Дагъустан дишагьли (Табас. яз.)
# The lezgin numeration was also messed up for this issue but it is not crucial: # 5_lezginskiy_4.pdf">Дагъустандин дишегьли (Лезг. яз.)

# In other words, we don't have a tabasarn issue: _2021_5


## "lezg_2017_1.pdf" can not be downloaded properly
# delete this broken file
file.remove(paste0(getwd(),"/lezg/","lezg_2017_1.pdf"))


