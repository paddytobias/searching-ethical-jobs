library(DBI)
if (!exists("res")){
  source("scripts/post_process.R")
}

if ("./database/" %in% list.dirs()){
  dir.create("database/")
}


con = dbConnect(SQLite(), "database/job.db")
dbWriteTable(con, name = "job", res_processed, append = T)
