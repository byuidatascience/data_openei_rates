# Load libraries 
pacman::p_load(tidyverse, rvest, httr, sf, here, lubridate, stringr, magrittr, parallel, multidplyr)

# Create loop to get the urls for all the 
# Initialize empty dataframe for list of links to the individual pages 
RateLinks <- data.frame()

for (pagenum in 13:20) { 
  # On the main OpenEI page, when only commercial rates are searched and 500 values are viewed, 
  # You get the link below. There are a total of 50 pages to scrape the links from. The goal with
  # the first loop is to scrape all the links to navigate to the individual rate pages. 
  
  # Load the page
  main.page <- read_html(x = paste("https://openei.org/apps/USURDB/?rpp=500&sectors%5B0%5D=Commercial&service_type=&is_default=&search=&page=", 
                                   pagenum, 
                                   sep = ""))
  # Get link URLs
  urls <- main.page %>% # feed `main.page` to the next step
    html_nodes("td:nth-child(2) a") %>% # get the CSS nodes
    html_attr("href") # extract the URLs
  # Get link text
  links <- main.page %>% # feed `main.page` to the next step
    html_nodes("td:nth-child(2) a") %>% # get the CSS nodes
    html_text() # extract the link text
  # Combine `links` and `urls` into a data.frame
  PageList <- data.frame(RateName = links, urls = paste("https://openei.org",urls, sep = ""), stringsAsFactors = FALSE)
  # Combine the list of links and urls to the main list of links 
  RateLinks <- rbind(RateLinks,PageList)
}

# Break up links into groups
group <- rep(1:100, length.out = nrow(RateLinks)) # Splits the urls into the groups and then adds them 
RateLinks <- cbind(group, RateLinks)

