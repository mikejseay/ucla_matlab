function anovapower()
%*********** Univariate ANOVA Power and Sample Size Estimation ***********
%                                  AW                                    *                     
%                              Winter 2004                               * 
%                                                                        *
%*************************************************************************
clc;
disp('Power Analysis for ANOVA, written by J. Arthure Woodward & Hongjing Lu');
fprintf('Enter the number of between-group factors \n');
k=getint_k(' ');
for i=1:k;
    fprintf('Enter the number of levels for factor %d',i);
    bgl(i)=input(' \n');
end;
b=1;
for i=1:k;
    b=b*bgl(i);
end;
fprintf('Total number of cells = %d\n',b);

fprintf('\nEnter as a row the %d population means of the alternative hypothesis \n',b);

% keyboard;beta=ans';
while 1
    temp0=input('','s');
    if ischar(temp0)==1
        if temp0(1)=='['  % input a matrix
            temp = str2num(temp0);
        else % input a label
            temp=lower(temp0);                  
        end;
        break;
    end;%end if ischar
end;%end while
beta=temp';        

if size(beta,1) ~=b
    disp('incorrect number population means');
end;
fprintf('\nEnter the population variance of the disturbances \n');       
sig_e=getflt_k(' ');
t=1;p=1;
        
more='y';     
while more=='y'
    [h,a]=geth_power(k,t,beta,p,bgl);
    anspow=getpn_k('\nCompute power or n (number per cell) (p/n) \n');
    if anspow=='p'
        n=getint_k('Enter sample size \n');
        alpha=getflt_k('enter alpha \n');
        [power,powers]=anova_n_powers(alpha,h,b,n,sig_e,beta);
        disp('************* POWER ESTIMATION *******************');
        fprintf('One test:     power = %6.4f \n',power);
        fprintf('Scheffe test: power = %6.4f \n',powers);
        disp('------------------------------------------------');

    else;
        pow=getflt_k('enter power \n');
        alpha=getflt_k('enter alpha \n');
        n=findn(sig_e,alpha,pow,h,b,beta);
        [power,powers]=anova_n_powers(alpha,h,b,n,sig_e,beta);
        disp('************** APPROXIMATE N/CELL TO ACHIEVE SPECIFIED POWER *************');
        fprintf('One test:      sample size is %d for power = %6.4f \n',n,power);
        n=findns(sig_e,alpha,pow,h,b,beta);
        [power,powers]=anova_n_powers(alpha,h,b,n,sig_e,beta);
        fprintf('Scheffe test:  sample size is %d for power = %6.4f \n',n,powers);
        disp('--------------------------------------------------------------------------');
    end;
    more=getyn_k('\nContinue(y/n)\n');
end;%end while to continue or not
    
    
function [h,a]=geth_power(k,t,beta,p,bgl)

%************* get hypothesis matrix for general linear hypothesis **************
%*                                                                              *
%*  OUTPUTE ARGUMENTS:                                                          * 
%*  h = hypothesis matrix;a=matrix of constants for general linear hyoptheses;  * 
%*  INPUTE ARGUMENTS:                                                           * 
%*  t=length of y; k=number of BG factors; beta=vector of parameter estimates;  *
%*  p = number of dependent variables; k=no. BG factors                         *                                   
%********************************************************************************

fprintf('\n         ***ENTER h FOR CELL MEANS ANOVA IN GLM; CREATE SPSS LMATRIX AND CONTRASTS***\n');
disp('*To enter contrast matrix for each factor: put elements in [...],then type return');
disp('*Or generate factor contrast matrices automatically: type one of the below (om, sum, iden), then type return');
disp(' ***om indicates omnibus matrix;   sum indicates ones;  iden indicates identity matrix;*** ' );

%get the h matrix 
fprintf('\nEnter the first of %d h matrices \n',k) ;
h=[1];
flag=0;

