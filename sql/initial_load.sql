-- Create the first database
create database pvl_files;
use pvl_files;

-- Create necessary tables (the script is adapted from MySQL Workbench)
-- Table for raw data from Kinopoisk
create table if not exists pvl_files.import_kp_ratings (
  id int auto_increment,
  name_eng varchar(255) null,
  name_rus varchar(255) null,
  rating tinyint null,
  rating_datetime varchar(255) null,
  release_year year null,
  link varchar(255) null,
  primary key (id))
engine = innodb;

-- Table for raw data from IMDB
create table if not exists pvl_files.import_imdb_ratings (
  const varchar(255) not null,
  rating tinyint null,
  rating_date date null,
  name_eng varchar(255) null,
  link varchar(255) null,
  title_type varchar(255) null,
  imdb_rating decimal(3,1) null,
  runtime int null,
  release_year year null,
  genres varchar(255) null,
  votes_num int null,
  release_date date null,
  directors varchar(255) null,
  primary key (const))
engine = innodb;

-- Combined table
create table if not exists pvl_files.pvl_film_ratings (
  id int auto_increment,
  imdb_id varchar(20),
  name_eng varchar(255) null,
  rating tinyint null,
  rating_date varchar(255) null,
  release_year year null,
  link varchar(255) null,
  primary key (`id`))
engine = innodb;

-- Allow loading data into tables from local disk
set global local_infile = 1;
show global variables like 'local_infile';

-- Load data into tables
load data local infile '/data/kp_ratings.csv'
into table pvl_files.import_kp_ratings
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
set rating_datetime = date_format(str_to_date(rating_datetime, '%d.%m.%Y, %H:%i'), '%Y-%m-%d %H:%i');

load data local infile '/data/imdb_ratings.csv'
into table pvl_files.import_imdb_ratings
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- Insert Kinopoisk data inside the unified table
truncate table pvl_files.pvl_film_ratings;
insert into pvl_files.pvl_film_ratings
select
    id,
    null,
    name_eng,
    rating,
    date(rating_datetime),
    release_year,
    link
from pvl_files.import_kp_ratings;

-- Insert IMDB data
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
order by rating_date;

-- Clean up
drop table pvl_files.import_kp_ratings;
truncate table pvl_files.import_imdb_ratings;