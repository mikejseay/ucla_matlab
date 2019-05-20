function durbin(data,varargin)
%DURBIN - perform the Durbin test for balanced incomplete block design
%In the analysis of designed experiments, the Friedman test is the most common
%non-parametric test for complete block designs. The Durbin test is a
%nonparametric test for balanced incomplete designs that reduces to the Friedman
%test in the case of a complete block design.
%In a randomized block design, k treatments are applied to b blocks. In a
%complete block design, every treatment is run for every block.
%For some experiments, it may not be realistic to run all treatments in all
%blocks, so one may need to run an incomplete block design. In this case, it is
%strongly recommended to run a balanced incomplete design. A balanced incomplete
%block design has the following properties:
%    1. Every block contains k experimental units.
%    2. Every treatment appears in r blocks.
%    3. Every treatment appears with every other treatment an equal number of times.
%
%The Durbin test is based on the following assumptions:
%    1. The b blocks are mutually independent. That means the results within one block do not affect the results within other blocks.
%    2. The data can be meaningfully ranked (i.e., the data have at least an ordinal scale).
%
% Syntax: 	durbin(x,alpha)
%      
%     Inputs:
%           x (mandatory) - data matrix
%           alpha (optional) - significance level (default = 0.05).
%
%     Outputs:
%           T1 statistic and chi square approximation
%           T2 statistic and F approximation
%           Multiple Comparisons (eventually)
%T1 was the original statistic proposed by James Durbin, which would have an
%approximate null distribution of chi-square.
%The T2 statistic has slightly more accurate critical regions, so it is now the
%preferred statistic. The T2 statistic is the two-way analysis of variance
%statistic computed on the ranks R(Xij).
%
%      Example 
%Supposing to have these data:
% data=[
%      2     3   NaN     1   NaN   NaN   NaN
%    NaN     3     1   NaN     2   NaN   NaN
%    NaN   NaN     2     1   NaN     3   NaN
%    NaN   NaN   NaN     1     2   NaN     3
%      3   NaN   NaN   NaN     1     2   NaN
%    NaN     3   NaN   NaN   NaN     1     2
%      3   NaN     1   NaN   NaN   NaN     2
% ];
%
% Calling on matlab durbin(data)
% the result will be:
%
% DURBIN TEST FOR IDENTICAL TREATMENT EFFECTS:
% TWO-WAY BALANCED, INCOMPLETE BLOCK DESIGNS
% --------------------------------------------------------------------------------
% Number of observation: 21
% Number of blocks: 7
% Number of treatments: 7
% Number of treatments for each block: 3
% Number of blocks for each treatments: 3
% --------------------------------------------------------------------------------
% A (sum of squares of ranks): 98.0000
% C (correction factor): 84.0000
% --------------------------------------------------------------------------------
% Chi-square approximation (more conservative)
% Durbin test statistic T1 (uncorrected): 12.0000
% chi-square=T1 df=6 - p-value (2 tailed): 0.0620
% --------------------------------------------------------------------------------
% F-statistic approximation (less conservative)
% Durbin test statistic T2 (corrected): 8.0000
% F=T2 df-num=2 df-denom=8 - p-value (2 tailed): 0.0123
% --------------------------------------------------------------------------------
% The 7 treatments have not identical effects
%  
% POST-HOC MULTIPLE COMPARISONS
% --------------------------------------------------------------------------------
% Critical value: 2.8243
% Absolute difference among mean ranks
%      0     0     0     0     0     0     0
%      1     0     0     0     0     0     0
%      4     5     0     0     0     0     0
%      5     6     1     0     0     0     0
%      3     4     1     2     0     0     0
%      2     3     2     3     1     0     0
%      1     2     3     4     2     1     0
% 
% Absolute difference > Critical Value
%      0     0     0     0     0     0     0
%      0     0     0     0     0     0     0
%      1     1     0     0     0     0     0
%      1     1     0     0     0     0     0
%      1     1     0     0     0     0     0
%      0     1     0     1     0     0     0
%      0     0     1     1     0     0     0
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2010). Durbin: Durbin nonparametric test for balanced incomplete designs
% http://www.mathworks.com/matlabcentral/fileexchange/26972

