# Using R and Oracle Together (ROracle)


## High level steps
1. go to your installation of your oracle client tools
2. Check if they are 32 or 64 bit (check if you have lib and lib64, if just lib, then you have 32 bit version)
3. make sure you're in the version of R that is the same as your version of oracle client tools
    * put an updated tnsnames.ora file in the network/admin directory:
	```
	C:\oracle\product\10.2.0\client_1\network\ADMIN
	```
4. set environment variables up (either temporary in R or in system environment variable):
	
	In R:
	
	```
	# these can be done as system environment variables as well if you prefer
	
	# I asked someone at my company for an updated tnsnames.ora file
	
	# if you're in 32 bit oracle client / 32 bit R:
	
	Sys.setenv("ORACLE_HOME"="C:\oracle\product\10.2.0\client_1")   # or wherever yours is
	Sys.setenv("OCI_INC"="C:\oracle\product\10.2.0\client_1\oci\include")  
	Sys.setenv("OCI_LIB32"="C:\oracle\product\10.2.0\client_1\bin")
	Sys.setenv("TNS_ADMIN"="C:/oracle/product/10.2.0/client_1/network/ADMIN")
	# only difference in a 64 bit version above would be using "OCI_LIB64" instead of "OCI_LIB32"
	```
	
5. now in the same R script / environment, run:
	```
	install.packages("ROracle")
	
	y  # execute a 'y' in response to if you're alright with compiling from source
	
	library(ROracle)  # load the library
	```
	
	**Note:** I already have compilers (mwing32 / mwing64) on my machine, not sure if those are necessary for that last step or not.
	
	g++ should work as well (just snag any of the gnu C compilers).
6. Inspect your tnsnames.ora file to find your database name, it should look like this
	
	```
	<database name> =
	
		(DESCRIPTION = 
		
			(ADDRESS....
	```
	
	You only need that first item <database name>
7. now in R, set up your driver and connect to the db
	```
	# for the <con> object, use the same name that you found in step 6 above
	
	drv <- ROracle::dbDriver("Oracle")
	
	con <- ROracle::dbConnect(drv=drv, username="", password="", dbname=<database name here>
	```
8. Write and fetch a query to test your connection:
	
	```
	# in R
	
	query1 <- ROracle::dbSendQuery(con, "select * from <tablename>")  # you'll have to know a table name
	
	result1 <- ROracle::fetch(query1)
	```


