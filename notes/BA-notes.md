spatial-microsim-book/course
=====================

Notes from:
* An Introduction to Spatial Microsimulation using R
* Dr Robin Lovelace and colleagues
* Date: 18/09/2014 - 19/09/2014
* Venue: Room S1,S044-01-0034, First Floor, Alison Richard Building, Sidgwick Site, University of Cambridge, Cambridge
 * http://www.ncrm.ac.uk/training/show.php?article=5088
 * Recommended pre-reading: http://eprints.ncrm.ac.uk/3348/
 * See also https://github.com/Robinlovelace/spatial-microsim-book 

General course notes
* Recent experience of speeding up R code a lot using a new package  - ipfp - http://cran.r-project.org/web/packages/ipfp/index.html
 * this package is very fast, you can specify iterations & startng weights (if you wish) but not, seemingly, a stopping rule according to convergence (although investigate the tol = parameter as this seems to be the sum of squares of the difference between the original constraint vector and the current fitted constraint vector at iterstion i (so essentialy TAE), so could be used to control iterations)
* Suggests looking at Flexible Modelling Framework (Harland) - alternative methods written in java
* github vs BitBucket - latter can have private repositories
 * use .gitignore to stop uploading particular files e.g. data/ or .dta
* Big shout for "Spatial Microsimulation: A Reference Guide for Users" http://www.springer.com/social+sciences/population+studies/book/978-94-007-4622-0
* suggests looking at Advanced Spatial Data Analysis in R (Bivand et al) http://www.springer.com/statistics/life+sciences,+medicine+%26+health/book/978-1-4614-7617-7
* Parallel processing
 * not worth using if datasets very small and you have a small number of cores as management overhead high
* Assumptions
 * individual data is representative
 * target vars of interest -> some function of constraints (might not be)
 * correlation between contraints & target vars is constant over space
 * relationship between constraint distributions/tables is same at local (constraints) & national (individual) levels

Other notes & conversations
* Spatial MSM is one option for small area estimation see: "Evaluations and improvements in small area estimation methodologies" http://eprints.ncrm.ac.uk/3210/
* Belgian models - contact = Gijs Dekkers (https://www.linkedin.com/profile/view?id=164500929) chief editor of the International Journal of Microsimulation (http://www.microsimulation.org/IJM/IJM_editorial_board.htm). 
 * open-source toolbox LIAM2 (http://liam2.plan.be), designed for the development of dynamic microsimulation models.
* Sweden - whole popn model http://www.researchgate.net/publication/253561368_The_SVERIGE_Spatial_Microsimulation_Model 
* Papers on IPF:
 * Simpson, L., & Tranmer, M. (2005). Combining sample and census data in small area estimates: Iterative Proportional Fitting with standard software. The Professional Geographer, 57(2), 222–234.
 * Wong, D. (1992). The Reliability of Using the Iterative Proportional Fitting Procedure∗. The Professional Geographer. Retrieved from http://www.tandfonline.com/doi/abs/10.1111/j.0033-0124.1992.00340.x
 * Norman, P. (1999). Putting iterative proportional fitting on the researcher’s desk. Retrieved from http://eprints.whiterose.ac.uk/5029
