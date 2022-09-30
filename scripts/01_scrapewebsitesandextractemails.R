# Libraries
library(Rcrawler)
library(stringr)
library(dplyr)

# Load website data
load(file="data/smpl_rmng")
websites = smpl_rmng$Website.address.

# Step 1: Scrape html versions of the websites. Html preserves the most information and allows us to extract email addresses via regEx with relatively little noise. For this example, I only run this for the first 100 websites in the dataset. Running it for the whole dataset takes >20 hours.
# I only scrape one level deep from the starting page (i.e., every link on the starting page and their content). If necessary, MaxDepth can be increased to get more information. 

for (i in 97:length(websites[1:100])){ 
  print(paste0("Nr:", i, "; website: ", websites[i]))
  tryCatch({
    Rcrawler(Website =websites[i], no_cores = 6, no_conn = 6, MaxDepth = 1, Timeout = 3, URLlenlimit = 80 ,DIR = "./data/scraped")
  }, error = function(e){cat("ERROR: ", conditionMessage(e), "\n")})
}

# Step 2: Extract email addresses via RegEx. The loop iterates through the directory and extracts email address patterns. However, as there is a lot of noise (CSS and HTML code sometimes has similar patterns such as scb@pixel266.ide, which we want to avoid)
folders.website <- data.frame(list.files("./data/scraped"), stringsAsFactors = F)
results <- list(list())
recommended.emails <- list()

for(i in 1:nrow(folders.website)){ 
  tryCatch({
    print(paste("Next Website:", folders.website[i,]))
    files.html <- data.frame(list.files(paste0("./data/scraped/",folders.website[i,])))
    print(paste(nrow(files.html), "files in folder"))
    URL <- as.character(folders.website[i,])
    for (l in 1:nrow(files.html)){
      print(paste(folders.website[i,],": Searching in", files.html[l,]))
      rawHTML <- paste(readLines(paste0("./data/scraped/", folders.website[i,],"/", files.html[l,])), collapse="\n")
      results[[URL]][l] <- as.data.frame(str_extract_all(rawHTML, "[a-zA-Z][a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+"))
    }
    temporary.stash <- as.data.frame(unlist(results[[URL]]))
    names(temporary.stash)[1] <- "emails"
    most_probable <- temporary.stash%>%
      count(emails)%>%
      top_n(3,n)
    most_probable <- most_probable[1:10,]
    recommended.emails[[URL]] <- most_probable[order(most_probable$n, decreasing = T),]
    print("Generating CSV")
    write.csv(temporary.stash, file = paste0("./data/scraped/extracted/", folders.website[i,],"_emails.csv"))
    print("Done")
  }, error = function(e){cat("ERROR: ", conditionMessage(e), "\n")}
  , warning = function(e){cat("Warning: ", conditionMessage(e), "\n")})
}

save(recommended.emails, file="data/smpl_emails")
