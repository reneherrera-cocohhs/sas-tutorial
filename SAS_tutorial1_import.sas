/*Importing Data - Two most common methods of importing data into SAS are */
/*1. Setting up a SAS library*/
/*2. Using Proc Import*/
/**/

/*A SAS library is used if you already have SAS datasets available. Essentially you just tell SAS where the data is saved*/
/*and the program will pull the data into the SAS system.*/

/*To create a SAS library:*/
/*1. call the libname function*/
/*2. specify the name of the library, must be short 1-8 bytes */
/*3. insert the filepath to the folder where your data is stored*/
/*4. end your code with a ;*/
/**/
/*The name you give your sas library will serve as shortcut for the SAS system to know what folder location to pull data from*/

/*Documentation for creating SAS library via libname*/
/*https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/n1nk65k2vsfmxfn1wu17fntzszbp.htm#n00n9d4qhcdledn1d8amdxvj3dhl*/

/*Putting it all together*/

libname downs 'C:\Users\rherrera\projects\sas-tutorial';

/* downs is the nickname for path library name, names should be short between 1-8 bytes, downs then appears in explorer active libraries  */
/*  */

/*As you can see creatin a SAS library is very simple. However this is really on useful for bringing in SAS datasets. What if we have*/
/*data in an excel file, or csv file?*/
/**/
/*In these cases, you should use SAS's import procedure, aka proc import*/

/*Detailed information on proc import can he found here:*/
/*https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/proc/n18jyszn33umngn14czw2qfw7thc.htm*/

proc import /*invokes the import procedure*/
datafile = 'C:\Users\rherrera\projects\sas-tutorial\TSDataTable_3951_06_10_2022_20_53_26_7345.xlsx' /*specify which file you want to import to SAS*/
out = work.cli_data /*This is the name given to the name this data will have while it is within SAS's temporary work file*/
dbms = xlsx /*specifies the format is saved in. For excel use xlsx. For csv, use csv*/
replace; /*use this option if you want to overwrite the existing file if you were to reimport this data*/
run;


/*When data is imported, it is converted from whatever format to SAS format and stored internally within the SAS temporary work file.*/
/*If we want to save our data as a SAS data file, it is quite simple, we just export the data to our library file via a data step*/

data /*invokes a data step - which is used to create new data from existing data and allows for us to manipulate and change the data if needed*/
downs.cli_week38ish; /*Specifies the name and location the new data will be created*/ 
set work.cli_data; /*Specifies the existing data the new data should be based on*/
run;

/*Check you downloads file to see if a SAS dataset was created!*/

/*To pull this SAS data from your downloads file back into SAS it is quite simple, just use a data step to create a temporary work file in SAS*/

data
work.cli_week38ish;
set downs.cli_week38ish;
run;

/*downs.cli_week38ish data is now within SAS's temporary workfile. Working with data stored in the temporary workfile is better for processing and*/
/*speed. If you kept working with the data downs.cli_week38ish it would force SAS to go back and forth between the file on the network and the SAS*/
/*system, writing and rewriting the data. This process is slower, especially when on VPN*/

/*Cool, now lets check our data to see what types of variables it contains*/

proc contents data=work.cli_week38ish varnum;
run;

proc print data=work.cli_week38ish (obs=10); run;

/*Let's code the classifications of Hospitalizations based off the CLI*/

data work.cli_week38ish_v2;
set work.cli_week38ish;

if data = . then CLI_cat = .;
else if data < 5 then CLI_cat = 1;
else if  5 =< data < 10 then CLI_cat = 2;
else if 10 =< data then CLI_cat = 3;

run;

/*Now let's check the new variable we created and which proportion of our weeks fall into CLI categories 1, 2, or 3.*/
/*We will do this using proc freq*/

proc freq data=work.cli_week38ish_v2;
table CLI_cat / missing;
run;

/*We can format our numeric CLI_cat values so that when we view them they are a little more descriptive.*/
/*We can do this using proc format*/

proc format ;
value cat_desc
	1 = low
	2 = moderate
	3 = high
	;
run;

/*Now we can rerun our proc freq and apply the format so it is a little more informative*/
proc freq data=work.cli_week38ish_v2;
table CLI_cat / missing;
format CLI_cat cat_desc.;
run;


/*Finally, to highlight some of the analytic capabilities of SAS let's use the heart data from SASHelp to look at some continuous variables*/
/*and the information various SAS procedures can provide*/

proc univariate data=heart;
var height weight diastolic systolic;
histogram; *allows us to graphically see the distribution of continuous variables;
run;

proc freq data=heart;
table Chol_Status BP_Status Weight_Status Smoking_Status / missing;
run;





