# Searching for ethical jobs

This program is designed to run on a daily basis to poll Ethical Jobs and collect all jobs for a given search. 

The program relies on an SQLite database (which is initiated the first time the program is run) then emails the latest list of jobs. 

If you wish to use this program yourself, you need to save *your* parameters to the `scripts/globals.R` file (the program's written in a way that the search terms are flexible). You will also need to enable the API for your gmail account, from which the emails will be sent. 

There is some logic in terms of scoring the jobs according to mentions of particular things in their descriptions (see `post_process.R`). Feel free to change these string counts to what ever you want. 

You can do what I have done and set this up in cronjobs. To run the program just run `bash run.sh`

## Dependencies
* R and R packages
* Unix

 