for i=1:k
    fprintf('     Enter the %1.0f elements for each row of h %1.0f\n',bgl(i),i);
    while 1
        temp0=input('','s');
        if ischar(temp0)==1
            if temp0(1)=='['  % input a matrix
                temp = str2num(temp0);
            else % input a label
                temp=lower(temp0);                  

                if strcmp(temp,'om')==1;
                    temp=[eye((bgl(i)-1),(bgl(i)-1 )) (-1)*ones((bgl(i)-1),1)];
                elseif strcmp(temp,'sum')==1;
                    temp=ones(1,bgl(i));
                elseif strcmp(temp,'iden')==1;
                    temp=eye(bgl(i));                                    
                elseif strcmp(temp(1),'s')==1;
                    level=str2num(temp(2)); 
                    temp=zeros(1,bgl(i));
                    temp(level)=1;                        
                else
                    error('input error: enter ''om'', ''sum'', or numbers')
                end;
            end;
            break;
        end;%end if ischar
    end;%end while
    if flag==1
         h=ans
        break;
    else
        h=kron(h,temp);
    end;           

    if i==k
        disp('Contrasts for means')
        disp(' ')
        disp(h)
    end;
end;


% for i=1:k
%     fprintf('Enter the %d elements for each row of h %d\n',bgl(i),i);
%     while 1
%         keyboard;
%         temp=ans;
%         
%         temp=lower(temp);
%       
%         if ischar(temp)==1
%             if strcmp(temp,'om')==1;
%                 temp=[eye((bgl(i)-1),(bgl(i)-1 )) (-1)*ones((bgl(i)-1),1)];break;
%             elseif strcmp(temp,'sum')==1;
%                 temp=ones(1,bgl(i));break;
%             elseif strcmp(temp(1),'s')==1;
%                 level=str2num(temp(2)) ;
%                 temp=zeros(1,bgl(i));
%                 temp(level)=1;
%                 break;
%             elseif strcmp(temp,'vec')==1
%                 flag=1;
%                 fprintf('\nEnter within [..] the %d elements of the entire h matrix,then type return\n',size(beta,1));
%                 keyboard;
%                 h=ans;
%                 break;
%             else
%                 disp('Input error: enter ''om'', ''sum'', or numbers')
%             end;
%         else;
%             break;
%         end;%end if ischar
%     end;%end while
%     if flag==1
%         break;
%     else
%         h=kron(h,temp);
%     end;
% end;
        
q=size(h,1);
%answer_constants=getyn_k('Enter nonzero constrants for a (Y/N)  \n');

%optional constants for a
a=zeros(q,1);
% if answer_constants=='y'
%     fprintf('Enter the %d constants as one row \n',q)
%     keyboard; 
%     a=ans;
%     a=transpose(a)
% end;
function [power,powers]=anova_n_powers(alpha,h,b,n,sig_e,beta)
%compute the power given alpha = .05,h,b,temp n,sig_e,mu1
%alpha=.05;
q=size(h,1);
dfh=q;
dfe=(n*b)-b;
hbet=h*beta;
c=finv(1-alpha,dfh,dfe);
lam=((hbet'*inv(h*h')*hbet)*n)/sig_e;
power=1-ncfcdf(c,dfh,dfe,lam);
c=(b-1)*finv(1-alpha,(b-1),dfe);
powers=1-ncfcdf(c,dfh,dfe,lam);

function [n]=findn(sig_e,alpha,pow,h,b,beta)
%Script to find (equal)sample size for prespecified power and alpha
%clc;
% sig_e=100;
% alpha=.05;
% h=[1 0 -1;0 1 -1];
% mu1=[90.5 91 90]';
eps=.000001;
L = 2;U = 5000; Umax=5000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
%disp('  step  n    power')
	while U>=L 
       n = round((L+U)/2);
       power = anova_n_power2(alpha,h,b,n,sig_e,beta);%get temporary prob if exp wise Type I
       %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
           if power < target
              L = n+1; 
              if(abs(power-target) <eps)
                  break;
              end;
          else;
              U=n-1;
              if(abs(power-target) <eps)
                  break;
              end;
           end;
           ctr=ctr+1;
                if ctr>itmax
                    fprintf('\n **iteration limit exceeded**\n');break;%note partial solution
                end;
                if n==Umax
                    fprintf('\n **upper limit reached**\n');break;%note partial solution
                end;
	end;
