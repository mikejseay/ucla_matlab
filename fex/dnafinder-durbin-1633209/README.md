# durbin
Perform the Durbin test for balanced incomplete block design<br/>
In the analysis of designed experiments, the Friedman test is the most common
non-parametric test for complete block designs. The Durbin test is a
nonparametric test for balanced incomplete designs that reduces to the Friedman
test in the case of a complete block design.
In a randomized block design, k treatments are applied to b blocks. In a
complete block design, every treatment is run for every block.
For some experiments, it may not be realistic to run all treatments in all
blocks, so one may need to run an incomplete block design. In this case, it is
strongly recommended to run a balanced incomplete design. A balanced incomplete
block design has the following properties:
   1. Every block contains k experimental units.
   2. Every treatment appears in r blocks.
   3. Every treatment appears with every other treatment an equal number of times.

The Durbin test is based on the following assumptions:
   1. The b blocks are mutually independent. That means the results within one block do not affect the results within other blocks.
   2. The data can be meaningfully ranked (i.e., the data have at least an ordinal scale).

Syntax: 	durbin(x,alpha)
     
    Inputs:
          x (mandatory) - data matrix
          alpha (optional) - significance level (default = 0.05).

    Outputs:
          T1 statistic and chi square approximation
          T2 statistic and F approximation
          Multiple Comparisons (eventually)
T1 was the original statistic proposed by James Durbin, which would have an
approximate null distribution of chi-square.
The T2 statistic has slightly more accurate critical regions, so it is now the
preferred statistic. The T2 statistic is the two-way analysis of variance
statistic computed on the ranks R(Xij).

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2010). Durbin: Durbin nonparametric test for balanced incomplete designs
http://www.mathworks.com/matlabcentral/fileexchange/26972