# Create Loops to scrape the EIA Id and Seasonal/Monthly demand charge structure
# More data may be desired but for now this is the goal. 
for (num in 1:100) {
  start <- proc.time()
  df <- paste("DR", num, sep = "") # Create final partition name
  DemandRates <- data.frame() # Initialize empty dataframe for the demand rates. 
  RateLinkGroup <- RateLinks %>% 
    filter(group == num)
  for (url in RateLinkGroup$urls) { 
    # Get Utility Name
    Utility_Name <- read_html(url) %>% # feed url to the next step
      html_nodes("dd:nth-child(2)") %>% # get the CSS nodes
      html_text() %>% 
      `[[`(1) # extract the text
    
    # Get Rate Name
    Rate_Name <- read_html(url) %>% # feed url to the next step
      html_nodes("dd:nth-child(6)") %>% # get the CSS nodes
      html_text() %>% 
      `[[`(1) # extract the text
    
    # Get EIA Id
    EIA_Id <- read_html(url) %>% # feed url to the next step
      html_nodes("dd:nth-child(4)") %>% # get the CSS nodes
      html_text() %>% 
      `[[`(1) # extract the text
    
    # Get Demand Rate
    Demand_Rate <- read_html(paste(url, "#2__Demand", sep = "")) %>% # feed url to the next step
      html_nodes("[class = 'strux_view_cell']") %>% 
      html_text() %>% 
      `[[`(4)
    
    # Get Tiered Demand Usage
    Demand_RateT1 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#demand_rate_strux_table :nth-child(2) :nth-child(4)") %>% 
      html_text() 
    
    if (identical(Demand_RateT1,character(0))) {Demand_RateT1 <- "NA"}
    
    Demand_RateT2 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#demand_rate_strux_table :nth-child(3) :nth-child(4)") %>% 
      html_text() 
    
    if (identical(Demand_RateT2,character(0))) {Demand_RateT2 <- "NA"}
    
    Demand_RateT3 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#demand_rate_strux_table :nth-child(4) :nth-child(4)") %>% 
      html_text() 
    
    if (identical(Demand_RateT3,character(0))) {Demand_RateT3 <- "NA"}
    
    Demand_RateT4 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#demand_rate_strux_table :nth-child(5) :nth-child(4)") %>% 
      html_text() 
    
    if (identical(Demand_RateT4,character(0))) {Demand_RateT4 <- "NA"}
    
    # Get Tiered Energy Usage
    Energy_RateT1 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(2) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT1,character(0))) {Energy_RateT1 <- "NA"}
    
    Energy_RateT2 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(3) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT2,character(0))) {Energy_RateT2 <- "NA"}
    
    Energy_RateT3 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(4) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT3,character(0))) {Energy_RateT3 <- "NA"}
    
    Energy_RateT4 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(5) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT4,character(0))) {Energy_RateT4 <- "NA"}
    
    Energy_RateT5 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(6) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT5,character(0))) {Energy_RateT5 <- "NA"}
    
    Energy_RateT6 <- read_html(paste(url, "#3__Energy", sep = "")) %>% # feed url to the next step
      html_nodes("#energy_rate_strux_table :nth-child(7) :nth-child(5)") %>% 
      html_text() 
    
    if (identical(Energy_RateT6,character(0))) {Energy_RateT6 <- "NA"}
    
    # Dataframe for the specific rate information   
    RateInfo <- data.frame(Utility_Name = Utility_Name, 
                           Rate_Name = Rate_Name, 
                           EIA_Id = EIA_Id, 
                           Demand_Rate_Flat = Demand_Rate, 
                           Demand_RateT1 = Demand_RateT1,
                           Demand_RateT2 = Demand_RateT2,
                           Demand_RateT3 = Demand_RateT3,
                           Demand_RateT4 = Demand_RateT4, 
                           Energy_RateT1 = Energy_RateT1,
                           Energy_RateT2 = Energy_RateT2,
                           Energy_RateT3 = Energy_RateT3,
                           Energy_RateT4 = Energy_RateT4,
                           Energy_RateT5 = Energy_RateT5,
                           Energy_RateT6 = Energy_RateT6)
    
    # Scraping the schedules for the tiered energy use
    WeekdaySchedDem <- read_html(paste(url, "#2__Demand", sep = "")) %>% # feed url to the next step
      html_nodes("[id = 'data-demandWeekdaySched']") %>%
      html_text()
    
    for (month in 1:12) {
      for (hour in 1:24) {
        schedName <- paste("month", month, "hour", hour-1, sep = "")
        assign(schedName, WeekdaySchedDem %>% str_split_fixed("", n = 288) %>% `[[`(24*(month-1)+hour))
        # print(24*(month-1)+hour)
        RateInfo <- cbind(RateInfo, get(schedName))
        colnames(RateInfo)[24*(month-1)+hour+14] <- paste("demandWkday", schedName, sep = "")
      }
    }
    
    WeekendSchedDem <- read_html(paste(url, "#2__Demand", sep = "")) %>% # feed url to the next step
      html_nodes("[id = 'data-demandWeekendSched']") %>%
      html_text()
    
    for (month in 1:12) {
      for (hour in 1:24) {
        schedName <- paste("month", month, "hour", hour-1, sep = "")
        assign(schedName, WeekendSchedDem %>% str_split_fixed("", n = 288) %>% `[[`(24*(month-1)+hour))
        # print(24*(month-1)+hour)
        RateInfo <- cbind(RateInfo, get(schedName))
        colnames(RateInfo)[24*(month-1)+hour+302] <- paste("demandWkend", schedName, sep = "")
      }
    }
    
    WeekdaySchedEne <- read_html(paste(url, "#2__Demand", sep = "")) %>% # feed url to the next step
      html_nodes("[id = 'data-energyWeekdaySched']") %>%
      html_text()
    
    for (month in 1:12) {
      for (hour in 1:24) {
        schedName <- paste("month", month, "hour", hour-1, sep = "")
        assign(schedName, WeekdaySchedEne %>% str_split_fixed("", n = 288) %>% `[[`(24*(month-1)+hour))
        # print(24*(month-1)+hour)
        RateInfo <- cbind(RateInfo, get(schedName))
        colnames(RateInfo)[24*(month-1)+hour+590] <- paste("energyWkday", schedName, sep = "")
      }
    }
    
    WeekendSchedEne <- read_html(paste(url, "#2__Demand", sep = "")) %>% # feed url to the next step
      html_nodes("[id = 'data-energyWeekendSched']") %>%
      html_text()
    
    for (month in 1:12) {
      for (hour in 1:24) {
        schedName <- paste("month", month, "hour", hour-1, sep = "")
        assign(schedName, WeekendSchedEne %>% str_split_fixed("", n = 288) %>% `[[`(24*(month-1)+hour))
        # print(24*(month-1)+hour)
        RateInfo <- cbind(RateInfo, get(schedName))
        colnames(RateInfo)[24*(month-1)+hour+878] <- paste("energyWkend", schedName, sep = "")
      }
    }
    
    DemandRates <- rbind(DemandRates, RateInfo) %>% 
      distinct()
  }
  assign(df,DemandRates)
  print(num)
  print(proc.time() - start)
}

# Bind all the partitioned dataframes together 
OpenEI <- bind_rows(list(DR1, DR2, DR3, DR4, DR5, DR6, DR7, DR8, DR9, DR10,
                         DR11, DR12, DR13, DR14, DR15, DR16, DR17, DR18, DR19, DR20,
                         DR21, DR22, DR23, DR24, DR25, DR26, DR27, DR28, DR29, DR30,
                         DR31, DR32, DR33, DR34, DR35, DR36, DR37, DR38, DR39, DR40,
                         DR41, DR42, DR43, DR44, DR45, DR46, DR47, DR48, DR49, DR50,
                         DR51, DR52, DR53, DR54, DR55, DR56, DR57, DR58, DR59, DR60,
                         DR61, DR62, DR63, DR64, DR65, DR66, DR67, DR68, DR69, DR70,
                         DR71, DR72, DR73, DR74, DR75, DR76, DR77, DR78, DR79, DR80,
                         DR81, DR82, DR83, DR84, DR85, DR86, DR87, DR88, DR89, DR90,
                         DR91, DR92, DR93, DR94, DR95, DR96, DR97, DR98, DR99, DR100))

write_csv(OpenEI, "OpenEI.13_20.csv")
