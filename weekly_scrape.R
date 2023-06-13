#============================ Required Libraries ==============================#
message("Load the libraries")
library(rvest)
library(mongolite)
library(stringr)
library(tidyr)

#=============================== Get The Page =================================#
message("Get the page for each month")
pages<-c()
for (j in 2015:year(Sys.Date())){
  for (i in 1:12){
    page <- paste0(
      "https://www.anisearch.com/anime/calendar/page-1?char=all&month=",
      i,
      "&year=",
      j,
      "&type=-1&region=2&view=4"
    )
    result <- data.frame(page)
    pages <- rbind(pages, result)
  }
}

#============================ Scraping Anime Data =============================#
message("Define function to scrape")
datalist <- list()
for (i in 1:nrow(pages)){ 
  # create session for each page url
  sess <- session(as.character(pages[i,1]))
  # select the parent element
  rbox_nodes <- html_nodes(sess,".btype0")
  # scrape data and stored in `anime` data frame for each loop
  anime <- rbox_nodes %>%
    map_dfr(~tibble(
      title = .x %>%
        html_element(".title") %>%
        html_text2(),
      studio = .x %>%
        html_element(".company") %>%
        html_text2(),
      types = .x %>%
        html_element(".date") %>%
        html_text2(),
      dates = .x %>%
        html_element(".header") %>%
        html_text2(),
      rate = .x%>%
        html_nodes(".rating") %>%
        html_element("div") %>%
        html_attr("title"),
      poster = paste0("https://cdn.anisearch.com/images/",
                      .x %>% html_nodes("a") %>% 
                        map(xml_attrs) %>% 
                        map_df(~as.list(.)) %>% 
                        select("data-bg"))
    )
    )
  # keep track of iteration number
  anime$loop <- i 
  # appending the new loop results to the lists of scraped data 
  datalist[[i]] <- anime
  # incrementing the iteration counter 
  i <- i + 1
}
# combine the stored data for each loop into one data frame
anime = do.call(rbind, datalist)
View(anime)

#=========================== Tidying Data Frame ===============================#
message("clean and organize the columns in anime data frame")
# New Column: Anime Type 
anime$type <- str_trim(gsub("(.*),.*", "\\1", anime$types), side="both")
# New Column: Rating (Score)
anime$score <- anime$rate %>% str_extract("\\d+\\.*\\d*")
# New Column: Rating Category (Review)
anime$review <- anime$rate %>% str_extract('\\w+$')
# New Column: Number of Episode(s)
anime$episode <- anime$types %>% str_extract("\\s*(\\d+)") %>% str_trim()
#---Separate the DD-MMM-YYYY into Multiple columns due to existing NA in date--#
# Date Column in Dataframe
anime$dates <- gsub('\\.', '', anime$dates) # eliminate unnecessary dot (.)
# Extract Year using Regex
anime$year <- anime$dates %>% str_extract('\\d{4}$')
# Extract Month using Regex
month <- str_trim(anime$dates %>% str_extract('[a-zA-Z].(\\D)+'), side="both")
anime$month = month.name[match(month, month.abb)]
# Extract Date using Regex --> Acceptable Missing Value
anime$date <- gsub('\\d*[A-Za-z]+.*', '', anime$dates)
# Drop Unadjusted Columns for Final Data Frame
anime_db <- anime %>%
  select(-c(dates, rate, types))

#============================= Connect to Database ============================#
# uncomment for local DB connection
message("Connect to MongoDB Atlas")

# ongoing_col <- mongo(
#   collection = Sys.getenv("ONGOING_COLLECTION"),
#   db         = Sys.getenv("ANIME_DATABASE"),
#   url        = Sys.getenv("ATLAS_URL")
# )

#============================= Store to Database ============================#
message("Store (Monthly Replace) data frame into mongo cloud")
# documents stored in the collection will be replaced monthly due to regular update
atlas$remove('{}')
atlas$insert(anime_db)
atlas$disconnect()
