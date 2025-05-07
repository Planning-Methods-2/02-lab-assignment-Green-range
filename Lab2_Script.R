# Lab 2 Script: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II

#---- Objectives ----
# In this Lab you will learn to:

# 1. Load datasets into your R session -> open the `Lab2_script.R` to go over in class.
# 2. Learn about the different ways `R` can plot information
# 3. Learn about the usage of the `ggplot2` package


#---- Part 1: Loading data ----

# Data can be loaded in a variety of ways. As always is best to learn how to load using base functions that will likely remain in time so you can go back and retrace your steps. 
# This time we will load two data sets in three ways.


## ---- Part 1.1: Loading data from R pre-loaded packages ----

data() # shows all preloaded data available in R in the datasets package
help(package="datasets") #Function will load datasets to provide help 

#Let's us the Violent Crime Rates by US State data 

help("USArrests") #function loads the data for arrests 

# Step 1. Load the data in you session by creating an object

usa_arrests<-datasets::USArrests # this looks the object 'USAarrests' within '::' the package 'datasets'

class(usa_arrests) #Class function lets me know that "usa_arrests" is a data.frame 
names(usa_arrests)#names pulls the list of column names in this dataset
dim(usa_arrests)#pulls the matrix from the dataset usa_arrests, 50 (states) and 4 Columns 
head(usa_arrests) #quick preview of initial start of the dataset
tail(usa_arrests) #quick preview of the end of the dataset 
summary(usa_arrests)

## ---- Part 1.2: Loading data from your computer directory ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512
> library(readr)
> accelaissuedpermitsextract <- read_csv("02-lab-assignment-Green-range/datasets/accelaissuedpermitsextract.csv")
building_permits_sa<-read.csv(file ="datasets/accelaissuedpermitsextract.csv",header = T) #opens dataset (although it is not )

names(building_permits_sa) #class function lets me knw the list of the names in the dataset
View(building_permits_sa) #open the dataset on a different tab 
class(building_permits_sa) #tells me what kind of class (ex: dataset, function, etc... )
dim(building_permits_sa) #shows me the end of the list of the matrix
str(building_permits_sa) #gives me a structured summary of the dataset
summary(building_permits_sa) #give overview of statistics


## ---- Part 1.3: Loading data directly from the internet ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa2 <- read.csv("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/accelaissuedpermitsextract.csv",header = T)





## ---- Part 1.4: Loading data using a package + API ----
#install.packages("tidycensus")
#install.packages("tigris")
help(package="tidycensus") # loads database on all packages available and gives help as 
library(tidycensus) #function library loads and installs the package -in this case tidycensus
library(tigris) #function library loads and installs the package -in this case tigris


#type ?census_api_key to get your Census API for full access.

age10 <- get_decennial(geography = "state", 
                       variables = "P013001", 
                       year = 2010) #age 10 is the object name, get decenial is a tidycensus package function that pull ups data (demographics,housing,population, etc) from the USCensusDecenial 
#Census Bureau in this case, state, median age, and year

head(age10) #head is the function and age 10 is the object assigned to include the state/ median age/ and year, using head function will give you the first 6 rows of the matrix 


bexar_medincome <- get_acs(geography = "tract", variables = "B19013_001",
                           state = "TX", county = "Bexar", geometry = TRUE) #bexar_medincome is the object with has been assigned to pull data through the function: get_acs from the american community survey


View(bexar_medincome) #view is the function that opens the data into another tab

class(bexar_medincome) #the class function tells you what type of information you pull, in this case, bexar_medincome is a data frame

#---- Part 2: Visualizing the data ----
#install.packages('ggplot2')

library(ggplot2) #loads and installs package ggplot2



## ---- Part 2.1: Visualizing the 'usa_arrests' data ----

ggplot(usa_arrests)  #function provides a blank page, 
 #function provides a blank page, nothing shows up for usa_arrrests

#scatter plot - relationship between two continuous variables
ggplot(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) +
  geom_point() #ggplot function pulls up data of assualt and murders and mapped it in in a scatter plot

ggplot() +
  geom_point(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) #this is another way to get the same scatter plot


#bar plot - compare levels across observations
usa_arrests$state<-rownames(usa_arrests) #usa_arrests object gets added through a dollar sign -states, to the row names of the data set

ggplot(data = usa_arrests,aes(x=state,y=Murder))+
  geom_bar(stat = 'identity')

ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder))+
  geom_bar(stat = 'identity')+
  coord_flip() #ggplot function  pulls the data from us_arrest  and pulls murder by state  in a bar graph

# adding color # would murder arrests be related to the percentage of urban population in the state?
ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder,fill=UrbanPop))+
  geom_bar(stat = 'identity')+
  coord_flip() #ggplot function  pulls the data from us_arrest  and pulls murder by state  in a bar graph, this time adding fill- urban pop generates colorscheme

# adding size
ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point() #ggplot function  pulls the data from us_arrest  and pulls murder by state  in a plot graph, adding size to urban pop changes the sizes of the dots in plots to correlate to data


# plotting by south-east and everyone else 

usa_arrests$southeast<-as.numeric(usa_arrests$state%in%c("Florida","Georgia","Mississippi","Louisiana","South Carolina")) 
# usa_arrests object adds the southeast through dollar, the as.numeric function assigns true/ false as 1 or 0  as in state is or is not in the southeast



ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop, color=southeast)) +
  geom_point() #ggplot functions puts the data in usa_arrests, into geometric point graph, size-urban pop changes size of dots, while color is added only to southeast

usa_arrests$southeast<-factor(usa_arrests$southeast,levels = c(1,0),labels = c("South-east state",'other')) #this code adds 


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_wrap(southeast~ .) #plots are wrapped into a single line, or a new one if necessary, the facet wrap function creates separate plots "facets" for each level in a wrapped layout


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_grid(southeast ~ .) #plots are in a strict row column/ facet grid creates a grid of plots, using one variable for rows and another one for columns 

## ---- Part 3: Visualizing the spatial data ----
# Administrative boundaries


library(leaflet)
library(tigris)

bexar_county <- counties(state = "TX",cb=T)
bexar_tracts<- tracts(state = "TX", county = "Bexar",cb=T)
bexar_blockgps <- block_groups(state = "TX", county = "Bexar",cb=T)
#bexar_blocks <- blocks(state = "TX", county = "Bexar") #takes lots of time


# incremental visualization (static)

ggplot()+
  geom_sf(data = bexar_county)

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])+
  geom_sf(data = bexar_tracts)

p1<-ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",],color='blue',fill=NA)+
  geom_sf(data = bexar_tracts,color='black',fill=NA)+
  geom_sf(data = bexar_blockgps,color='red',fill=NA)

ggsave(filename = "02_lab/plots/01_static_map.pdf",plot = p1) #saves the plot as a pdf



# incremental visualization (interactive)

#install.packages("mapview")
library(mapview)


mapview(bexar_county)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)+
  mapview(bexar_blockgps)


#another way to vizualize this
leaflet(bexar_county) %>%
  addTiles() %>%
  addPolygons()

names(table(bexar_county$NAME))

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons()

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups")

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups") %>%
  addLayersControl(
    overlayGroups = c("county", "tracts","block groups"),
    options = layersControlOptions(collapsed = FALSE)
  )



