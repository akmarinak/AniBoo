#============================= Required Libraries =============================#
message("Load the libraries")
library(rvest)
library(mongolite)
library(stringr)
library(ggplot2)
library(tidyr)
library(plyr)
library(stringr)

#=============================== Anime Sites ===================================#
url1 = "https://anidb.net/anime/schedule"
url2 = "https://myanimelist.net/topanime.php?type=airing"
url3 = "https://myanimelist.net/topanime.php?type=upcoming"
url4 = "https://myanimelist.net/topanime.php?type=tv"
url5 = "https://myanimelist.net/topanime.php?type=movie"

#============================ Scraping Anime Data =============================#
message("Define function to scrape")
html1 <- read_html(url1)
html2 <- read_html(url2)
html3 <- read_html(url3)
html4 <- read_html(url4)
html5 <- read_html(url5)

#----------------------------Anime Daily Timetable-----------------------------#
anime_today <- html1 %>%
  html_element(".g_section.content.today") %>%
  html_elements(".name-colored") %>%
  html_text() %>% c()

date <- html1 %>%
  html_element(".g_section.content.today") %>%
  html_elements(".v_high") %>%
  html_text()

today_title <- str_trim(gsub(" - [0-9]*$", " ", anime_today), side="both")
today_episode <- str_trim(sub(".*-", "", anime_today), side="both")
today_date <- gsub("(.*),.*", "\\1", date)
today_poster <- html1 %>%
  html_nodes(".g_section.content.today") %>%
  html_nodes(".g_image.g_bubble.thumb") %>%
  html_attr("src")

anime_timetable <- data.frame(date = today_date, 
                              title = today_title, 
                              episode = today_episode,
                              poster = gsub("-thumb.jpg", "", today_poster))

#-------------------------------Top Airing Anime-------------------------------#
airing <- html2 %>%
  html_nodes('.top-ranking-table') %>%
  html_table(header=TRUE) %>% as.data.frame()

poster1 <- html2 %>%
  html_nodes(".ranking-list") %>% 
  html_nodes("img") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.))

poster1= separate(poster1, col="data-srcset", 
                 into=c('small-size', '1x', 'poster', '2x'), 
                 sep=' ') %>% select("poster")

airing = cbind(airing, poster1)

airing <- separate(airing, col=Title, into=c('anime_title', 'num_of_eps', 
                                             'airing_date', 'num_of_members'), 
                   sep='\n')
top_airing <- airing %>% select(-c("Your.Score", "Status", "num_of_members"))
cols <- colnames(top_airing)
top_airing[, cols] <- colwise(str_trim)(top_airing[, cols]) 

#----------------------------------Top Upcoming--------------------------------#
upcoming <- html3 %>%
  html_nodes('.top-ranking-table') %>%
  html_table(header=TRUE) %>% as.data.frame()

poster2 <- html3 %>%
  html_nodes(".ranking-list") %>% 
  html_nodes("img") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.))

poster2 <- separate(poster2, col="data-srcset", 
                 into=c('small-size', '1x', 'poster', '2x'), 
                 sep=' ') %>% select("poster")

upcoming <- cbind(upcoming, poster2)

upcoming <- separate(upcoming, col=Title, into=c('anime_title', 'num_of_eps', 
                                             'airing_date', 'num_of_members'), 
                   sep='\n')

top_upcoming <- upcoming %>% select(-c("Your.Score", "Status", 
                                       "Score", "num_of_members"))
top_upcoming[, setdiff(cols, "Score")] <- 
  colwise(str_trim)(top_upcoming[, setdiff(cols, "Score")])

#---------------------------------Top TV Series--------------------------------#
tv <- html4 %>%
  html_nodes('.top-ranking-table') %>%
  html_table(header=TRUE) %>% as.data.frame()

poster3 <- html4 %>%
  html_nodes(".ranking-list") %>% 
  html_nodes("img") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.))

poster3 <- separate(poster3, col="data-srcset", 
                    into=c('small-size', '1x', 'poster', '2x'), 
                    sep=' ') %>% select("poster")

