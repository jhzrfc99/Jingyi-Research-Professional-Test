*                       Research Professional Test
*                          Task 2: Non-ESG News
* Programming:
*   Stata Version:  Stata 17
*   Last Modified:  April 13 2023

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
	log using task2.txt, text replace
	
********************************************************************** 
* Organize data in "allnews" and keep only observations have non-ESG news
********************************************************************** 
* First, check the "allnews" dataset to find out not-ESG news
* Open the dataset, name and label the variables and their values.
import delimited "/Users/yaoyao/Desktop/Wharton_test_Jingyi/Data/allnews.csv", varnames(1) 
* Have an overview of the news type
tab group
tab type
tab topic
* For "topic", "environment", " politics", and "society" are likely to be ESG-related
drop if topic == "environment"
drop if topic == "politics"
drop if topic == "society"
* Move to "group" again, check whether some observations relate to ESG
tab group
* No observations in "group" now relates to ESG, move to "type"
tab type
* For "type", there are still some news relate to ESG, drop them as below
drop if strpos(type, "accelerated-approval") > 0
drop if strpos(type, "automobile-accident") > 0
drop if strpos(type, "bankruptcy") > 0
drop if strpos(type, "breakthrough") > 0
drop if strpos(type, "industrial-accidents") > 0
drop if strpos(type, "exploration") > 0
drop if strpos(type, "efinery-accident") > 0
drop if strpos(type, "spill") > 0
drop if strpos(type, "clinical") > 0
drop if strpos(type, "competition") > 0
drop if strpos(type, "copyright") > 0
drop if strpos(type, "corruption") > 0
drop if strpos(type, "credit") > 0
drop if strpos(type, "cyber-attacks") > 0
drop if strpos(type, "debt") > 0
drop if strpos(type, "discrimination") > 0
drop if strpos(type, "dividend") > 0
drop if strpos(type, "drilling") > 0
drop if strpos(type, "earnings") > 0
drop if strpos(type, "economic-growth-guidance") > 0
drop if strpos(type, "embargo") > 0
drop if strpos(type, "employment") > 0
drop if strpos(type, "executive") > 0
drop if strpos(type, "expenses") > 0
drop if strpos(type, "explosion") > 0
drop if strpos(type, "exports") > 0
drop if strpos(type, "facility-accident") > 0
drop if strpos(type, "factory-accident") > 0
drop if strpos(type, "demand") > 0
drop if strpos(type, "earnings") > 0
drop if strpos(type, "environmental") > 0
drop if strpos(type, "grant") > 0
drop if strpos(type, "layoffs") > 0
drop if strpos(type, "major-shareholders-disclosure") > 0
drop if strpos(type, "union-pact") > 0

********************************************************************** 
* Merge the two dataset
********************************************************************** 
gen ESG_non = 1
merge m:m gvkey using ESGnews.dta
* 351,678 observations perfectly match
* Given that all firms in the "ESGnews" data should be covered, we drop the unmatched firms in "allnews"
drop if _merge == 1
* Exclude non-ESG news if the date of the non-ESG news event is on the same date
* To compare the "eventdate" and "article date", transform "evendate" into a same format as "article date"
* Transform date/month/YY into date/month/YYYY, thus STATA can recognize
replace eventdate = subinstr(eventdate, "/17", "/2017", .)
* Transform the string date/month/YYYY into time variable
gen eventdate_n = date(eventdate,"MDY")
format eventdate_n %d
gen article_date_n = date(article_date,"DMY")
format article_date_n %d
* Drop if "eventdate_n" equal to "article date"
drop if eventdate_n == article_date_n 
