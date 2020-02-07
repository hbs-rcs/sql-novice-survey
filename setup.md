---
layout: page
title: Setup
---
# Software
For this course you will need the UNIX shell, plus [SQLite3](http://www.sqlite.org/) or
[DB Browser for SQLite](http://sqlitebrowser.org/).

If you are running Linux, you may already have SQLite3 installed, please use the command 
`which sqlite3` to see the path of the program, otherwise you should be able to get it 
from your package manager (on Debian/Ubuntu, you can use the command `apt install sqlite3`).

If you are running Windows, run installers as administrator.
Additionally, make sure you select the right installer version for your system.
We recommend that you use [git for Windows](https://gitforwindows.org/).
This is described in the [UNIX Shell lesson](http://swcarpentry.github.io/shell-novice/setup.html).
If the installer asks to add the path to the environment variables, check yes, otherwise you have to manually add the path of the executable to the `PATH` environmental variables.
This path informs the system where to find the executable program.

If installing SQLite3 using Anaconda, refer to the [anaconda sqlite docs](https://anaconda.org/anaconda/sqlite).

After the installation and the setting of the paths, close the terminal and reopen a new terminal.
This enables paths and configurations to be loaded.

# Files
Please download the database we'll be using: [survey.db]({{ page.root }}/files/survey.db)


# R + RStudio + RSQLite + dplyr packages

Setup for this section is required only if you wish to follow along with the instructor for
the using R with SQLite.  



1. For Mac or PC, please download to your `Installers` folder the R installer from the [CRAN](https://cran.r-project.org/) site and run it to start the installation process:

    Mac: https://cran.r-project.org/bin/macosx/R-3.6.2.pkg       
    PC : https://cran.r-project.org/bin/windows/base/R-3.6.2-win.exe

2. For Mac or PC, please download to your `Installers` folder the RStudio installer from the [RStudio](https://www.rstudio.com/) site and run it to start the installation process:

    Mac: https://download1.rstudio.org/desktop/macos/RStudio-1.2.5033.dmg       
    PC : https://download1.rstudio.org/desktop/windows/RStudio-1.2.5033.exe


3. Final step is to install the R packages needed for the workshop. Open up the RStudio
program. In the console window that appears in the left pane, please enter the following
commands one-at-a-time, *noting that there may be long pauses* as RStudio processes
and installs all the dependent packages:

```
    install.packages(c('RSQLite','dplyr','dbplyr'))
```

Red text may appear and scroll by. For the most part, that should be fine. But the final
message should be something like...

```
The downloaded binary packages are in
	C:\Users\myuser\AppData\Local\Temp\RtmpusjIjg\downloaded_packages
```

4. To test the success of your installation, enter the following commands:

```
    library('RSQLite')
    library('dplyr')
    library('dbplyr')
```
    
For RSQLite, there should be nothing printed. For dplyr, you may get someting like the following:

```
Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union`


Attaching package: ‘dbplyr’

The following objects are masked from ‘package:dplyr’:

    ident, sql
```

5. Download [`R_sqlite_dplyr.R`]({{ page.root }}/code/R_sqlite_dplyr.R) to your local machine
and put it in your `Desktop/` folder. On PCs, this is the one at `C:\Users\(your_username)\Desktop\`,
not the `Desktop` folder found in the upper left pane of your Explorer window.

If you receive any error (not warning) messages, please show up before the class and
ask for assistance.
