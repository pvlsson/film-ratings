# film-ratings

Combine my movie ratings into a unified table using local MySQL server and prepare a Looker Studio report.

## Plan


## 1. Web scraping
I easily export my IMBD ratings as a CSV file. Since I cannot export my ratings from Kinopoisk, I will use web scraping.

I could scrape a URL, but because my data is hidden behind a login, I save the relevant pages as HTML files and scrape them. I save three HTML pages, since one page can contain up to 200 ratings at once.

I prepared a Python script with the help from ChatGPT. I am using the following prompt:

```
I have <div class="profileFilmsList"> containing all my rated films inside individual <div class="item"> layers.

Each film has following variables
1. <div class="nameEng"> contains film name, variable called nameEng
2. <div class="nameRus"> contains film name in Russian, variable called nameRus
3. film rating, variable called rating, is contained inside a string that looks like this:
<script nonce="">ur_data.push({film: 1392550, rating: '4', user_code: 'cd7c5c7d630a36e326b5ce6c50ef3985', obj: $('#rating_user_1392550')});</script>
rating is 4 in this example
4. <div class="date"> contains date and time in a 31.01.2023, 21:18 format, variable called date

I want to extract this data into a table with 4 columns: nameEng, nameRus, rating, date
```

The final Python script is a corrected version of the ChatGPT script (`kp_import.py`).

I run the script inside a Python 3.9.6 virtual environment with pre-installed beautifulsoup4 and pandas packages.

The result is a CSV file, which I additionally clean using Excel.

## 2. Load and transform data in MySQL
I setup and run a local MySQL server to load the CSV files and combine them in a single table.

To visualize the desired data model I use MySQL Workbench (`model.mwb`).

I install and run a local MySQL server using HomeBrew.

Then, I run `initial_load.sql` to create tables, load the CSV files inside them, and combine the data into a unified table.

## 3. Load into Looker Studio

The final table is exported as CSV and uploaded to Google Sheets. Looker Studio uses Google Sheets as a data source.

Link to the report: https://lookerstudio.google.com/reporting/2b455111-1ec1-4664-bdf8-74ebeea181b7

## 4. Update with fresh ratings from IMDB
Since I continue rating movies on IMDB, I need to be able to add my latest ratings to the unified ratings table.

`update_imdb.sql` script loads new data from a CSV file exported from IMDB and adds new data to the unified table.
