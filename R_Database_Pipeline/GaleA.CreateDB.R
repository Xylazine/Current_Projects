# Define a vector of required packages
required_packages <- c("DBI", "RSQLite")

# Check if each package is installed, and install if necessary
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}
rm(list=ls())

# create the database to connect to
con <- dbConnect(RSQLite::SQLite(), "hospital-beds.sqlitedb")

# require foregin keys for reference
dbExecute(con, "PRAGMA foreign_keys = ON;")

# delete any existing instances of the tables we will create with this script
dbExecute(con, "DROP TABLE IF EXISTS facility")
dbExecute(con, "DROP TABLE IF EXISTS bed_categories")
dbExecute(con, "DROP TABLE IF EXISTS bed_facts")

# create tables using R commands
facility <- dbExecute(con, "
                      CREATE TABLE IF NOT EXISTS facility (
                      imsid TEXT,
                      name TEXT,
                      ttl_licensed INTEGER,
                      ttl_cencus INTEGER,
                      ttl_staffed INTEGER,
                      PRIMARY KEY (imsid)
                      );
                      ")

bed_categories <- dbExecute(con, "
                            CREATE TABLE IF NOT EXISTS bed_categories (
                            catid INTEGER,
                            category TEXT UNIQUE,
                            descr TEXT,
                            PRIMARY KEY (catid)
                            )
                            ")

bed_facts <- dbExecute(con, "
                       CREATE TABLE IF NOT EXISTS bed_facts (
                       imsid TEXT,
                       catid INTEGER,
                       licensed INTEGER,
                       census INTEGER,
                       staffed INTEGER,
                       FOREIGN KEY (imsid) REFERENCES facilty (imsid)
                       FOREIGN KEY (catid) REFERENCES bed_categories (catid)
                       );
                       ")

dbDisconnect(con)


