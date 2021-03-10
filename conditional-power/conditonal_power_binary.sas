*** calculating upper one-sided conditional power for a z-test at one interim analysis**;
*** using https://ncss-wpengine.netdna-ssl.com/wp-content/themes/ncss/pdf/Procedures/PASS/Conditional_Power_of_Tests_for_the_Difference_Between_Two_Proportions.pdf;

/* checking example from the file for z_interim=1, conditional power should be 0.16858
data a; 
****** interim *************;
* observed proportion at interim;
*p2_interim=11/29;
*p1_interim=12/23;
* observed sample size at interim;
n2_interim=30;
n1_interim=30;
****** final *************;
*targeted difference;
alpha=0.025; * one sided interim;
p2=0.7;
p1=0.6;
* final sample size;
n2=60; 
n1=60;  
pavg=(P2 + P1)/2;
sigma2=pavg*(1-pavg);
theta=(p2-p1); *expected/targeted difference;
*********************;
I_interim=sigma2**(-1) * ( 1/n1_interim + 1/n2_interim )**(-1);
I=sigma2**(-1) * (1/n1 + 1/n2)**(-1);
* z_interim=(p2_interim-p1_interim)*sqrt(I_interim); * z-statistic @interim;
z_interim=1;
********************;
* upper one-sided conditional power **;
numerator=z_interim*sqrt(I_interim) -probit(1-alpha)*sqrt(I) + (p2-p1)*(I-I_interim);
denominator=sqrt( I-I_interim);
upper_cond_power=probnorm(numerator/denominator);
run;

proc print;run;
*/



** note that p2= proportion in the experimental arm;
*********and p1=proportion on the control group;
** for this case: planning was p2=0.30, p1=0.05;
** observed was p2= 11/29=0.38 and p1=12/23=0.52, so not in the direction expected; 

*** testing H0: p2-p1 <=0 vs H1: p2-p1 > 0;
** note that group A (diltiazem) is expected the higher proportion than group B (placebo);
** so p2 refers to group A and p1 refers to group B;
data a; 
****** interim *************;
* observed proportion at interim;
p2_interim=11/29;
p1_interim=12/23;
* observed sample size at interim;
n2_interim=29;
n1_interim=23;
****** final *************;
*targeted difference;
alpha=0.025; * one sided interim;
do p2=0.10 to 0.80 by 0.02 ;* note: observed: 0.38 with a SD=sqrt(p(1-p)/n)=0.1;
do p1= 0.05 to p2 by 0.02;
* final sample size;
n2=36; 
n1=36;  
pavg=(P2 + P1)/2;
sigma2=pavg*(1-pavg);
theta=(p2-p1); *expected/targeted difference;
*********************;
I_interim=sigma2**(-1) * ( 1/n1_interim + 1/n2_interim )**(-1);
I=sigma2**(-1) * (1/n1 + 1/n2)**(-1);
I_fraction=I_interim/I;
z_interim=(p2_interim-p1_interim)*sqrt(I_interim); * z-statistic @interim;
********************;
* upper one-sided conditional power **;
numerator=z_interim*sqrt(I_interim) -probit(1-alpha)*sqrt(I) + (p2-p1)*(I-I_interim);
denominator=sqrt( I-I_interim);
upper_cond_power=probnorm(numerator/denominator);
output;
end;end;
run;

/* low conditional power
proc print; var p2_interim p1_interim p2 p1 i_fraction upper_cond_power;run;
*/

** make heatmap, only possible in sas  on demand (internet app);
* so has been run separately **;
data b; set a; 
label p2="true (population) proportion group A"; label p1="true (population) proportion group B";
run;

proc sgplot data=b;
heatmapparm x=p2 y=p1 colorresponse=upper_cond_power;
run;
 
*** ifthe p2 probability runs up to 100%: conditional power at most 17.4%; 
data a; 
****** interim *************;
* observed proportion at interim;
p2_interim=11/29;
p1_interim=12/23;
* observed sample size at interim;
n2_interim=29;
n1_interim=23;
****** final *************;
*targeted difference;
alpha=0.025; * one sided interim;
do p2=0.10 to 1.00 by 0.02 ;* note: observed: 0.38 with a SD=sqrt(p(1-p)/n)=0.1;
do p1= 0.05 to p2 by 0.02;
* final sample size;
n2=36; 
n1=36;  
pavg=(P2 + P1)/2;
sigma2=pavg*(1-pavg);
theta=(p2-p1); *expected/targeted difference;
*********************;
I_interim=sigma2**(-1) * ( 1/n1_interim + 1/n2_interim )**(-1);
I=sigma2**(-1) * (1/n1 + 1/n2)**(-1);
I_fraction=I_interim/I;
z_interim=(p2_interim-p1_interim)*sqrt(I_interim); * z-statistic @interim;
********************;
* upper one-sided conditional power **;
numerator=z_interim*sqrt(I_interim) -probit(1-alpha)*sqrt(I) + (p2-p1)*(I-I_interim);
denominator=sqrt( I-I_interim);
upper_cond_power=probnorm(numerator/denominator);
output;
end;end;
run;

/* low conditional power
proc print; var p2_interim p1_interim p2 p1 i_fraction upper_cond_power;run;
*/

** make heatmap, only possible in sas  on demand (internet app);
* so has been run separately **;
proc means data=a max; var upper_cond_power;run;
data b; set a; 
label p2="true (population) proportion group A"; label p1="true (population) proportion group B";
run;


proc sgplot data=b;
heatmapparm x=p2 y=p1 colorresponse=upper_cond_power;
run;
 

