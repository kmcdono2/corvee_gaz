library(readr)
library(tidyr)

# Read in data 
cassini <- read_csv("~/local/Breton_corvée/chef_lieux.csv") # modify these file paths for your directory
ogee <- read_csv("~/local/Breton_corvée/geo_ogee_inner.csv")

# Remove accents from entire cassini data frame
cassini[] <- lapply(cassini, gsub, pattern='à', replacement='a')
cassini[] <- lapply(cassini, gsub, pattern='è', replacement='e')
cassini[] <- lapply(cassini, gsub, pattern='é', replacement='e')
cassini[] <- lapply(cassini, gsub, pattern='ç', replacement='c')
cassini[] <- lapply(cassini, gsub, pattern='â', replacement='a')
cassini[] <- lapply(cassini, gsub, pattern='ê', replacement='e')
cassini[] <- lapply(cassini, gsub, pattern='î', replacement='i')
cassini[] <- lapply(cassini, gsub, pattern='ô', replacement='o')
cassini[] <- lapply(cassini, gsub, pattern='û', replacement='u')
cassini[] <- lapply(cassini, gsub, pattern='ù', replacement='u')
cassini[] <- lapply(cassini, gsub, pattern='ë', replacement='e')
cassini[] <- lapply(cassini, gsub, pattern='ï', replacement='i')
cassini[] <- lapply(cassini, gsub, pattern='ü', replacement='u')
cassini[] <- lapply(cassini, gsub, pattern='œ', replacement='oe')

cassini[] <- lapply(cassini, gsub, pattern='À', replacement='A')
cassini[] <- lapply(cassini, gsub, pattern='È', replacement='E')
cassini[] <- lapply(cassini, gsub, pattern='É', replacement='E')
cassini[] <- lapply(cassini, gsub, pattern='Ç', replacement='C')
cassini[] <- lapply(cassini, gsub, pattern='Â', replacement='A')
cassini[] <- lapply(cassini, gsub, pattern='Ê', replacement='E')
cassini[] <- lapply(cassini, gsub, pattern='Î', replacement='I')
cassini[] <- lapply(cassini, gsub, pattern='Ô', replacement='O')
cassini[] <- lapply(cassini, gsub, pattern='Û', replacement='U')
cassini[] <- lapply(cassini, gsub, pattern='Ù', replacement='U')
cassini[] <- lapply(cassini, gsub, pattern='Ë', replacement='E')
cassini[] <- lapply(cassini, gsub, pattern='Ï', replacement='I')
cassini[] <- lapply(cassini, gsub, pattern='Ü', replacement='U')
cassini[] <- lapply(cassini, gsub, pattern='Œ', replacement='OE')

# Add additional CLEAN_NAME column
nom <- cassini$label
nom <- toupper(nom)
cassini$CLEAN_NAME <- nom

# Accomplishes outer and inner join between ogee and cassini on the CLEAN_NAME field
cassini_ogee_outer <- merge(ogee, cassini, by = 'CLEAN_NAME', all = TRUE)
cassini_ogee_inner <- merge(ogee, cassini, by = 'CLEAN_NAME')

# Exports merged dataframes
# 
write.csv(cassini_ogee_outer, "~/local/Breton_corvée/geo_ogee_outer_cassini_merge.csv")
write.csv(cassini_ogee_inner, "~/local/Breton_corvée/geo_ogee_inner_cassini_merge.csv")

