*                       Research Professional Test
*                    Task 3: Inconsistent Disclosures
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
	log using task3.txt, text replace
* Open the dataset, name and label the variables and their values.
    use "InconsistentDisclosures.dta", clear	

***********************************************************************
* Provide two summary tables
**********************************************************************
tabstat inconsistent performance1, by(primarycategory) statistics(mean) format(%9.0g) save
gen year = year(date)
tabstat inconsistent performance1, by(year) statistics(mean) format(%9.0g) save


***********************************************************************
* OLS
********************************************************************** 
* Create dummy variables for primarycategory
tab primarycategory, gen(category)
* Run regression with dummy variables
reg performance1 inconsistent category* i.year 

