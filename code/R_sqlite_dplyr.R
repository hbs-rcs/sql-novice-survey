#
# R and dplyr for use with SQLite databases
#

install.packages(c('RSQLite','dplyr','dbplyr'))   # only need to do this once
setwd("/Users/rfreeman/Desktop/")


### Standard SQL
# import our required packages
library('RSQLite')

# open the database connection
connection <- dbConnect(SQLite(), "survey.db")

# execute and fetch the results
results <- dbGetQuery(connection, "SELECT Site.lat, Site.long FROM Site;")

# print 'em out
print(results)

# close the connection
dbDisconnect(connection)



### Somewhat using dplyr
# import our required packages
#
# HAS PROBLEMS!!
#
#library('RSQLite')
library('dplyr')

connection <- DBI::dbConnect(RSQLite::SQLite(), "survey.db")
#connection <- src_sqlite("/Users/Shared/datafest/survey.db")

# execute and fetch the results
results <- tbl(connection, sql("SELECT Site.lat, Site.long FROM Site"))

# print 'em out
print(results)

# close the connection
DBI::dbConnect(connection)



### Real dplyr with dbplyr
#
library(dplyr)
library(dbplyr)
#library(dbplyr)

# open a connection and give us information about it
connection <- DBI::dbConnect(RSQLite::SQLite(), "survey.db")
src_dbi(connection)

# SQL approach, seeing what the data is and the data structure
results <- tbl(connection, sql("SELECT Site.lat, Site.long FROM Site"))
results
str(results)

# dplyr approach, see data structure and use pipes
sites <- tbl(connection, "Site")
str(sites)
sites %>% 
  select(lat, long)

# see the SQL and disconnect
sites %>% 
  select(lat, long) %>%
  show_query()
DBI::dbDisconnect(connection)



## Simple query and filter
#
# find readings out of range:
# SELECT * FROM Survey WHERE quant = 'sal' AND ((reading > 1.0) OR (reading < 0.0));
connection <- DBI::dbConnect(RSQLite::SQLite(), "survey.db")
src_dbi(connection)
survey <- tbl(connection, "Survey")
survey %>% 
  select(person_id, quant, reading) %>% 
  filter(quant == 'sal',
         reading > 1 | reading < 0)

# what did it do?
survey %>% 
  select(person_id, quant, reading) %>% 
  filter(quant == 'sal',
         reading > 1 | reading < 0) %>% 
  show_query()

# collect data and disconnect
salinity_readings <- survey %>% 
  select(person_id, quant, reading) %>% 
  filter(quant == 'sal',
         reading > 1 | reading < 0)
salinity_readings
DBI::dbDisconnect(connection)



## Do a join
#
# SELECT * FROM Visited JOIN Survey 
# ON Survey.taken = Visited.id and person = "lake" ORDER BY quant ASC;

library(dplyr)
library(dbplyr)

connection <- DBI::dbConnect(RSQLite::SQLite(), "survey.db")
src_dbi(connection)
survey <- tbl(connection, "Survey")

# now join Survey to other table Visit, identifying ties, then continue filter...
both <- left_join(survey, tbl(connection, "Visited"),
                   by = c("visited_id" = "id")) %>% 
  filter(person_id == "lake") %>%
  arrange(quant)
both

# tell us what happened, and exit
explain(both)
DBI::dbDisconnect(connection)
