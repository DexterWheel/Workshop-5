library(tidyverse)
library(tidyr)
library(dplyr)
library(palmerpenguins)
library(GGally)

seed <- read_table2("data-raw/seeds.txt", 
                    col_names = c("area", "perimeter", 
                                  "compactness", "length", 
                                  "width", "asymmetry", "groove_length", "species"))


# str_replace or similar functions can only replace like for like I cannot use this to replace the number 1 with kama 
#seed %>%  mutate(species= str_extract(species, "[1-9]") %>% str_replace(c(("1", "kama"), ("2", "rosa"), ("3", "canadian"))))

#therefore we use recode

#better to use without the creation of a new datafram (seed2)

cols <- seed$ %>% c(area, perimeter, compactness, lengt, width, asymmetry, groove_length)

seed$species <- recode(seed$species, `1` = "kama" , `2` = "rosa", `3` = "canadian" )

seed %>% select(-species) %>% 
  ggpairs(aes(color = seed$species))

#now we run the pca


#Scaling: prevents the variables with the biggest values dominating the analysis.
pca <- seed %>% 
  select(-species) %>%
  prcomp(scale. = TRUE)

summary(pca)

pca$rotation

pca_labelled <- data.frame(pca$x, species = seed$species)
# a then to do a scatterplot

pca_labelled %>% 
  ggplot(aes(x = PC1, y = PC2, color = species)) +
  geom_point()