tv <- cbind(tv, poster3)

tv <- separate(tv, col=Title, into=c('anime_title', 'num_of_eps', 
                                                 'airing_date', 'num_of_members'), 
                     sep='\n')
top_tv <- tv %>% select(-c("Your.Score", "Status", "num_of_members"))
top_tv[, cols] <- colwise(str_trim)(top_tv[, cols])

#-----------------------------------Top Movies---------------------------------#
movie <- html5 %>%
  html_nodes('.top-ranking-table') %>%
  html_table(header=TRUE) %>% as.data.frame()

poster4 <- html5 %>%
  html_nodes(".ranking-list") %>% 
  html_nodes("img") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.))

poster4 <- separate(poster4, col="data-srcset", 
                    into=c('small-size', '1x', 'poster', '2x'), 
                    sep=' ') %>% select("poster")

movie <- cbind(movie, poster4)

movie <- separate(movie, col=Title, into=c('anime_title', 'num_of_eps', 
                                     'airing_date', 'num_of_members'), 
               sep='\n')
top_movie <- movie %>% select(-c("Your.Score", "Status", "num_of_members"))
top_movie[, cols] <- colwise(str_trim)(top_movie[, cols])

#=========================== Connect to Database ==============================#
# Local DB Connection
ongoing_col <- mongo(
  collection = "ongoing",
  db         = "anime",
  url        = "mongodb://localhost:27017/"
)

topair_col <- mongo(
  collection = "top_airing",
  db         = "anime",
  url        = "mongodb://localhost:27017/"
)

topup_col <- mongo(
  collection = "top_upcoming",
  db         = "anime",
  url        = "mongodb://localhost:27017/"
)

toptv_col <- mongo(
  collection = "top_tv",
  db         = "anime",
  url        = "mongodb://localhost:27017/"
)

topmov_col <- mongo(
  collection = "top_movie",
  db         = "anime",
  url        = "mongodb://localhost:27017/"
)

# Cloud DB connection
message("Connect to MongoDB Atlas")

ongoing_col <- mongo(
  collection = Sys.getenv("ONGOING_COLLECTION"),
  db         = Sys.getenv("ANIME_DATABASE"),
  url        = Sys.getenv("ATLAS_URL")
)

topair_col <- mongo(
  collection = Sys.getenv("TOPAIRING_COLLECTION"),
  db         = Sys.getenv("ANIME_DATABASE"),
  url        = Sys.getenv("ATLAS_URL")
)

topup_col <- mongo(
  collection = Sys.getenv("TOPUPCOMING_COLLECTION"),
  db         = Sys.getenv("ANIME_DATABASE"),
  url        = Sys.getenv("ATLAS_URL")
)

toptv_col <- mongo(
  collection = Sys.getenv("TOPTV_COLLECTION"),
  db         = Sys.getenv("ANIME_DATABASE"),
  url        = Sys.getenv("ATLAS_URL")
)

topmov_col <- mongo(
  collection = Sys.getenv("TOPMOVIE_COLLECTION"),
  db         = Sys.getenv("ANIME_DATABASE"),
  url        = Sys.getenv("ATLAS_URL")
)

#=========================== Store into Dataframe =============================#
message("Store data frame into mongo cloud")
# Ongoing Collection
ongoing_col$insert(anime_timetable)
# Top Airing Collection
topair_col$remove('{}')
topair_col$insert(top_airing)
# Top Upcoming Collection
topup_col$remove('{}')
topup_col$insert(top_upcoming)
# Top TV Series Collection
toptv_col$remove('{}')
toptv_col$insert(top_tv)
# Top Movie Collection
topmov_col$remove('{}')
topmov_col$insert(top_movie)

#============================ Disconnect Database =============================#
# Disconnect from each collection
ongoing_col$disconnect()
topair_col$disconnect()
topup_col$disconnect()
toptv_col$disconnect()
topmov_col$disconnect()
