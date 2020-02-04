---
title: "Selecting Data"
teaching: 10
exercises: 5
questions:
- "How can I get data from a database?"
objectives:
- "Explain the difference between a table, a record, and a field."
- "Explain the difference between a database and a database manager."
- "Write a query to select all values for specific fields from a single table."
keypoints:
- "A relational database stores information in tables, each of which has a fixed set of columns and a variable number of records."
- "A database manager is a program that manipulates information stored in a database."
- "We write queries in a specialized language called SQL to extract information from databases."
- "Use SELECT... FROM... to get values from a database table."
- "SQL is case-insensitive (but data is case-sensitive)."
---
## Review of structured data and advantage of database systems

A database is a construct for data storage; it can be specifically designed for a certain data type, or it can be more generic. We don't see these as often, but library indices and telephone directories are some examples of databases we can hold. Computer-based databases are more of the norm now, and are also what we will be discussing today.

Three common options for data storage are text files, spreadsheets, and databases. Text files are easiest to create, and work well with version control, but then we would have to build search and analysis tools ourselves. Spreadsheets are good for doing simple analyses, but they don’t handle large or complex data sets well. Databases, however, include powerful tools for search and analysis, and can handle large, complex data sets.

When we are using a spreadsheet, we put formulas into cells to calculate new values based on old ones.  When we are using a database, we send commands (usually called [queries]({% link reference.md %}#query)) to a [database manager]({% link reference.md %}#database-manager): a program that manipulates the database for us.  The database manager does whatever lookups and calculations the query specifies, returning the results in a tabular form that we can then use as a starting point for further queries.

![Database  Manager](fig/DBMS.PNG "Conceptual Overview of Database Manager")

Queries are written in a language called [SQL]({% link reference.md %}#sql), which stands for "Structured Query Language".
SQL provides hundreds of different ways to analyze and recombine data.  We will only look at a handful of queries, but that handful accounts for most of what scientists do.

The three major ways to model databases are [*relational*](https://en.wikipedia.org/wiki/Relational_model), [*heirarchical*](https://en.wikipedia.org/wiki/Hierarchical_database_model) and [*network*](https://en.wikipedia.org/wiki/Network_model). The Relational model is the one that is most commonly employed and the resulting database is appropriately called a **Relational Database**.

Within a [relational database]({{ site.github.url }}/reference/#relational-database) the data is arranged into [tables]({{ site.github.url }}/reference/#table). Each table has columns (also known as [fields]({{ site.github.url }}/reference/#field)) that describe the data, and rows (also known as [records]({{ site.github.url }}/reference/#record)) which contain the data.

![Relational Database](fig/RelationalDB.PNG "Conceptual Overview of Structure of a Relational Database")

> ## Changing Database Managers
>
> Many database managers --- Oracle,
> IBM DB2, PostgreSQL, MySQL, Microsoft Access, and SQLite ---  understand
> SQL but each stores data in a different way,
> so a database created with one cannot be used directly by another.
> However, every database manager
> can import and export data in a variety of formats like .csv, SQL,
> so it *is* possible to move information from one to another.
{: .callout}

## Moving towards structured Data

Key points when moving towards structured data that you wish to move into a database system:

- Generate and use unique values (primary keys) for data in a given table. This primary key allows you to unique identify that row of data. This can be a unique, serial number (e.g. 1, 2, etc), a static # that is the row # upon data import, another value in a field (column), or a new field that is a combination of two values or fields that now creates a new value across all the table data.

- Follow the data normalization rules as best as possible to create modular, non-redundant data. A good, lay discussion can be found at Software Carpentry's [Data Hygiene lesson](http://swcarpentry.github.io/sql-novice-survey/08-hygiene/).

![Data  Normalization](fig/Normalization.PNG "Conceptual Overview of Data Normalization Process")

## SQLite

The Database engine we will be using today is **[SQLite](https://sqlite.org/about.html)**. SQLite attempts to provide a Structured  Language Query (SQL) engine intended for data analysis/management "locally"; it is good at reading from, and writing directly to local files. Unlike other SQL engines like MySQL, Oracle, SQL server, etc., SQLite is not intended for high-volume websites or in the case where many "connections" need to be maintained simultaneously. [Here is a detailed overview of when it is appropriate to use SQLite](https://sqlite.org/whentouse.html). 


**Our data:** In the late 1920s and early 1930s, William Dyer, Frank Pabodie, and Valentina Roerich led expeditions to the Pole of Inaccessibility in the South Pacific, and then onward to Antarctica. Two years ago, their expeditions were found in a storage locker at Miskatonic University. We have scanned and OCR the data they contain, and we now want to store that information in a way that will make search and analysis easy.

![Our Data](fig/PoleofInaccessibility.PNG "Where did our data come from")

Before we get into using SQLite to select the data, let's take a look at the tables of the database we will use in our examples:

<div class="row">
  <div class="col-md-6" markdown="1">

**Person**: people who took readings.

|id      |personal |family
|--------|---------|----------
|dyer    |William  |Dyer
|pb      |Frank    |Pabodie
|lake    |Anderson |Lake
|roe     |Valentina|Roerich
|danforth|Frank    |Danforth

**Site**: locations where readings were taken.

|name |lat   |long   |
|-----|------|-------|
|DR-1 |-49.85|-128.57|
|DR-3 |-47.15|-126.72|
|MSK-4|-48.87|-123.4 |

**Visited**: when readings were taken at specific sites.

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|752  |DR-3 |-null-    |
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

  </div>
  <div class="col-md-6" markdown="1">

**Survey**: the actual readings.  The field `quant` is short for quantitative and indicates what is being measured.  Values are `rad`, `sal`, and `temp` referring to 'radiation', 'salinity' and 'temperature', respectively.

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |rad  |9.82   |
|619  |dyer  |sal  |0.13   |
|622  |dyer  |rad  |7.8    |
|622  |dyer  |sal  |0.09   |
|734  |pb    |rad  |8.41   |
|734  |lake  |sal  |0.05   |
|734  |pb    |temp |-21.5  |
|735  |pb    |rad  |7.22   |
|735  |-null-|sal  |0.06   |
|735  |-null-|temp |-26.0  |
|751  |pb    |rad  |4.35   |
|751  |pb    |temp |-18.5  |
|751  |lake  |sal  |0.1    |
|752  |lake  |rad  |2.19   |
|752  |lake  |sal  |0.09   |
|752  |lake  |temp |-16.0  |
|752  |roe   |sal  |41.6   |
|837  |lake  |rad  |1.46   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |
|844  |roe   |rad  |11.25  |

  </div>
</div>

Notice that three entries --- one in the `Visited` table,
and two in the `Survey` table --- don't contain any actual
data, but instead have a special `-null-` entry:
we'll return to these missing values [later]({{ site.github.url }}/05-null/).

> ## Getting Into and Out Of SQLite
>
> We'd like to introduce you to this handy tool, DB Brower for SQLite (https://sqlitebrowser.org/dl/).  DB Brower for SQLite gives us nice and quick overviews of our database and tables, and allows us to use the SQLite commands *interactively*.
>  

Once you've downloaded DB Brower for SQLite for your operating system, you can open DB Brower and click Open Database.  Select our database, survey.db; and our database should pop up under the tab Database Structure. 

Under the Database Structure tab you'll see that we have 4 tables in our database: 
   Person, Site, Survey, Visited.

The Schema column of this tab informs us about the structures of each table:
 
  > CREATE TABLE Person (id text, personal text, family text)
 
  > CREATE TABLE Site (name text, lat real, long real)
 
  > CREATE TABLE Survey (taken integer, person text, quant text, reading real)
 
  > CREATE TABLE Visited (id text, site text, dated text)

The Browse Data tab provides view of each table.

The Execute SQL tab is where we'll be entering and executing our SQL commands.
> Note: The available data types vary based on the database manager - you can search online for what data types are supported.

## Selecting Data

For now, let's write an SQL query that displays scientists' names.
We do this using the SQL command `SELECT`, giving it the names of the columns we want and the table we want them from.
Our query and its output look like this:

~~~
SELECT family, personal FROM Person;
~~~
{: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

The semicolon at the end of the query
tells the database manager that the query is complete and ready to run.
We have written our commands in upper case and the names for the table and columns
in lower case,
but we don't have to:
as the example below shows,
SQL is [case insensitive]({% link reference.md %}#case-insensitive).

~~~
SeLeCt FaMiLy, PeRsOnAl FrOm PeRsOn;
~~~
{: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

You can use SQL's case insensitivity to your advantage. For instance,
some people choose to write SQL keywords (such as `SELECT` and `FROM`)
in capital letters and **field** and **table** names in lower
case. This can make it easier to locate parts of an SQL statement. For
instance, you can scan the statement, quickly locate the prominent
`FROM` keyword and know the table name follows.  Whatever casing
convention you choose, please be consistent: complex queries are hard
enough to read without the extra cognitive load of random
capitalization.  One convention is to use UPPER CASE for SQL
statements, to distinguish them from tables and column names. This is
the convention that we will use for this lesson.

While we are on the topic of SQL's syntax, one aspect of SQL's syntax
that can frustrate novices and experts alike is forgetting to finish a
command with `;` (semicolon).  When you press enter for a command
without adding the `;` to the end, it can look something like this:

~~~
SELECT id FROM Person
...>
...>
~~~
{: .sql}

This is SQL's prompt, where it is waiting for additional commands or
for a `;` to let SQL know to finish.  This is easy to fix!  Just type
`;` and press enter!

Now, going back to our query,
it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,
but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:

~~~
SELECT personal, family FROM Person;
~~~
{: .sql}

|personal |family  |
|---------|--------|
|William  |Dyer    |
|Frank    |Pabodie |
|Anderson |Lake    |
|Valentina|Roerich |
|Frank    |Danforth|

or even repeat columns:

~~~
SELECT id, id, id FROM Person;
~~~
{: .sql}

|id      |id      |id      |
|--------|--------|--------|
|dyer    |dyer    |dyer    |
|pb      |pb      |pb      |
|lake    |lake    |lake    |
|roe     |roe     |roe     |
|danforth|danforth|danforth|

As a shortcut,
we can select all of the columns in a table using `*`:

~~~
SELECT * FROM Person;
~~~
{: .sql}

|id      |personal |family  |
|--------|---------|--------|
|dyer    |William  |Dyer    |
|pb      |Frank    |Pabodie |
|lake    |Anderson |Lake    |
|roe     |Valentina|Roerich |
|danforth|Frank    |Danforth|

> ## Understanding CREATE statements
> 
> Use the `.schema` to identify column that contains integers.
>
> > ## Solution
> >
> > ~~~
> > .schema
> > ~~~
> > {: .sql}
> > ~~~
> > CREATE TABLE Person (id text, personal text, family text);
> > CREATE TABLE Site (name text, lat real, long real);
> > CREATE TABLE Survey (taken integer, person text, quant text, reading real);
> > CREATE TABLE Visited (id integer, site text, dated text);
> > ~~~
> > {: .output}
> > From the output, we see that the **taken** column in the **Survey** table (3rd line) is composed of integers. 
> {: .solution}
{: .challenge}

> ## Selecting Site Names
>
> Write a query that selects only the `name` column from the `Site` table.
>
> > ## Solution
> > 
> > ~~~
> > SELECT name FROM Site;
> > ~~~
> > {: .sql}
> >
> > |name      |
> > |----------|
> > |DR-1      |
> > |DR-3      |
> > |MSK-4     |
> {: .solution}
{: .challenge}

> ## Query Style
>
> Many people format queries as:
>
> ~~~
> SELECT personal, family FROM person;
> ~~~
> {: .sql}
>
> or as:
>
> ~~~
> select Personal, Family from PERSON;
> ~~~
> {: .sql}
>
> What style do you find easiest to read, and why?
{: .challenge}
