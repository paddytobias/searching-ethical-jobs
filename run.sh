# first do the webscrape and insert into DB, then query DB for latest jobs and email
/usr/local/bin/Rscript scripts/dbinsert.R && /usr/local/bin/Rscript scripts/send_email.R


