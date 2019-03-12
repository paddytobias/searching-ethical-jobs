library(DBI)
if (!exists("res")){
  source("scripts/post_process.R")
}

con = dbConnect(SQLite(), "database/job.db")
dbWriteTable(con, name = "job", res_processed, append = T)
