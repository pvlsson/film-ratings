-- Use existing database
use pvl_files;

-- Allow loading data into tables from local disk
set global local_infile = 1;
show global variables like 'local_infile';

-- Load updated IMDB data
load data local infile '/Users/pavelsson/Development/Projects/film-ratings/data/updated_imdb_ratings.csv'
into table pvl_files.import_imdb_ratings
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- Add only those ratings that are still non-existent in the unified table
insert into pvl_files.pvl_film_ratings
select
    null,
    const,
    name_eng,
    rating,
    rating_date,
    release_year,
    link
from pvl_files.import_imdb_ratings
where const not in (
    select const from
        (select const
        from pvl_files.import_imdb_ratings
            inner join pvl_files.pvl_film_ratings on const = imdb_id) as matched
        );
order by rating_date;

-- Clean up
truncate table pvl_files.import_imdb_ratings;