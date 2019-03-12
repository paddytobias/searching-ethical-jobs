library(gmailr)
library(kableExtra)
library(formattable)
library(DBI)
library(RSQLite)
library(tidyverse)

source("scripts/globals.R")

con = dbConnect(SQLite(), "database/job.db")
q = sprintf("SELECT title, emplyr, lnk, loc, keyword, due, score FROM job
    WHERE date='%s' and lnk not in (select lnk from job where date!='%s')", Sys.Date(), Sys.Date())

jobs = tbl(con, sql(q)) %>% 
  collect() %>% 
  mutate(title = text_spec(title, link = lnk),
         title = paste(title, emplyr, sep = "\n"),
         key = paste(loc, keyword, sep = ": ")) %>% 
  select(-c(lnk, loc, keyword, emplyr))  %>% 
  arrange(due) %>% 
  mutate(due = format(as.Date(due), "%d %b")) %>% 
  mutate(score = color_tile("white", "lightgreen")(score)) 

if (nrow(jobs) > 0){
  jobs = jobs %>% 
    kable(escape = F) %>% 
    kableExtra::kable_styling()
  
  msg = mime(To = email_to, 
             Subject = email_subject) %>%  
    html_body(jobs)
  
  send_message(msg)
}