% 	disp(' ')
%     fprintf('\n-------------------------------------------------------------\n');
% disp('Hypothesis Matrix');
% disp(h);
% fprintf('-----------------------------------------------------------\n');
% 	disp('n   power')
% 	fprintf('%d %6.5f\n',n,power);
%     power=anova_n_power(alpha,h,b,n+1,sig_e,mu1);n=n+1;
%     fprintf('%d %6.5f',n,power);
%     
    
	function a=getint_k(prompt)
%AW & HJL 6/20/03
%get positive integer from keybord; filters out input errors "-", "enter", 
%or any text

if nargin<1, prompt='(enter positive integer) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'1234567890')))&(isempty(str2num(a))~=1))==0       
    fprintf('input error, enter positive integer \n')
      a= input(' ','s');     
 end 

a=str2num(a);
 function a=getflt_k(prompt)
%AW & HJL 6/20/03
%get valid numerical value from keybord; does not allow any text or input errors 
%such as 6-, "enter", "-" etc

if nargin<1, prompt='(enter any number) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'-.1234567890')))&(isempty(str2num(a))~=1))==0       
    fprintf('input error, enter only a number \n');
      a= input(' ','s');     
 end 
a=str2num(a);  
function [power,powers]=anova_n_power2(alpha,h,b,n,sig_e,beta)
%compute the power given alpha = .05,h,b,temp n,sig_e,mu1
%alpha=.05;
q=size(h,1);
dfh=q;
dfe=(n*b)-b;
hbet=h*beta;
c=finv(1-alpha,dfh,dfe);
lam=((hbet'*inv(h*h')*hbet)*n)/sig_e;
power=1-ncfcdf(c,dfh,dfe,lam);
c=(b-1)*finv(1-alpha,(b-1),dfe);
powers=1-ncfcdf(c,dfh,dfe,lam);
  
function [n]=findns(sig_e,alpha,pow,h,b,beta)
%Script to find (equal)sample size for prespecified power and alpha
%clc;
% sig_e=100;
% alpha=.05;
% h=[1 0 -1;0 1 -1];
% mu1=[90.5 91 90]';
eps=.000001;
L = 2;U = 5000; Umax=5000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
%disp('  step  n    power')
while U>=L 
   n = round((L+U)/2);
   power = anova_n_powers2(alpha,h,b,n,sig_e,beta);%get temporary prob if exp wise Type I
   %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
       if power < target
          L = n+1; 
          if(abs(power-target) <eps)
              break;
          end;
      else;
          U=n-1;
          if(abs(power-target) <eps)
              break;
          end;
       end;
       ctr=ctr+1;
            if ctr>itmax
                fprintf('\n **iteration limit exceeded**\n');break;%note partial solution
            end;
            if n==Umax
                fprintf('\n **upper limit reached**\n');break;%note partial solution
            end;
end;

    
function a=getpn_k(prompt)
%AW & HJL 6/20/03
%get Y/N answer from keyboard; filters out input errors "-", "enter", 
%or any text other than "y" or "n"

if nargin<1, prompt='(enter p or n) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'PNpn')))&(isempty(a)==0))==0       
    fprintf('input error, enter only p or n \n');
      a= input(' ','s');     
 end 
	function [powers]=anova_n_powers2(alpha,h,b,n,sig_e,beta)
%compute the power given alpha = .05,h,b,temp n,sig_e,mu1
%alpha=.05;
q=size(h,1);
dfh=q;
dfe=(n*b)-b;
hbet=h*beta;
lam=((hbet'*inv(h*h')*hbet)*n)/sig_e;
c=(b-1)*finv(1-alpha,(b-1),dfe);
powers=1-ncfcdf(c,dfh,dfe,lam);

function a=getyn_k(prompt)
%AW & HJL 6/20/03
%get Y/N answer from keyboard; filters out input errors "-", "enter", 
%or any text other than "y" or "n"

if nargin<1, prompt='(enter y or n) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'YNyn')))&(isempty(a)==0))==0       
    fprintf('input error, enter only y or n \n');
      a= input(' ','s');     
 end 

   
 
	
   
  