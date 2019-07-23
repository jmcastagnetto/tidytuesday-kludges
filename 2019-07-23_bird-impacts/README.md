# Notes on getting the whole dataset from https://wildlife.faa.gov/

- The database in MS Access format is at the URL: https://wildlife.faa.gov/downloads/wildlife.zip
- Once extracted the archive `wildlife.accdb` can be converted to CSV using the Linux command-line tools in the `mdbtools` package, as follows:

```bash
$ sudo apt install mdbtools

$ mdb-tables -1 wildlife.accdb 
STRIKE_REPORTS (1990-1999)
STRIKE_REPORTS (2000-2009)
STRIKE_REPORTS (2010-Current)
STRIKE_REPORTS_BASH (1990-Current)

$ mdb-export wildlife.accdb -D "%F" "STRIKE_REPORTS (1990-1999)" > strike_reports-1990_1999.csv

$ mdb-export wildlife.accdb -D "%F"  "STRIKE_REPORTS (2000-2009)" > strike_reports-2000_2009.csv

$ mdb-export wildlife.accdb -D "%F"  "STRIKE_REPORTS (2010-Current)" > strike_reports-2010_current.csv
$ mdb-export wildlife.accdb -D "%F"  "STRIKE_REPORTS_BASH (1990-Current)" > strike_reports_bash-1990_current.csv
```

- The same tools can be used to generate SQL suitable to be imported into PostgreSQL, MySQL, etc. More information at: http://mdbtools.sourceforge.net/

- The output `.csv` files were processed using [csvkit](https://csvkit.readthedocs.io)

```bash
$ csvstack strike_reports-1990_1999.csv \
   strike_reports-2000_2009.csv \
   strike_reports-2010_current.csv \
   strike_reports_bash-1990_current.csv | \
   csvsort -c 21  > strike_reports-1990_current.csv

$ csvclean strike_reports-1990_current.csv
No errors.
```

- Finally, some cleanup moving the extracted files into a `.7z` archive, and compressing the merged csv using `gzip` (see the [data](data/) dir)
