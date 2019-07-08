# Matches lat/long in INSEE data to the Ogée places. Match based on INSEE ID from Ogée spreadsheet.
# INSEE data = 1493 rows
# Ogée data = rows that have been approved (see status filter)

library(readr)
library(tidyr)

# Read in data 
ogee <- read_csv("~/local/Breton_corvée/ogee.csv") # modify these file paths for your directory
insee <- read_csv("~/local/Breton_corvée/insee.csv") # modify these file paths for your directory


#convert Lat/Long from DMS to decimal
#data(insee)

#insee_long <- insee$long
  
#  char2dms()
  
  
#  as(char2dms(insee$long, NS=True, "numeric"))
#insee_lat <- char2dms(insee$lat)

#head(insee_long)

#insee_decimal <- 
#  as.numeric(sp::char2dms("long", "long"))


# Filter out rows by status
status_vec <- c('KM5', 'MC5', 'SL4', 'SL5') # add acceptable statuses here
ogee <- ogee[ogee$Status %in% status_vec, ]

# Filter out unnecessary columns
ogee_drops <- c('Status', 'new coordinates', 'coordinates source', 'Ogée')
insee_keeps <- c('long', 'lat', 'INSEE ID')
insee <- insee[insee_keeps]
ogee <- ogee[ , !(names(ogee) %in% ogee_drops)]

# Drop NA's from INSEE
insee <- insee %>% drop_na()

# Remove accents from entire OGEE data frame
ogee[] <- lapply(ogee, gsub, pattern='à', replacement='a')
ogee[] <- lapply(ogee, gsub, pattern='è', replacement='e')
ogee[] <- lapply(ogee, gsub, pattern='é', replacement='e')
ogee[] <- lapply(ogee, gsub, pattern='ç', replacement='c')
ogee[] <- lapply(ogee, gsub, pattern='â', replacement='a')
ogee[] <- lapply(ogee, gsub, pattern='ê', replacement='e')
ogee[] <- lapply(ogee, gsub, pattern='î', replacement='i')
ogee[] <- lapply(ogee, gsub, pattern='ô', replacement='o')
ogee[] <- lapply(ogee, gsub, pattern='û', replacement='u')
ogee[] <- lapply(ogee, gsub, pattern='ù', replacement='u')
ogee[] <- lapply(ogee, gsub, pattern='ë', replacement='e')
ogee[] <- lapply(ogee, gsub, pattern='ï', replacement='i')
ogee[] <- lapply(ogee, gsub, pattern='ü', replacement='u')
ogee[] <- lapply(ogee, gsub, pattern='œ', replacement='oe')

ogee[] <- lapply(ogee, gsub, pattern='À', replacement='A')
ogee[] <- lapply(ogee, gsub, pattern='È', replacement='E')
ogee[] <- lapply(ogee, gsub, pattern='É', replacement='E')
ogee[] <- lapply(ogee, gsub, pattern='Ç', replacement='C')
ogee[] <- lapply(ogee, gsub, pattern='Â', replacement='A')
ogee[] <- lapply(ogee, gsub, pattern='Ê', replacement='E')
ogee[] <- lapply(ogee, gsub, pattern='Î', replacement='I')
ogee[] <- lapply(ogee, gsub, pattern='Ô', replacement='O')
ogee[] <- lapply(ogee, gsub, pattern='Û', replacement='U')
ogee[] <- lapply(ogee, gsub, pattern='Ù', replacement='U')
ogee[] <- lapply(ogee, gsub, pattern='Ë', replacement='E')
ogee[] <- lapply(ogee, gsub, pattern='Ï', replacement='I')
ogee[] <- lapply(ogee, gsub, pattern='Ü', replacement='U')
ogee[] <- lapply(ogee, gsub, pattern='Œ', replacement='OE')

# Add additional CLEAN_NAME column
nom <- ogee$`Ogée 1778 entry`
nom <- toupper(nom)
ogee$CLEAN_NAME <- nom

# Merge INSEE and OGEE with inner join
geo_ogee_inner <- merge(ogee, insee, by = 'INSEE ID')

# Merge INSEE and OGEE with outer join
geo_ogee_outer <- merge(ogee, insee, by = 'INSEE ID', all = TRUE)

# Change column names to data_dict approved ones
colnames(geo_ogee_inner) <- c('INSEE_ID', 'NAME', 'INSEE_NAME', 'OGEE_NAME', 'OGEE_VOL', 'OGEE_PAGE', 'TYPE', 'DESCR', 'DEPEND', 'COMMUNE', 'TREV', 'PAR', 'ESTATES', 'LANG', 'POP_COMM', 'DIST_DIOC', 'DIR_DIOC', 'DIOC', 'DIST_RESS', 'DIR_RESS', 'RESS', 'DIST_SUBD', 'DIR_SUBD', 'SUBD', 'DIST_RENNES', 'SEIGN', 'CLEAN_NAME', 'LONG', 'LAT')
colnames(geo_ogee_outer) <- c('INSEE_ID', 'NAME', 'INSEE_NAME', 'OGEE_NAME', 'OGEE_VOL', 'OGEE_PAGE', 'TYPE', 'DESCR', 'DEPEND', 'COMMUNE', 'TREV', 'PAR', 'ESTATES', 'LANG', 'POP_COMM', 'DIST_DIOC', 'DIR_DIOC', 'DIOC', 'DIST_RESS', 'DIR_RESS', 'RESS', 'DIST_SUBD', 'DIR_SUBD', 'SUBD', 'DIST_RENNES', 'SEIGN', 'CLEAN_NAME', 'LONG', 'LAT')

# inner join represents results that have 1:1 match across both Ogée and INSEE data
# inner join drops rows that do now have matches in the other table
# outer join merges both tables, regardless of whether or not there is a match on INSEE ID (for debugging)


# Export merged data frames
write.csv(geo_ogee_inner, "~/local/Breton_corvée/geo_ogee_inner.csv") # modify these output file paths for your directory
write.csv(geo_ogee_outer, "~/local/Breton_corvée/geo_ogee_outer.csv") # modify these output file paths for your directory
