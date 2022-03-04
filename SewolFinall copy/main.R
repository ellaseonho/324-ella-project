library(ggplot2)

# Import dataset name it sewol
sewol <- read.csv("sewol.csv")

# Viewing table
View(sewol)
# Summarise table
summary(sewol)

# Change "stokehold" to floor 1 
sewol$floor[sewol$floor  == "stokehold"] <- "1"

# Converts character into numeric:
sewol$floor <- as.numeric(sewol$floor)

# weird looking draft of something plausible for Raw vs. Age
ggplot(data = sewol) + geom_point(mapping = aes(x = Raw, y = location))

# interesting draft of something plaustible for type of person vs. floor they were on
ggplot(data = sewol) + 
  stat_summary(
    mapping = aes(x = Category.1, y = floor),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# kind of good count graph
ggplot(data = sewol) + 
  geom_bar(mapping = aes(x = Raw))

#good graphs i wanna use!!!

ggplot(data = sewol, mapping = aes(x = Raw, fill = Category.3)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = sewol) + 
  geom_bar(mapping = aes(x = Raw, fill = Category.1), position = "fill")

ggplot(data = sewol) + 
  geom_bar(mapping = aes(x = Raw, fill = Category.3), position = "fill")

# omg YES WHAT I WANTED
ggplot(data = sewol) + 
  geom_bar(mapping = aes(x = Raw, fill = Category.1), position = "dodge")

# OMG YEP
bar2 <- ggplot(data = sewol) + 
  geom_bar(
    mapping = aes(x = location, fill = Raw), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
bar2 + coord_flip()
bar2 + coord_polar()


