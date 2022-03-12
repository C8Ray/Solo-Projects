#Moneyball Project -----
  #Load Data and Packages
install.packages("tidyverse")
library(tidyverse)
  batting <- read.csv("C:/Users/Caitlin Ray/Documents/Solo-Projects/Batting.csv")
  head(batting)
  str(batting)
#Look at At Bats
  head(batting$AB, 5)
#Look at doubles
  head(batting$X2B)
#Create Batting Average
 batting <-  batting %>% 
    mutate(BA = H/AB)
#Create On Base Percentage
  batting <- batting %>% 
    mutate(OBP = (H+BB+HBP)/(AB+BB+HBP+SF))
#Create Slugging Percentage
  batting <- batting %>% 
    mutate(SLG = ((H-X2B-X3B-HR)+(2*X2B)+(3*X3B)+(4*HR))/AB)
#Make sure our variables look correct
  str(batting)

#Load Salary Data
  sal <- read.csv("C:/Users/Caitlin Ray/Documents/Solo-Projects/Salaries.csv")
  str(sal)
# Remove batting data with yearID < 1985 prior to merging data sets
  batting1985 <- batting %>% 
    filter(yearID > 1984)
#Make sure it worked
  summary(batting1985$yearID)
#Merge the two dataframes based on playerID and yearID
  combo <- merge(sal,batting1985, c('playerID', 'yearID'))
#Did we get what we wanted?
  summary(combo)
#Take a look at why the "Lost Boys" were so special
  LostBoys <- combo %>% 
    filter(playerID == "giambja01"|playerID=="damonjo01"|playerID=="saenzol01") %>% 
    filter(yearID == 2001) %>% 
    select(playerID, H, X2B, X3B, HR, OBP, SLG, BA, AB, salary)
  LostBoys
#Replace the Lost Boys with the following constraints
  #Total combined salary < 15 mil
  #Combined AB = or >= Lost Boys
    comboAB <- sum(LostBoys$AB)
    comboAB
  #Mean OBP > or >= Lost Boys mean OBP
    avgOBP <- mean(LostBoys$OBP)  
    avgOBP  
#Clean up combo so it only includes the year we want and no Oakland As
    combo <- combo %>% 
      filter(yearID ==2001 & teamID.x != "OAK")
    theReplacements <- ggplot(combo, aes(OBP,salary))+
    geom_point()
  print(theReplacements)
#It looks like there's a dense pool of eligible players with low salary and OBP > .36
# Let's cap the salary at 7 million and take a look at those with >.25OBP
  theReplacements <- ggplot(combo, aes(OBP,salary))+
    geom_point()+
    xlim(0.25,1)+
    ylim(0, 7000000)
  print(theReplacements)
#Let's add ABs as a gradient, then we should be able to better select our parameters for editing the dataframe
  theReplacements <- ggplot(combo, aes(OBP,salary))+
    geom_point(aes(color=AB))+
    scale_color_gradient(low='blue', high='red')+
    xlim(0.25,1)+
    ylim(0, 7000000)
  print(theReplacements)
#Back to the data! I think we can reasonably remove those with <300 AB
  reps <- combo %>% 
    filter(AB>300)
#Lets take a look   
  theReplacements2 <- ggplot(reps, aes(OBP,salary))+
    geom_point(aes(color=AB))+
    scale_color_gradient(low='blue', high='red')+
    xlim(0.25,1)+
    ylim(0, 7000000)
  print(theReplacements2)
#Now that we have a reasonable pool, lets trim the data a bit for our possible replacement players
  # and the stats we are interested in
  reps <- reps %>% 
  arrange(desc(OBP)) %>% 
  filter(salary<7000000) %>% 
  select(playerID,salary,OBP,AB, SLG)
head(reps)
# We now have 4 to choose from!
reps5 <-head(reps) 
theReplacements2 <- ggplot(reps5, aes(OBP,salary, label=playerID))+
  geom_point(aes(color=AB))+
  geom_text(hjust=0, vjust=0)+
  scale_color_gradient(low='blue', high='red')+
  xlim(0.25,1)+
  ylim(0, 7000000)
print(theReplacements2)
#To stay within budget, lets choose heltoto, berkmla, and gonzalu
Final3 <- reps5[2:4,]
#Double check the parameters were not violated
mean(Final3$OBP)>avgOBP
sum(Final3$AB)>comboAB
sum(Final3$salary)/1000000
theReplacements2 <- ggplot(Final3, aes(OBP,salary, label=playerID))+
  geom_point(aes(color=AB))+
  geom_text(hjust=0, vjust=0)+
  scale_color_gradient(low='blue', high='red')+
  xlim(0.25,1)+
  ylim(0, 7000000)+
  theme_dark()
print(theReplacements2)

#How do we know we've selected the best possible replacement players based on OBP and ABs?
combo <- combo %>% 
  arrange(desc(OBP)) %>% 
  select(playerID, salary, AB, OBP) %>% 
  filter(AB>300)
head(combo)
#We did select the top 3 values for OBP given our salary constraint

#We should probably make a more meaningful plot with a comparison of our lost boys and our replacements
LostBoys <- LostBoys %>% 
  mutate(playerType= 'lost')
Final3 <- Final3 %>% 
  mutate(playerType= 'replacement')
comp <- bind_rows(LostBoys, Final3)%>% 
  select(playerID, OBP,AB,salary, playerType)

compsal <- ggplot(comp,aes(x= playerID, y=salary))+
  geom_col(aes(fill=playerType))+
  facet_wrap(vars(playerType))
print(compsal)
compstat <- ggplot(comp, aes(AB,OBP))+
  geom_point(aes(size= 4,color=salary))+
  scale_fill_gradient(low="green", high="red")+
  facet_wrap(vars(playerType))+
  theme_light()
print(compstat)
