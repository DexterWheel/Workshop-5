file <- "data-raw/sol.txt"
sol <- read_table2(file)
names(sol)


#We can see that the genename is in the first column.

#Transpose all the values except the genename:

tsol <- sol %>% 
  select(-genename) %>% 
  t() %>% 
  data.frame()


#Use the genenames in sol to name the columns in tsol:

names(tsol) <- sol$genename

#The column names of sol have become the row names of tsol. We can add a column for these as well.

tsol$sample <- row.names(tsol)

#And process the sample name so we have the cell lineage in one column and the replicate in another


tsol <- tsol %>% 
  extract(sample, 
          c("lineage","rep"),
          "(Y[0-9]{3,4})\\_([A-C])")

library(Rtsne)

tsne <- tsol %>% 
  Rtsne(perplexity = 2,
        check_duplicates = FALSE)

#perplexity is one of the arguments than can be altered - it is a smoothing of the number of neighbours.

dat2 <- data.frame(tsne$Y)

dat2 %>% ggplot(aes(x = X1, y = X2)) +
  geom_point(size=0.5)
