# Matches lat/long in INSEE data to the Ogée places. Match based on INSEE ID from Ogée spreadsheet.
# INSEE data = 1493 rows
# Ogée data = rows that have been approved (see status filter)

library(readr)
library(tidyr)

# Read in data 
map <- read_csv("~/local/Breton_corvée/map.csv") # modify these file paths for your directory
insee <- read_csv("~/local/Breton_corvée/insee.csv") # modify these file paths for your directory

# Filter out rows by assignment
assignment_vec <- c('Y') # add acceptable statuses here
map <- map[map$assignment %in% assignment_vec, ]

# Filter out unnecessary columns
map_drops <- c('status')
insee_keeps <- c('long', 'lat', 'INSEE ID')
insee <- insee[insee_keeps]
map <- map[ , !(names(map) %in% map_drops)]

# Drop NA's from INSEE
insee <- insee %>% drop_na()

# Remove accents from entire map data frame
map[] <- lapply(map, gsub, pattern='à', replacement='a')
map[] <- lapply(map, gsub, pattern='è', replacement='e')
map[] <- lapply(map, gsub, pattern='é', replacement='e')
map[] <- lapply(map, gsub, pattern='ç', replacement='c')
map[] <- lapply(map, gsub, pattern='â', replacement='a')
map[] <- lapply(map, gsub, pattern='ê', replacement='e')
map[] <- lapply(map, gsub, pattern='î', replacement='i')
map[] <- lapply(map, gsub, pattern='ô', replacement='o')
map[] <- lapply(map, gsub, pattern='û', replacement='u')
map[] <- lapply(map, gsub, pattern='ù', replacement='u')
map[] <- lapply(map, gsub, pattern='ë', replacement='e')
map[] <- lapply(map, gsub, pattern='ï', replacement='i')
map[] <- lapply(map, gsub, pattern='ü', replacement='u')
map[] <- lapply(map, gsub, pattern='œ', replacement='oe')

map[] <- lapply(map, gsub, pattern='À', replacement='A')
map[] <- lapply(map, gsub, pattern='È', replacement='E')
map[] <- lapply(map, gsub, pattern='É', replacement='E')
map[] <- lapply(map, gsub, pattern='Ç', replacement='C')
map[] <- lapply(map, gsub, pattern='Â', replacement='A')
map[] <- lapply(map, gsub, pattern='Ê', replacement='E')
map[] <- lapply(map, gsub, pattern='Î', replacement='I')
map[] <- lapply(map, gsub, pattern='Ô', replacement='O')
map[] <- lapply(map, gsub, pattern='Û', replacement='U')
map[] <- lapply(map, gsub, pattern='Ù', replacement='U')
map[] <- lapply(map, gsub, pattern='Ë', replacement='E')
map[] <- lapply(map, gsub, pattern='Ï', replacement='I')
map[] <- lapply(map, gsub, pattern='Ü', replacement='U')
map[] <- lapply(map, gsub, pattern='Œ', replacement='OE')

# Add additional CLEAN_NAME column
nom <- map$`normalized place name`
nom <- toupper(nom)
map$CLEAN_NAME <- nom

# Merge INSEE and map with inner join
geo_map_inner <- merge(map, insee, by = 'INSEE ID')

# Merge INSEE and map with outer join
geo_map_outer <- merge(map, insee, by = 'INSEE ID', all = TRUE)

# Change column names to data_dict approved ones
colnames(geo_map_inner) <- c('MAP', 'QUADRANT', 'PLACE_NAME', 'NORM_NAME', 'INSEE_ID', 'TYPE', 'ASSIGNMENT', 'SEGMENT', 'ROAD', 'ROAD_TYPE', 'ASSIGN_DIST', 'ASSIGN_ATT', 'CORVEE_REL_LOC', 'PLACE_REL_LOC', 'PC_DEPT', 'CLEAN_NAME', 'LONG', 'LAT')
colnames(geo_map_outer) <- c('MAP', 'QUADRANT', 'PLACE_NAME', 'NORM_NAME', 'INSEE_ID', 'TYPE', 'ASSIGNMENT', 'SEGMENT', 'ROAD', 'ROAD_TYPE', 'ASSIGN_DIST', 'ASSIGN_ATT', 'CORVEE_REL_LOC', 'PLACE_REL_LOC', 'PC_DEPT', 'CLEAN_NAME', 'LONG', 'LAT')

# inner join represents results that have 1:1 match across both Ogée and INSEE data
# inner join drops rows that do now have matches in the other table
# outer join merges both tables, regardless of whether or not there is a match on INSEE ID (for debugging)


# Export merged data frames
write.csv(geo_map_inner, "~/local/Breton_corvée/geo_map_inner.csv") # modify these output file paths for your directory
write.csv(geo_map_outer, "~/local/Breton_corvée/geo_map_outer.csv") # modify these output file paths for your directory
