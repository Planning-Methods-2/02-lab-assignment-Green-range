# Lab 2 Assignment: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Instructions ----

# 1. [40 points] Open the R file "Lab2_Script.R" comment each line of code with its purpose (with exception of Part 3)
# 2. [60 points] Open the R file "Lab2_Assignment.R" and answer the questions

#---- Q1. write the code to load the dataset "tract_covariates.csv" located under the "datasets" folder in your repository. Create an object called `opportunities` Use the data.table package to do this. ----
opportunities <-tract_covariates
#---- Q2. On your browser, read and become familiar with the dataset metadata. Next write the code for the following:
# Link to metadata: https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf 
install.packages(c("httr", "pdftools"))
library(httr)
library(pdftools)
pdf_url <- "https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf"
pdf_path <- "Codebook-for-Table-9.pdf"
GET(pdf_url, write_disk(pdf_path, overwrite = TRUE))
pdf_text_content <- pdf_text(pdf_path)
cat(pdf_text_content[1])
pdf_tables <- pdf_data(pdf_path)
print(pdf_tables)



# what is the object class?
class(opportunities) 
#class is character
# how can I know the variable names?
variable.names(tract_covariates)
 #names(opportunities) will show names in console
# What is the unit of analysis? 
head(opportunities)
#Units of analysis would be : Household, Individuals, State, Tract, County

# Use the `summary` function to describe the data. What is the variable that provides more interest to you?
summary(opportunities) #I gravitate towards population density and demographics such as ethnicities
# Create a new object called `sa_opportunities` that only contains the rows for the San Antonio area (hint: use the `czname` variable). 
sa_opportunities <- tract_covariates[tract_covariates$czname == "San Antonio", ]
head(sa_opportunities)

# Create a plot that shows the ranking of the top 10 census tracts by Annualized job growth rate (`ann_avg_job_growth_2004_2013` variable) by census tract (tract variable). Save the resulting plot as a pdf with the name 'githubusername_p1.pdf' # Hint: for ordering you could use the `setorderv()` or reorder() functions, and the ggsave() function to export the plot to pdf. 
library(ggplot2)
library(data.table)
library(dplyr)
library(tidyverse)
library(leaflet)
library(tigris)

setDT(opportunities)
setorderv(opportunities, "ann_avg_job_growth_2004_2013", order = -1)
top_10 <- opportunities[1:10, ]
View(top_10)

top_10 <- opportunities %>% 
  filter(!is.na(ann_avg_job_growth_2004_2013)) %>%
  arrange(desc(ann_avg_job_growth_2004_2013)) %>% head(10)

p <- ggplot(top_10, aes(x = reorder(tract, ann_avg_job_growth_2004_2013), 
                        y = ann_avg_job_growth_2004_2013)) +
  geom_col(fill = "steelblue") +
  coord_flip() +  
  labs(title = "Top 10 Census Tracts by Annualized Job Growth Rate (2004-2013)",
       x = "Census Tract",
       y = "Annualized Job Growth Rate") +
  theme_minimal()
  
ggsave("greenrange_p1.pdf", plot = p, width = , height = )
#my plots view don't generate, even when code runs, the pdf shows the plot, i did restart my computer, checked updates were made 

# Create a plot that shows the relation between the `frac_coll_plus` and the `hhinc_mean2000` variables, what can you hypothesize from this relation? what is the causality direction? Save the resulting plot as a pdf with the name 'githubusername_p3.pdf'
ggplot(opportunities, aes(x = frac_coll_plus2000, y = hhinc_mean2000)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(
    x = "Fraction with College Degree or Higher",
    y = "Mean Household Income in 2000",
    title = "Relationship between Education Level and Household Income"
  ) +
  theme_minimal()
ggsave("greenrange_p3.pdf", plot = p, width = , height = )

#Hypothesis: Individuals with a college degree or higher tend to make more money/ have a higher household income
#Causality: There is a positive correlation trend. However, Correlation does not equal Causation: there a multitude of factors that can affect either (socieconomic status, regional opportunities, etc)

# Investigate (on the internet) how to add a title,a subtitle and a caption to your last plot. Create a new plot with that and save it as 'githubusername_p_extra.pdf'
#I jumped the gun, so my previous plot has a title 








