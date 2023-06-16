<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/anime.png" alt="Logo" width="180">
  </a>

  <h1 align="center">AniBoo</h1>
  <br />
  
  [![Daily Scraping Anime Data](https://github.com/akmarinak/anime_schedule/actions/workflows/daily_scrape.yml/badge.svg)](https://github.com/akmarinak/anime_schedule/actions/workflows/daily_scrape.yml)
  
  [![Weekly Scraping Anime Data](https://github.com/akmarinak/anime_schedule/actions/workflows/weekly_scrape.yml/badge.svg)](https://github.com/akmarinak/anime_schedule/actions/workflows/weekly_scrape.yml)
  
  <h3 align="center">A Curated Anime Information for You:Weeaboo!</h3>

  <p align="center">
    <br />
    <a href="https://github.com/akmarinak/anime_schedule/issues">View Dashboard</a>
    ·
    <a href="https://github.com/akmarinak/anime_schedule/issues">Report Issues</a>
    <br />
  </p>
</div>


## About The Project
This is a **Dashboard** for you -_weeaboo_ to track and monitor The **Released** and **Upcoming** Anime Information. Real-time data from multiple sources were combined to support this dashboard.
This project integrate R for data scraping, MongoDb for data storage, and Shiny for data display. 
Anime Airing Schedule, and Top Rated Anime in Some Categories were scrapped daily from [AniDB](https://anidb.net/anime/schedule) and [MyAnimeList](https://myanimelist.net). Anime Information from 2015 - present are available with weekly update. Collected data is stored in MongoDB and then shown in ShinyApp.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [![mongodb][mongodb-shield]][mongodb-url]
* [![R][r-shield]][r-url]
* [![R-Shiny][shiny-shield]][shiny-url]



<!-- LICENSE -->
## License

Distributed under the Creative Common License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Akmarina Khairunnisa - akmarinakhairunnisa@gmail.com

Project Link: [https://github.com/akmarinak/anime_schedule](https://github.com/akmarinak/anime_schedule)

<p align="right">(<a href="#readme-top">back to top</a>)</p>




<p align="right">(<a href="#readme-top">back to top</a>)</p>


# Document Sample

## Anime Information Database - Weekly Update

```
{
  "title": "Durarara!! ×2 The First Arc",
  "studio": "Shuka Inc.",
  "poster": "https://cdn.anisearch.com/images/anime/cover/full/9/9542.webp",
  "loop": 1,
  "type": "TV-Series",
  "score": "3.88",
  "review": "Excellent",
  "episode": "12",
  "year": "2015",
  "month": "January",
  "date": "10 "
}
```

## Airing Anime Schedule - Daily Update

```
{
  "_id": {
    "$oid": "6489c448b4c481f9a90e1751"
  },
  "date": "2023-06-14",
  "title": "\"Oshi no Ko\"",
  "episode": "9",
  "poster": "https://cdn-us.anidb.net/images/65/287142.jpg"
}
```
## Top 50 Ongoing/Airing Anime - Daily Update
```
{
  "_id": {
    "$oid": "6489c448b4c481f9a90e175f"
  },
  "Rank": "5",
  "anime_title": "Kimetsu no Yaiba: Katanakaji no Sato-hen",
  "num_of_eps": "TV (11 eps)",
  "airing_date": "Apr 2023 - Jun 2023",
  "Score": "8.55",
  "poster": "https://cdn.myanimelist.net/r/100x140/images/anime/1765/135099.jpg?s=33760896bd2bec983337081f7da9e147"
}
```

## Top 50 Anime Movie - Daily Update
```
{
  "_id": {
    "$oid": "6489c448b4c481f9a90e17fb"
  },
  "Rank": "11",
  "anime_title": "Howl no Ugoku Shiro",
  "num_of_eps": "Movie (1 eps)",
  "airing_date": "Nov 2004 - Nov 2004",
  "Score": "8.66",
  "poster": "https://cdn.myanimelist.net/r/100x140/images/anime/5/75810.jpg?s=a6c1acf59965f7e50ac637d018a734f0"
}
```

## Top 50 Anime TV Series - Daily Update
```
{
  "_id": {
    "$oid": "6489c448b4c481f9a90e17bf"
  },
  "Rank": "1",
  "anime_title": "Fullmetal Alchemist: Brotherhood",
  "num_of_eps": "TV (64 eps)",
  "airing_date": "Apr 2009 - Jul 2010",
  "Score": "9.1",
  "poster": "https://cdn.myanimelist.net/r/100x140/images/anime/1208/94745.jpg?s=5ec18639199f2c60b60009f34222228d"
}
```

## Top 50 Upcoming Anime - Daily Update
```
{
  "_id": {
    "$oid": "6489c448b4c481f9a90e178d"
  },
  "Rank": "1",
  "anime_title": "Jujutsu Kaisen 2nd Season",
  "num_of_eps": "TV (? eps)",
  "airing_date": "Jul 2023 -",
  "poster": "https://cdn.myanimelist.net/r/100x140/images/anime/1600/134703.jpg?s=389566a19d25da9f341aa64ac8e5b539"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[mongodb-shield]: https://img.shields.io/badge/-MongoDB-47A248?logo=mongodb&logoColor=white&style=plastic
[mongodb-url]: https://www.mongodb.com
[r-shield]: https://img.shields.io/badge/--276DC3?logo=r&logoColor=white&style=plastic
[r-url]: https://www.r-project.org
[shiny-shield]: https://img.shields.io/badge/-R%20Shiny-87CEFA?logo=rshiny&logoColor=White&style=plasti
[shiny-url]: https://www.shinyapps.io
