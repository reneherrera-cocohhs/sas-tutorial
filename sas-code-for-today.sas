/* read mortality data */
PROC IMPORT datafile="S:/HIPAA Compliance/SAS Files/Coconino Deaths/All Death/COCONINO_deaths_2021_pii.csv"
    out=deaths
    dbms=csv
    replace;
RUN;

/* view mortality data */
PROC PRINT data=work.deaths;
run;

/* subset mortality data to suicide only */
/* variable name is cdc_mannerofdeath_desc */
DATA work.suicide;
    SET work.deaths;
    IF (CDC_MANNEROFDEATH_DESC = "SUICIDE") THEN OUTPUT;
RUN;

/* descriptive statistics of decedent_years */
PROC MEANS data = work.suicide n min max mean median;
    var DECEDENT_YEARS;
RUN;

/* boxplot */
PROC BOXPLOT data = work.suicide;
    plot DECEDENT_YEARS*DEATH_BOOK_YEAR;
RUN;

/* histogram */
PROC SGPLOT data = work.suicide;
    histogram DECEDENT_YEARS;
RUN;

DATA work.suicide;
    SET work.suicide;
	IF DECEDENT_YEARS =. THEN age_group=.;
    ELSE IF DECEDENT_YEARS <25 THEN age_group = "0-25";
	ELSE IF DECEDENT_YEARS >=25 and DECEDENT_YEARS <45 THEN age_group = "25-44";
	ELSE IF DECEDENT_YEARS >=45 and DECEDENT_YEARS <65 THEN age_group = "45-64";
	ELSE IF DECEDENT_YEARS >=65 THEN age_group = ">=65";
RUN;

PROC FREQ DATA=work.suicide age_group;
RUN;
	
