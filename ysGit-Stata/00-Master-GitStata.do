//  Program:    00-Master-GitStata.do
**#  Task:      Runs Git codes for the project from Stata dofile 
//  Project:    Kenya Fiscal Microsim project 
//  Author:     Yared Seid - 2023Feb03


*===============================================================================
**# Preamble
*===============================================================================	
	version 17
	clear all
	set more off
	macro drop _all
	set linesize 200	
	set type double, permanently 
	
	local currDir: sysdir STATA				// change the directory to "...Stata\Data"
	cd "`currDir'Data"

	
local pathGit	"C:\Users\wb484182\OneDrive - WBG\1ys_EPL\1Projects\Kenya-2022FY-FiscalMicroSim\Assessments_dofile2text\ysGit-Stata"

local repoName "Assessments_dofile2text"

local dateStamp: display %tdCCYY-NN-DD date(c(current_date), "DMY")


/*
*===============================================================================
**# Basic Git Setup  -- needs to be run only once 
*===============================================================================
* Yared's profile 
! git config --global user.name "Yared Seid"
! git config --global user.email "yaredseid@gmail.com"

* Yared's choice of editor: notepad++
! git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

* Yared's default branch name: ysMain
! git config --global init.defaultBranch ysMain
*/

*===============================================================================
**# Running Git codes -- add, commit, push, pull, etc   
*===============================================================================
cd "`pathGit'"
cd ../

! .gitignore ysGit-Stata/		// ignoring my ysGit-Stata folder 

*! git pull
! git add -A 					// Add all new files  
! git commit -m "[Date `dateStamp']: "

! git push 
cd "`currDir'Data"
*===============================================================================

exit 





* Sample writing of Git batchfile from internet (https://medium.com/the-stata-guide/stata-and-github-integration-8c87ddf9784a)
file close _all
file open git using mygit.bat, write replace
file write git "git remote add origin " `"""' "https://github.com/asjadnaqvi/github-tutorial.git" `"""' _n
file write git "git add --all" _n
file write git "git commit -m "
file write git `"""' "minor fixes" `"""' _n
file write git "git push" _n
file close git



*===========================================
my batchfile copied here just as a show case 
*# Yared's profile 
git config --global user.name "Yared Seid"
git config --global user.email "yared.seid@gmail.com"

*# Yared's choice of editor: notepad++
git config --global core.editor "'C:/Users/wb484182/OneDrive/1ysOneDrive/1Drive5/0PortableApps/PortableApps/Notepad++Portable/notepad++.exe'
-multiInst -notabbar -nosession -noPlugin"

*# Yared's default branch name: ysMain
git config --global init.defaultBranch main


====
*===============================================================================
**# Git 
*===============================================================================		
	**# Basic Git Setup 
* Yared's profile 
! git config --global user.name "Yared Seid"
! git config --global user.email "yaredseid@gmail.com"

* Yared's choice of editor: notepad++
! git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

* Yared's default branch name: ysMain
! git config --global init.defaultBranch ysMain

	**# Create a new local repository from within the command line
! git init   					// initialize a Git repository 
dir .git/
! .gitignore ysGit/				// ignoring my ysGit folder 

! echo `"Day 1 [`dateStamp']: A day empty folder structure is auto created using Yared's generic Stata dofile"' >> README.md
! git add README.md
! git add . // -A 
! git commit -m `"Day 1 [`dateStamp']: A day empty folder structure is auto created using Yared's generic Stata dofile"'






