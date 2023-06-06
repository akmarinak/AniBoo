# Set library ----
message("Load the libraries")
library(rvest)
library(mongolite)

# List of covid sites
# https://news.google.com/covid19/map
# https://www.worldometers.info/coronavirus/country/indonesia/
# https://corona.jakarta.go.id/id/data-pemantauan
# https://kawalcovid19.id/
# https://covid19.go.id/peta-sebaran

message("Define function to scrape OP character")
url <- "https://www.worldometers.info/coronavirus/country/indonesia/"
html <- read_html(url)
count <- html_text(html_nodes(html, ".maincounter-number"), trim=T)


message("Connect to MongoDB Cloud")
atlas <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

# covid <- data.frame(no=integer(), cases=character(), deaths=character(), recovered=character())
message("Store data frame into mongo cloud")
newcovid <- data.frame(no = atlas$count() + 1, cases = count[1], deaths = count[2], recovered = count[3])
atlas$insert(newcovid)

atlas$disconnect()
