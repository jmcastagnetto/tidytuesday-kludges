The data came from [TidyTuesday, 2019-09-24]().

Two indices were calculated:

- Simpson's Diversity Index
  - [Measuring Diversity in the United States](https://www.csun.edu/~hcmth031/MDITUS.pdf)
- Shannon's Equitability Index
  - [DIVERSITY INDICES: SHANNON'S H AND E](http://www.tiem.utk.edu/~gross/bioed/bealsmodules/shannonDI.html)

Because the "multiethnic" category didn't exist for the 1994-1995 school year, I have assumed that value to be zero for all cases. This will affect the Shannon's index, because I am using ln(6) (~1.79) instead of ln(5) (~1.61) for the denominator.