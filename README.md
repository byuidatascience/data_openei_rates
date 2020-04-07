# data_openei_rates
Scraped for every location in the US. </br>
Provides critical information regarding peak-shifting energy cost reduction strategies. </br>
Will allow the use of relatively realistic cost and saving values. </br>

The current csv files that are in the repository are broken up into smaller portions in order to fit in the repository. They are meant to be joined and treated as one dataset. They were pulled in March 2020 and are accurate up to then. For future data, the script may be required to run. 

There are many columns that describe use the naming convention of demandWkdaymonthhour, energyWkdaymonthhour etc. that describe the rate structure according to the schedule. For example, demandWkdaymonth1hour1 would be the the weekday rate structure under the demand tab for January, between 12AM-1AM. 

Issues: It is difficult to know exactly which rate plan a store is on. As well, the script to scrape the data takes a bit of time and could be made more efficiently. </br>


---


Utility_Name : </br>
Rate_Name : </br>
ELA_Id : The Energy Information Administration id.  </br>
Demand_Rate_Flat : Demand Rate </br>
Demand_RateT : Tiered Demand Usage </br>
Energy_RateT : Tiered Energy Usage </br>
demandWkdaymonthhour : </br>
demandWkeddaymonthhour: </br>
energyWkdaymonthhour: </br>
energyWkendmonthhour: </br>
</br>

---

**Example** : 
![Screen Shot 2020-04-02 at 12 26 37 AM](https://user-images.githubusercontent.com/45865457/78217365-2a6ef100-7479-11ea-8ea2-4fae4d0e2f77.png)
![Screen Shot 2020-04-02 at 12 26 28 AM](https://user-images.githubusercontent.com/45865457/78217378-2e9b0e80-7479-11ea-8d2f-45ce12555d52.png)
