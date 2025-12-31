# The purpose of this script is to parse XML data pertaining to hospital beds 
# from different facilities. We need to be able to evaluate whether a hospital 
# system will benefit from hiring additional nurses based on the volume of 
# licensed beds, census beds, and staffed beds.


# Define a vector of required packages
required_packages <- c("XML", "DBI", "RCurl", "dplyr", "RSQLite")

# Check if each package is installed, and install if necessary
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}
rm(list=ls())


# initial parsing functions

url <- "https://s3.us-east-2.amazonaws.com/artificium.us/datasets/HospitalBeds.xml"
beds <- getURL(url)
beds <- xmlParse(beds)
root <- xmlRoot(beds)
n <- xmlSize(root) - 1
empty <- rep(NA, n)


# parse facility table

imsid <- as.vector(xpathSApply(beds, "//hospital", xmlAttrs))
name <- xpathSApply(beds, "//hospital/name", xmlValue)


# initiate df
df.facility <- data.frame(
  "imsid" = imsid,
  "name" = name
)

temp.l <- empty
temp.c <- empty
temp.s <- empty

# FAILED APPROACH: I tried to use a list of lists to add rows to dataframe since 
# R does not have tuple type. I kept running into problems downstream with converting
# the list of lists to rows in a data frame after so many iterations of appending
# lists to a list through the loop. I realized it would be much easier to add rows
# to the df in the loop directly rather than trying to store the values in a 
# data structure and convert to a data frame later on. I did use GPT to find an
# alternative data structure to tuples and it led me try the list of lists method.

# initialize data frame because we are going to use dplyr to bind rows
df.bed_facts <- data.frame(
  imsid=NA,
  catid=NA,
  licensed=NA,
  census=NA,
  staffed=NA
)

# I am going to remove any rows containing "NA" or "" from the dataframes by
# storing their indices in this vector
to.keep <- c()
  
# parse data for both facilities and bed_facts tables 
for (i in 1:n) {
  this.hosp <- root[[i+1]][[2]]  # bed node
  hosp.id <- imsid[i]  # store relevant hospital id to use in list
  s <- xmlSize(this.hosp)  # loop number
  l.tally <- c.tally <- s.tally <- 0  # initialize total bed number counters
  check <- 1
  
  for (j in 1:s) {
    # get value for category
    this.cat <- as.vector(xmlAttrs(this.hosp[[j]])[1])
    
    if (this.cat=="NA" | this.cat=="") {
      check <- 0
      break
    } else {
      # save the number of beds in this category as separate variables
      l.catbeds <- as.integer(xmlValue(this.hosp[[j]][[1]]))
      c.catbeds <- as.integer(xmlValue(this.hosp[[j]][[2]]))
      s.catbeds <- as.integer(xmlValue(this.hosp[[j]][[3]]))
      
      # new row for bed_facts data frame
      facts <- list(imsid=hosp.id, catid=this.cat, licensed=l.catbeds, 
                    census=c.catbeds, staffed=s.catbeds)
      df.bed_facts <- rbind(df.bed_facts, facts)
      
      # tally total bed numbers for this hospital
      l.tally <- l.tally + l.catbeds
      c.tally <- c.tally + c.catbeds
      s.tally <- s.tally + s.catbeds
    }
  }
  
  # append tallies to columns of facilities only if values are legit
  # otherwise, add index to destruction list
  if (check==1) {
    temp.l[i] <- l.tally
    temp.c[i] <- c.tally
    temp.s[i] <- s.tally
    to.keep <- c(to.keep, i)
  }
}


# define facility table rows
df.facility$ttl_licensed <- temp.l
df.facility$ttl_census <- temp.c
df.facility$ttl_staffed <- temp.s

df.facility <- df.facility[to.keep,]  # remove NA/"" rows

# remove top row from bed_facts
f <- nrow(df.bed_facts)
df.bed_facts <- df.bed_facts[2:f,]

# bed_categories
cats <- xpathSApply(beds, "//hospital/beds/bed", xmlAttrs)
cats.clean <- which(cats[1,]!="NA" & cats[1,] != "")  # get rid of empty string and NAs
category <- unique(cats[1,cats.clean])  # isolate unique bed categories
desc <- unique(cats[2,cats.clean])      # and descriptions
n.bc <- length(desc)
df.bed_categories <- data.frame(
  'catid'=1:n.bc,
  'category'=category,
  'desc'=desc
)


# now that we have our bed_category table defined, we can reference the 
# auto-generated catid's to create that column for the bed_facts table

c <- nrow(df.bed_categories)

for (i in 1:c) {
  cat.catid <- df.bed_categories$catid[i]
  cat.cat <- df.bed_categories$category[i]
  matches <- which(df.bed_facts$catid==cat.cat)
  df.bed_facts$catid[matches] <- as.integer(cat.catid)
}

df.bed_facts$catid <- as.integer(df.bed_facts$catid)

# write tables to SQLite db
con <- dbConnect(RSQLite::SQLite(), "hospital-beds.sqlitedb")
dbWriteTable(con, "facility", df.facility, overwrite=TRUE)
dbWriteTable(con, "bed_facts", df.bed_facts, overwrite=TRUE)
dbWriteTable(con, "bed_categories", df.bed_categories, overwrite=TRUE)

dbDisconnect(con)


