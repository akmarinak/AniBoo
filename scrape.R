#==================== Set library ====================#
message("Load the libraries")
library(rvest)
library(mongolite)
library(stringr)

#==================== Anime Sites ====================#
# https://anidb.net/anime/schedule

#=================== Scraping Code ===================#
message("Define function to scrape OP character")
url <- "https://anidb.net/anime/schedule"
html <- read_html(url)

anime_today <- html %>%
  html_element(".g_section.content.today") %>%
  html_elements(".name-colored") %>%
  html_text() %>% c()

date_today <- html %>%
  html_element(".g_section.content.today") %>%
  html_elements(".v_high") %>%
  html_text()

title <- str_trim(gsub(" - [0-9]*$", " ", anime_today), side="both")
episode <- str_trim(sub(".*-", "", anime_today), side="both")
date <- gsub("(.*),.*", "\\1", date_today)

anime_timetable <- data.frame(date = date, 
                              title = title, 
                              episode = episode)
#================ Connect to Database ================#
# uncomment for cloud DB connection
message("Connect to MongoDB Cloud")
collection <- "ongoing"
db <- "anime"
url <- "mongodb://localhost:27017/"
atlas <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

#=============== Store into Dataframe ================#
message("Store data frame into mongo cloud")
today <- data.frame(anime_timetable)
atlas$insert(today)
atlas$disconnect()
