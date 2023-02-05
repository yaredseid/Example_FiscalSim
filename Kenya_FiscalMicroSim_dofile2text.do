*===============================================================================
		*1. Preamble
*===============================================================================		
	version 17
	clear all
	macro drop _all
	set linesize 200	

	global ys_archives	= 0		// =1, to archive dofiles, =0 turns OFF, so doesn't archive 
	local margin = 0.75		// setting left & right margins of dofiles "translate" to pdf   
	local font = 10			// setting font size of dofiles "translate" to pdf  


*===============================================================================
	* Basic project info and their assignement to global macros 
*===============================================================================		
	global ys_DateStamp: display %tdCCYY-NN-DD date(c(current_date), "DMY")

	global ys_EPL_Projects 		"C:\Users\wb484182\OneDrive - WBG\1ys_EPL\1Projects" 	
	global countryName 			"Kenya" 
	global fiscal_year			"2022FY"
	global simulationName		"FiscalMicroSim"

	
	/* Please change this to your own path */
	if (lower("`c(username)'") == "wb484182"){ 		// Yared's microsim documentation path 
		global documentationPath "${ys_EPL_Projects}\\${countryName}-${fiscal_year}-${simulationName}\\Assessments_dofile2text" 
	}
	else if (lower("`c(username)'") == ""){		    	
		global documentationPath " "			// put your own folder path here 
	} 

			
*===============================================================================
		*2. Global paths to data cleaning directories
*===============================================================================	
	/* Global macros for dofiles departing and destination assessments/microsim folders */
	global destin_data  	 	"${documentationPath}\\dofile2text_data"    
	global depart_data			"${ys_EPL_Projects}\\${countryName}-${fiscal_year}-${simulationName}\\Assessments\\DataCleaning"			

	/* Global macros for dofiles departing and destination assessments/microsim folders */
	global destin_assess 	"${documentationPath}\\dofile2text_microsim"    
	global depart_assess			"${ys_EPL_Projects}\\${countryName}-${fiscal_year}-${simulationName}\\Assessments\\${simulationName}\\02.Dofile"


*===============================================================================
		*3. Printing data cleaning do files and ado files into text files   
*===============================================================================
	/* dofiles in dataCleaning */
	local dofiles_data : dir "${depart_data}" files "*.do", respectcase // respectcase=keeps vapitalization as it is
	qui foreach z of local dofiles_data{
		local z2 = subinstr("`z'", ".do", "", .)			// droping ".do" in the string name
		dis _n  "`z2'"
	
		/* Archiving the dofiles */	
		if ${ys_archives} ==1 {  // if archives ==1, it puts date stamp 
		translate "${depart_data}\\`z2'.do" "${destin_data}\\1Archived\\`z2'-[${ys_DateStamp}].txt", translator(smcl2txt) replace 
		}
		/* This part turns the archiving OFF, so it doesn't archive  */
		else if ${ys_archives} !=1 {	// if archive !=1, it DOES NOT put a date stamp on log file 
		translate "${depart_data}\\`z2'.do" "${destin_data}\\`z2'.pdf", translator(smcl2pdf) replace lmargin(`margin') rmargin(`margin')  fontsize(`font') 

}
	*
}
	
	
	/* adofiles in dataCleaning */
	local adofiles_data : dir "${depart_data}\\DataAdos" files "*.ado", respectcase
	qui foreach z of local adofiles_data{
		local z2 = subinstr("`z'", ".ado", "", .)			// droping ".ado" in the string name
		dis _n  "`z2'"
		
		/* Archiving the adofiles */	
		if ${ys_archives} ==1 {  // if archives ==1, it puts date stamp 
		translate "${depart_data}\\DataAdos\\`z2'.ado" "${destin_data}\\DataAdos\\1Archived\\`z2'-[${ys_DateStamp}].txt", translator(smcl2txt) replace 
		}
			/* This part turns the archiving OFF, so it doesn't archive  */
		else if ${ys_archives} !=1 {	// if archive !=1, it DOES NOT put a date stamp on log file 
	translate "${depart_data}\\DataAdos\\`z2'.ado" "${destin_data}\\DataAdos\\`z2'.pdf", translator(smcl2pdf) replace lmargin(`margin') rmargin(`margin')  fontsize(`font') 
		}
	
}
*
*===============================================================================


*===============================================================================
		*4. Printing the microsim assessment do files into pdf 
*===============================================================================
	/* dofiles in microsim assessments */
	local dofiles_assess : dir "${depart_assess}" files "*.do", respectcase
	qui foreach z of local dofiles_assess{
		local z2 = subinstr("`z'", ".do", "", .)			// droping ".do" in the string name
		dis _n  "`z2'"
		
		/* Archiving the adofiles */	
		if ${ys_archives} ==1 {  // if archives ==1, it puts date stamp 
		translate "${depart_assess}\\`z2'.do" "${destin_assess}\\1Archived\\`z2'-[${ys_DateStamp}].txt", translator(smcl2txt) replace
		}
		/* This part turns the archiving OFF, so it doesn't archive  */
		else if ${ys_archives} !=1 {	// if archive !=1, it DOES NOT put a date stamp on log file
	  translate "${depart_assess}\\`z2'.do" "${destin_assess}\\`z2'.pdf", translator(smcl2pdf) replace lmargin(`margin') rmargin(`margin')  fontsize(`font') 
		}
}
	*
*===============================================================================

exit 