%Input handling
p = inputParser;
addRequired(p,'data',@(x) validateattributes(x,{'numeric'},{'2d','real','nonempty'}));
addOptional(p,'alpha',0.05, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','nonnan','>',0,'<',1}));
parse(p,data,varargin{:});
alpha=p.Results.alpha;
clear p

[I,J]=find(~isnan(data)); 
[I,idx]=sort(I); J=J(idx); 
ind=sub2ind(size(data),I,J); x=[data(ind) I J];
clear I J ind idx

o=size(x,1); %number of observation
b=max(x(:,2)); %number of blocks
%check if each block has the same number of tratments
len=rlencode(x(:,2));
if ~isequal(len./len(1),ones(size(len)))
    error('Warning: Every block must contain the same k experimental units.')
else
    k=len(1);
end
t=max(x(:,3)); %number of tratments
%check if every treatment appears in r blocks
len=rlencode(sort(x(:,3)));
if ~isequal(len./len(1),ones(size(len)))
    error('Warning: Every treatment must appear in r blocks.')
else
    r=len(1);
end
clear len

%check if every treatment must appear with every other treatment an equal number
%of times
y=zeros(t,t);
for I=1:o
    y(x(I,2),x(I,3))=y(x(I,2),x(I,3))+1;
end
for I=1:t
    z=y(y(:,I)==1,:);
    z(:,I)=[];
    s=sum(z);
    if ~isequal(s,ones(size(s)))
        error('Warning: Every treatment must appear with every other treatment an equal number of times.')
    end
end
clear z s

%If all conditions are respected, then start the Durbin test
Rxij=zeros(size(y));
for I=1:b
    Rxij(I,y(I,:)==1)=tiedrank(x(x(:,2)==I),1)'; %ranks for each block
end
Rxijsum=sum(Rxij); %columns sum of ranks for each block
A=sum(sum((Rxij.^2),2)); %sum of squares of ranks
C=b*k*(k+1)^2/4; %Correction factor
dAC=A-C;
%Chi square approximation
df=t-1; %degrees of freedom
T1=df*(sum(Rxijsum.^2)-r*C)/dAC;
P1=1-chi2cdf(T1,df);  %probability associated to the Chi-squared-statistic.

%F statistic approximation
dfn=k-1;%degrees of freedom for numerator
dfd=b*(k-1)-t+1; %degrees of freedom for denominator
T2=T1/df/(b*dfn-T1)*dfd;
P2=1-fcdf(T2,dfn,dfd);  %probability associated to the F-statistic.

%display results
tr=repmat('-',1,80);
disp('DURBIN TEST FOR IDENTICAL TREATMENT EFFECTS: TWO-WAY BALANCED, INCOMPLETE BLOCK DESIGNS')
disp(tr)
fprintf('Number of observation: %i\n',o)
fprintf('Number of blocks: %i\n',b)
fprintf('Number of treatments: %i\n',t)
fprintf('Number of treatments for each block: %i\n',k)
fprintf('Number of blocks for each treatments: %i\n',r)
disp(tr)
fprintf('A (sum of squares of ranks): %0.4f\n',A)
fprintf('C (correction factor): %0.4f\n',C)
disp(tr)
fprintf('Chi-square approximation (more conservative)\n')
fprintf('Durbin test statistic T1 (uncorrected): %0.4f\n',T1)
fprintf('chi-square=T1 df=%i - p-value (2 tailed): %0.4f\n',df,P1)
disp(tr); 
fprintf('F-statistic approximation (less conservative)\n')
fprintf('Durbin test statistic T2 (corrected): %0.4f\n',T2)
fprintf('F=T2 df-num=%i df-denom=%i - p-value (2 tailed): %0.4f\n',dfn,dfd,P2)
disp(tr);
if P2>alpha
    fprintf('The %i treatments have identical effects\n',t)
else
    fprintf('The %i treatments have not identical effects\n',t)
    disp(' ')
    disp('POST-HOC MULTIPLE COMPARISONS')
    disp(tr)
    tmp=repmat(Rxijsum,t,1); Rdiff=abs(tmp-tmp'); %Generate a matrix with the absolute differences among ranks
    cv=tinv(1-alpha/2,dfd)*realsqrt((dAC*2*r/dfd)*(1-T1/(b*dfn))); %critical value
    mc=Rdiff>cv; %Find differences greater than critical value
    %display results
    fprintf('Critical value: %0.4f\n',cv)
    disp('Absolute difference among mean ranks')
    disp(tril(Rdiff))
    disp('Absolute difference > Critical Value')
    disp(tril(mc))
end


function len=rlencode(x)
I = x(1:end-1) ~= x(2:end);
% now find the run lengths and values
last = [ find(I) ; length(x) ];      % end position for each run
len = diff([ 0 ; last ]);            % length of each run