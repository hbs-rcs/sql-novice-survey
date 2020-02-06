-- Create database to be used for learners.
-- The data for the database are available as CSV files.
-- For more information, see https://www.sqlite.org/cli.html#csv

-- Generate tables.
create table Person (id text, personal text, family text);
create table Site (id text, lat real, long real);
create table Visited (id text, site_id text, dated text);
create table Survey (visited_id integer, person_id text, quant text, reading real);

-- Import data.
.mode csv
.import data/person.csv Person
.import data/site.csv Site
.import data/survey.csv Survey
.import data/visited.csv Visited

-- Convert empty strings to NULLs.
UPDATE Visited SET dated = null WHERE dated = '';
UPDATE Survey SET person = null WHERE person = '';
