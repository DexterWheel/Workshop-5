library(tidyverse)
library(tidyr)
library(dplyr)
library(palmerpenguins)
library(GGally)

file <- "data-raw/scrna_data.csv"
rna <- read_csv(file)

pca <- rna %>%
  prcomp(scale. = TRUE)

summary(pca)[["importance"]][,1:10]

dat <-  data.frame(pca$x)

ggplot(dat, aes(x = PC1, y = PC2)) +
  geom_point()

#Since the first two components don't capture much of the variation in the cells, it's worth looking at some other pairwise comparisons.

#Any two will still only capture a small amount of variance but clusters may be seen better in some comparisons than others.

#Select the first 10 PCs and pipe in to ggpairs():

dat %>%
  select(PC1:PC10) %>% 
  ggpairs()
#basically no variance seen

library(Rtsne)

tsne <- rna %>% 
  Rtsne(perplexity = 40,
        check_duplicates = FALSE)

#perplexity is one of the arguments than can be altered - it is a smoothing of the number of neighbours.

dat2 <- data.frame(tsne$Y)

dat2 %>% ggplot(aes(x = X1, y = X2)) +
  geom_point(size=0.5)

#I would expect you to see at least three or four cell types and possible 6 - it looks like the large cluster could be three clusters and one of the other clusters is two or three.

#A cluster analysis (a different unsupervised method) has been performed on these data and the cell types identified and verified by mapping the expression of markers on the clusters.

#We can import this labelling and colour our t-SNE plot by cell type.


file <- "data-raw/scrna_meta.csv"
meta <- read_csv(file)

#There is a row for every cell and one of the columns louvain, gives the cell types. Louvain is the name of the clustering algorithm that was used.

unique(meta$louvain)
#8 cell  types

#Add the cell type to the t-SNE scores dataframe:



dat3 <- data.frame(dat2, type = meta$louvain)

dat3 %>% ggplot(aes(x = X1, y = X2, colour = type)) +
  geom_point(size = 0.5)



