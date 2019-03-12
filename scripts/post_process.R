library(stringr)

if (!exists("res")){
  source("scripts/job_search.R")
}


res_processed = res %>% 
  mutate(R = str_count(.$desc, "\bR\b"), 
         Py = str_count(.$desc, "\bPython\b"), 
         Sql = str_count(.$desc, "\bSQL\b|\bdatabase\b"), 
         db = str_count(.$desc, "database")) %>% 
  gather("skill", "value", c(R, Py, Sql, db)) %>% 
  group_by(title, emplyr, lnk, loc, keyword, desc, due, salary) %>% 
  summarise(score = mean(value)) %>% 
  mutate(date = as.character(Sys.Date()))


