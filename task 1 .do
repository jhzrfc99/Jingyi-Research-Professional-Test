*Research Professional Test
*.             Task 1: Earnings Announcements for European Firms
* Programming:
*   Stata Version:  Stata 17
*   Last Modified:  April 12 2023

***********************************************************************
* Set the critical parameters of the computing environment.
********************************************************************** 
* Specify the version of Stata to be used in the analysis:
    version 17
* Clear all computer memory and delete any existing stored graphs and matrices:
    clear all
* Turn off space bar for more results (personal preference): 
	set more off
* Close any open logs:
	cap log close
* Define the local directory:
	*all files created in this program will be saved in this folder*
    cd "/Users/yaoyao/Desktop/Wharton_test_Jingyi/Data"
* Open a log to contain a permanent record of the syntax and analytic output. 
	log using task1.txt, text replace
	
********************************************************************** 
* Organize data and merge the two dataset
********************************************************************** 
* First, using the functions of Excel to extract the last six digits of "cusip" as the new variable "sedol" of the "EuropeEAs" dataset. And, convert "fqendt" and "pends" to "day/month/year" format.
* Open the dataset, name and label the variables and their values.
    use "EuropeEAs.dta", clear	
* Rename "pends" to "fqenddt" for later merging	
rename pends fqenddt
* Merge the two dataset according to "sedol" (firm-quarters) and "fqenddt" (fiscal quarter end date)
merge m:m sedol fqenddt using Europefirmquarters.dta
* Drop those fail to get matched
drop if _merge ==1
drop if _merge ==2
* Drop the variable "_merge" created during the process of merge
drop _merge


***********************************************************************
* Specify the day investors can trade in response to the earnings announcement
***********************************************************************
* 1. Creat a new variable represent the date firms can actually trade
gen trading_date = .
* 2. Convert the string varibales "anntims" and "anndats" to the time format variable which STATA can specify 
gen time = clock(anntims, "hms")
gen date_DMY = date(anndats, "DMY")
* 3. Given that market close after 16:30:00 every day, if the announcement happens after that time, firms can only trade on the next day
replace trading_date = date_DMY if time >= 0 & time < 59400000
replace trading_date = date_DMY + 1 if time >= 59400000
format trading_date %td DD/MM/YYYY
display trading_date

***********************************************************************
* Clean and organize the final dataset
***********************************************************************
* 1. Check if there are some duplicace 
duplicates report sedol trading_date
duplicates drop sedol trading_date, force
* 2. Delete auxiliary variable contain those relevant to the research topic
drop time date_DMY 
