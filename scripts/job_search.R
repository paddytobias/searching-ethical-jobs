library(tidyverse)
library(rvest)
library(RSQLite)


source("scripts/globals.R")

res = data.frame(title = as.character(), 
                 emplyr = as.character(), 
                 lnk = as.character(), 
                 due = as.character(), 
                 salary = as.character(), 
                 desc = as.character(),
                 keyword = as.character(),
                 loc = as.character(), 
                 stringsAsFactors = F)

for (j in loc_para){
  for (k in keyword){

    url = sprintf("http://www.ethicaljobs.com.au/search.html?SearchableText=%s&getLocation=%s&getWork_type=&getClassification=&sort_on=effective&review_state=published&submit=", 
                  k, j)
    
    html = read_html(url)
    results = html %>% 
      html_nodes("strong") %>% 
      html_text() %>% 
      as_tibble() %>% 
      rename("title"= "value")
    
    if (results[1,1]=="No jobs were found."){
      next
    }
    
    results$emplyr = html %>% 
      html_nodes(".documentAuthor") %>% 
      html_text()
    
    lnk = html %>% 
      html_nodes(".searchResult a") %>% 
      html_attr("href")
    
    results$lnk = lnk[seq(1, length(lnk),by = 2)]
    results$loc = j
    results$keyword = k
    results$desc = NA
    results$due = NA
    results$salary = NA
    
    for (i in 1:nrow(results)){
      url = results$lnk[i]
      html = read_html(url)
      
      results$desc[i] = html %>% 
        html_nodes("#parent-fieldname-full_description li , #parent-fieldname-full_description p") %>% 
        html_text() %>% 
        paste(collapse = "\n")
      
      job_desc = html %>% 
        html_nodes("#content > div") %>% 
        html_text() %>% 
        str_remove_all(",")
      if (!str_detect(job_desc, "Applications close\\:[[:space:]]No Deadline")){
        due_date = gsub(paste0("(.*)(Applications close\\:[[:space:]])([0-9][0-9][[:space:]][A-Za-z]+[[:space:]][[:digit:]]{4})(.*)"), "\\3", job_desc)
        results$due[i] = format(as.Date(due_date, "%d %B %Y"), "%Y-%m-%d")
        
      }
      
      if (str_detect(job_desc, "Salary:[[:space:]]\\$")){
        results$salary[i] = gsub("(.*)(Salary:[[:space:]])(\\$[[:digit:]]{3,6})(.*)", "\\3", job_desc)
      }
      
    }
    res = rbind(res, results, stringsAsFactors = F)
    Sys.sleep(5)
  }
}


