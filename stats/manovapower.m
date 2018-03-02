function manovapower()
% clear all;
% clc;
disp('Power Analysis for MANOVA, written by Arthure J. Woodward & Hongjing Lu');

%enter the BG factors
fprintf('Enter the number of between-group factors \n');
        bgk=getint_k(' ');
        for i=1:bgk;
            fprintf('Enter the number of levels for factor %d',i);
            bgl(i)=input(' \n');
        end;
        b=1;
        for i=1:bgk;
            b=b*bgl(i);
        end;
fprintf('Total number of between group cells = %d\n',b);
%enter the QDDV and/or WS factors
fprintf('Enter the number of qualitatively different dependent variables. \n')
        smallp = getint_k(' ');
        wsk=0;wsl(1)=0;
        fprintf('Enter the number of within-subject factors \n');
        wsk=getint_k(' ');
        for i=1:wsk
            fprintf('Enter the number of levels for factor %d',i)
            wsl(i)=input(' \n'); 
        end;
        p=1;
        ball=b*smallp;
        for i=1:wsk;
            p=p*wsl(i);
            ball=ball*wsl(i);
        end;
fprintf('Total number of between-group cells = %d\n',b);
fprintf('Total number of QDDV = %d\n',smallp);
fprintf('Total number of WS-factor cells = %d\n',p);
fprintf('Total number of BG-, WS-, and QDDV cells = %d\n',ball);

fprintf('\nEnter as one row the %d population means of the alternative hypothesis \n',ball);
% keyboard; beta=ans';

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

if size(beta,1) ~=ball
    disp('incorrect number population means');
end;
covtype=getuc_k('Enter unrestricted or compound symmetric(u/c)\n');
if covtype=='c'%type of covariance matrix of disturbances-- cs frist
         sig=getflt_k('Enter the common variance for the compound symmetric sigma\n');
         covans=getcv_k('\nEnter Correlation or coVariance(c/v)\n');
         if covans=='v'
            cov=getflt_k('\nEnter common covariance\n');
         else;
            corr=getflt_k('\nEnter common correlation\n');
            cov=corr*sig;
         end;
         ip=eye(p*smallp);
         o=ones(p*smallp,p*smallp);
         sigma_e_cs=(sig*ip)+(cov*(o-ip))
		 more='y';  
         while more=='y'%computation loop for cs wald 
            t=1;
            [m,hb,hp]=geth_a(smallp,b,bgk,bgl,wsk,wsl,t,beta,p);%get h matrix
            %do all the cs wald computations here
            h=kron(hb,hp);
            q=size(h,1);
            dfh=size(hb,1);
            gam=transpose(reshape(transpose(beta),p*smallp,b));
            %do the power stuff for cs wald
             anspow=getpn_k('\nCompute power or n (number per cell) (p/n) \n');
             if anspow=='p'%do power rather than sample size
                    n=getint_k('Enter sample size \n');
                    alpha=getflt_k('enter alpha \n');
                    x=1;
                    [hpon,hpont]=qr(hp');
 					hpon=hpon(:,1:m);
 					hpon=hpon';
                    s=n*b;
                    dfew=m*(s-b);
                    part1=inv(hb*hb')*n;
                    part2=hb*gam;
                    sscpe=(hpon*sigma_e_cs*(hpon'))*(s-b);
   					sscph=hpon*((part2')*part1*part2)*hpon';
                    ssh=trace(sscph);
					sse=trace(sscpe);
					%disp('Wald with compound symmerty')
					wald=ssh/sse*(dfew/q);
					 a=0;
					dfh=q;dfe=dfew; 
                     [lam,power,powers]=anova_uneqn_cspowerm(alpha,b,ball,h,wald,beta,dfh,dfe);%%%%%%make unequal n
                     fprintf('\n\n=============== POWER ANALYSIS FOR COMPOUND SYMMETRIC WALD (alpha = %6.4f) ================\n',alpha );
					% disp('THE SAMPLE MEANS:');
					% disp(beta');
					%fprintf('Power for current sample size\n');
                    %disp(celln');
					fprintf('One test: noncentrality parameter = %8.4f, power = %6.4f\n', lam,power);
					fprintf('Scheffe : power = %6.4f\n',powers);
					fprintf('---------------------------------------------------------------\n');
             else;%do sample size stuff
                    pow=getflt_k('enter power \n');
                    alpha=getflt_k('enter alpha \n');
                    x=1;
                    %dfew=m*(s-b);
                    [hpon,hpont]=qr(hp');
 					hpon=hpon(:,1:m);
 					hpon=hpon';
                    part1_no_n=inv(hb*hb');
                    part2=hb*gam;
                    sscpe_no_n=(hpon*sigma_e_cs*(hpon'));% for cs n
                    sscph_no_n=hpon*((part2')*part1_no_n*part2)*hpon';%for cs n
                    wald_no_n=trace(sscph_no_n)/trace(sscpe_no_n);
                    dfh=q;%dfe=dfew;
                   %if power<.95%get sample size for cs wald for one test 
                   %disp('Cell sizes for current study:');
                    fprintf('sample size estimation for %f power\n',pow);
                    [n,power]=findn_cswald(pow,alpha,b,h,x,wald_no_n,beta,dfh,m);
                        if power>pow
                            powerlo=anova_n_cspower(alpha, h,b,n-1,wald_no_n,beta,dfh,m);
                        else;
                            powerhi=anova_n_cspower(alpha, h,b,n+1,wald_no_n,beta,dfh,m);
                        end;
                        fprintf('\nOne test: CS Wald, n/cell needed for %f power\n',pow);
                        
                        fprintf('---------------------------------------------------------------\n');
					    %fprintf('Equal n/cell needed for approx .95 power of CS Wald(assuming pop mu = sample mu) \n');
                            if power>pow
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n-1,powerlo,alpha);
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,power,alpha);
								fprintf('---------------------------------------------------------------\n');             
                            else;
								fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,power,alpha);
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n+1,powerhi,alpha);
								fprintf('---------------------------------------------------------------\n');
                            end;
                            %end;%if power greater than .95 for cs wald
                            %if powers<.95 %get sample size for cs wald and scheffe test
                           
                            [n,powers]=findn_cswalds(pow,alpha,b,ball,h,x,wald_no_n,beta,dfh,m);
                                %[power,powers]=anova_n_cspowers(alpha,h,b,n,sig_e,beta);
                            if powers>pow
                               [powerlo]=anova_n_cspowers(alpha,h,b,ball,n-1,wald_no_n,beta,dfh,m);
                            else;
                                [powerhi]=anova_n_cspowers(alpha,h,b,ball,n+1,wald_no_n,beta,dfh,m);
                            end;
                                fprintf('\nScheffe: CS Wald; n/cell for %6.4f power\n',pow);
		                        %disp('Cell sizes for current study:');
		                        %disp(celln');
                                fprintf('---------------------------------------------------------------\n');
							    
                            if powers>pow
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n-1,powerlo,alpha);
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,powers,alpha);
								fprintf('---------------------------------------------------------------\n');             
                            else;
								fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,powers,alpha);
                                fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n+1,powerhi,alpha);
								fprintf('---------------------------------------------------------------\n');
                            end;    
                                    %end;%end if powers for scheffe <.95
                end;%end do power vs sample size stuff for cs wald
                more=getyn_k('\nContinue(y/n)\n');
                
        end;%end to continue cs wald or not
                    
else  %unrestricted sigma
            
    fprintf('Enter the %d by %d unrestricted covariance matrix\n',p*smallp,p*smallp);
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
    sigma_e=temp';   


    gam=transpose(reshape(transpose(beta),p*smallp,b));
    more='y';  
    while more=='y'%computation loop for pnb trace  
        t=1;
        [m,hb,hp]=geth_a(smallp,b,bgk,bgl,wsk,wsl,t,beta,p);%get h matrix
        %do the pnb computations here
            
        %compute the PNB trace
        dfh=size(hb,1);
        %gam=transpose(reshape(transpose(beta),p,b));
        h=kron(hb,hp);
        q=size(h,1);
        dfh=size(hb,1);
         %power stuff
         anspow=getpn_k('\nCompute power or n (number per cell) (p/n) \n');
             if anspow=='p'
                    n=getint_k('Enter sample size \n');
                    alpha=getflt_k('enter alpha \n');
                    s=n*b;
                    part1=inv(hb*hb')*n;
                    part1_no_n=inv(hb*hb');
                    part2=hb*gam;
                    part3=(hp*sigma_e*transpose(hp))*(s-b);
                    sig_h_q=hp*(transpose(part2)*part1*part2)*transpose(hp);
                    sig_h_no_n=hp*(transpose(part2)*part1_no_n*part2)*transpose(hp);
                    v=(sig_h_q*inv((part3)+sig_h_q));
                    v=trace(v);
                    dfe=s-b;
                    c2=dfh+dfe-((m+dfh+1)/2);
                    c3=min(dfh,p);
                    c4=max(m,dfh);

                    a=0;
                    dfh=size(hb,1)
                    [lam,power,powers]=anova_n_pnbpowersm(alpha,n,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);%%%%%make unequal n
                     fprintf('\n\n================== POWER ANALYSIS FOR BNP TRACE (alpha = %6.4f) ===========================\n',alpha);
                    % disp('THE SAMPLE MEANS:');
                    % disp(beta');
                    %fprintf('---------------------------------------------------------------\n');
                    fprintf('One test: noncentrality parameter = %8.4f, power = %6.4f\n', lam,power);
                    fprintf('Scheffe : power = %6.4f\n',powers);
                    fprintf('---------------------------------------------------------------\n');
                        
            else;%do pnb sample size
					%if power<.95
                    pow=getflt_k('enter power \n');
                    alpha=getflt_k('enter alpha \n');
                    x=1;
                    part1=1; part2=1;
                    part1_no_n=inv(hb*hb');
                    part2=hb*gam;
                    sig_h_no_n=hp*(transpose(part2)*part1_no_n*part2)*transpose(hp);
                    sigma_mu=1;
                    %dfe=s-b;
                    %c2=dfh+dfe-((m+dfh+1)/2);
					c3=min(dfh,p);
					c4=max(m,dfh);
                    [n,power]=findn_pnbwald(pow,alpha,b,h,x,sigma_mu,beta,dfh,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    if power>pow
                        powerlo=anova_n_pnbpower(alpha,n-1,b,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    else;
                       powerhi=anova_n_pnbpower(alpha,n+1,b,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    end;
                    fprintf('\nOne test: PNB Trace; n/cell for %6.4f Power\n', pow);
                    fprintf('---------------------------------------------------------------\n');
			       %fprintf('Equal n/cell needed for approx. .95 power of PNB Trace(assuming pop mu = sample mu) \n');
                    if power>pow
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n-1,powerlo,alpha);
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,power,alpha);
						fprintf('-------------------------------------------------------------\n');             
                    else;
						fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,power,alpha);
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n+1,powerhi,alpha);
						fprintf('---------------------------------------------------------------\n');
                    end;
                   
                    [n,powers]=findn_pnbwalds(pow,alpha,b,ball,h,x,beta,dfh,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    if powers>pow
                          [powerlo]=anova_n_pnbpowers(alpha,n-1,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    else;
                         [powerhi]=anova_n_pnbpowers(alpha,n+1,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);
                    end;
                        fprintf('\nScheffe: CS Wald; n/cell for %6.4f power\n', pow);
                        %disp('Cell sizes for current study:');
                        %disp(celln');
                        fprintf('---------------------------------------------------------------\n');
			    
                    if powers>pow
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n-1,powerlo,alpha);
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,powers,alpha);
						fprintf('---------------------------------------------------------------\n');             
                    else;
						fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n,powers,alpha);
                        fprintf('n =%3.0f   Power = %6.4f, Alpha = %6.4f\n',n+1,powerhi,alpha);
						fprintf('---------------------------------------------------------------\n');
                    end;    
                   
             end;%do power vs sample size 
            more=getyn_k('\nContinue(y/n)\n');
            
    end;%end to continue pnb trace computations or not
                     
end;%end covtype choice between unrestricted or compound symmetric
        
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


function a=getuc_k(prompt)
%AW & HJL 6/20/03
%get Y/N answer from keyboard; filters out input errors "-", "enter", 
%or any text other than "y" or "n"
if nargin<1, prompt='(enter u or c) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'UCuc')))&(isempty(a)==0))==0       
    fprintf('input error, enter only u or c \n');
      a= input(' ','s');     
end 
 

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


function a=getcv_k(prompt)
%AW & HJL 6/20/03
%get Y/N answer from keyboard; filters out input errors "-", "enter", 
%or any text other than "y" or "n"
if nargin<1, prompt='(enter c or v) \n'; end;

a=input(prompt,'s');
while ((all(ismember(a,'CVcv')))&(isempty(a)==0))==0       
    fprintf('input error, enter only c or v \n')
      a= input(' ','s');     
 end; 
 
 
function [m,hb,hp]=geth_a(smallp,b,bgk,bgl,wsk,wsl,t,beta,p)
%************* get hypothesis matrix for ANOVA ************************************
%*                                                                                *
%*  a = matrix of constants for general linear hyoptheses;                        *                                                    
%*  t = length of y; beta=vector of parameter estimates;                          *
%*  p = the number of DV (not counting the                                        *   
%*     WS factor levels, wich also are columns of Y                               *
%*  bgk = no. between group factors                                               *
%*  bgl(i= 1,gbk) = no. of levels in the bg factors                               *
%*  wsk = no. within group factors                                                *
%*  wsl(i=1,wsk) = no. of levels in the ws factors                                *
%*  hb = the kronecker of all bgk factor contrast h matrices                      *
%*  hp = the kronecker of all wsk factor contrast h matrices                      *
%*  m = no. of row in hp                                                          *
%*  s = total no. subjects                                                        *
%*  b= no. of bg factor combinations (columns in xb, before inflating with the DV)*
%*  smallp=total number of random variables (exclusive of WS factor levels)       *                                             
%**********************************************************************************
        
%get the hb matrix
fprintf('\n         ***ENTER h FOR CELL MEANS ANOVA IN GLM; CREATE SPSS LMATRIX AND CONTRASTS***\n');
disp('*To enter contrast matrix for each factor: put elements in [...],then type return');
disp('*Or generate factor contrast matrices automatically: type one of the below (om, sum, iden), then type return');
disp(' ***om indicates omnibus matrix;   sum indicates ones;  iden indicates identity matrix;*** ' );

fprintf('\nEnter the first of %d between-group h matrices \n',bgk)  
    hb=[1];m=0;
    if bgk>0
        flag=0;
        for i=1:bgk       
            fprintf('     Enter the %d elements for each row of h %d\n',bgl(i),i);
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
                    break;
                else
                    hb=kron(hb,temp);
                end;
        end;%end for
        q=size(hb,1);
                    
     end;%end if bgk     
%get the hp matrix
    hp=[1];
    if wsk>0
            fprintf(1,'Enter the first of %d within-subject h matrices \n',wsk);
            flag=0;
            for i=1:wsk       
                fprintf('     Enter the %d elements for each row of h %d\n',wsl(i),i);
                
                while 1
                    temp0=input('','s');
                    if ischar(temp0)==1
                        if temp0(1)=='['  % input a matrix
                            temp = str2num(temp0);
                        else % input a label
                            temp=lower(temp0);                  

                            if strcmp(temp,'om')==1;
                                temp=[eye((wsl(i)-1),(wsl(i)-1 )) (-1)*ones((wsl(i)-1),1)];
                            elseif strcmp(temp,'sum')==1;
                                temp=ones(1,wsl(i));
                            elseif strcmp(temp,'iden')==1;
                                temp=eye(wsl(i));                                    
                            elseif strcmp(temp(1),'s')==1;
                                level=str2num(temp(2)); 
                                temp=zeros(1,wsl(i));
                                temp(level)=1;                        
                            else
                                error('input error: enter ''om'', ''sum'', or numbers')
                            end;
                        end;
                        break;
                    end;%end if ischar
                end;%end while
                      if flag==1
                            break;
                      else
                           hp=kron(hp,temp);
                       end;
             end;%end for
            m=size(hp,1);
    
    end;%end if wsk
    
    
    if smallp>1 
              
            fprintf('Enter the %d elements per row for the qualitatively different DV\n',smallp);
            flag=0;

            while 1
                temp0=input('','s');
                if ischar(temp0)==1
                    if temp0(1)=='['  % input a matrix
                        temp = str2num(temp0);
                    else % input a label
                        temp=lower(temp0);                  

                        if strcmp(temp,'om')==1;
                            temp=[eye((smallp-1),(smallp-1 )) (-1)*ones((smallp-1),1)];
                        elseif strcmp(temp,'sum')==1;
                            temp=ones(1,smallp);
                        elseif strcmp(temp,'iden')==1;
                            temp=eye(smallp);                                    
                        elseif strcmp(temp(1),'s')==1;
                            level=str2num(temp(2)); 
                            temp=zeros(1,smallp);
                            temp(level)=1;                        
                        else
                            error('input error: enter ''om'', ''sum'', or numbers')
                        end;
                    end;
                    break;
                end;%end if ischar
            end;%end while
           
            hp=kron(hp,temp);
            m=size(hp,1);
    end;%end if smallp
    
    
    
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
 

function [lam,power,powers]=anova_uneqn_cspowerm(alpha,b,ball,h,wald,beta,dfh,dfe)
%compute the power given alpha,h,b,temp n,sig_e,mu1
% alpha=.05;
%xpxi=inv(x'*inv(sigma)*x);
hmu1=h*beta;
c=finv(1-alpha,dfh,dfe);
lam=wald*dfh;
%lam=((hmu1'*inv(h*sigma_mu*h')*hmu1));
power=1-ncfcdf(c,dfh,dfe,lam);
c=(ball-1)*finv(1-alpha,(ball-1),dfe);
powers=1-ncfcdf(c,dfh,dfe,lam);

function [n,power]=findn_cswald(pow, alpha,b,h,x,wald_no_n,beta,dfh,m)
%function to find (equal)sample size for prespecified power and alpha
epss=.00001;
L = 2;U = 1000; Umax=1000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
	while U>=L 
       n = round((L+U)/2);
       power = anova_n_cspower(alpha, h,b,n,wald_no_n,beta,dfh,m);%get temporary prob if exp wise Type I
       %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
           if power < target
              if(abs(power-target) <epss)
                  break;
              end;
              L = n+1;
           else;
              if(abs(power-target) <epss)
                  break;
              end;
              U=n-1;
           end;
           ctr=ctr+1;
            if ctr==itmax
                fprintf('\n **iteration limit(500) exceeded**\n');break;%note partial solution
            end;
            if n==Umax
                fprintf('\n **upper sample size limit (1000) reached**\n');break;%note partial solution
            end;
	end;

 function [power]=anova_n_cspower(alpha,h,b,n,wald_no_n,beta,dfh,m)
%compute the power given alpha = .05,h,b,temp n,sig_e,mu1
% alpha=.05;
dfe=m*(n*b-b);
hbet=h*beta;
c=finv(1-alpha,dfh,dfe);
lam=wald_no_n*(n/(n*b-b))*dfe;
power=1-ncfcdf(c,dfh,dfe,lam);

function [n,power]=findn_cswalds(pow,alpha,b,ball,h,x,wald_no_n,beta,dfh,m)
%function to find (equal)sample size for prespecified power and alpha
epss=.00001;
L = 2;U = 1000; Umax=1000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
	while U>=L 
       n = round((L+U)/2);
       power = anova_n_cspowers(alpha,h,b,ball,n,wald_no_n,beta,dfh,m);%get temporary prob if exp wise Type I
       %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
           if power < target
              if(abs(power-target) <epss)
                  break;
              end;
              L = n+1;
           else;
              if(abs(power-target) <epss)
                  break;
              end;
              U=n-1;
           end;
           ctr=ctr+1;
            if ctr==itmax
                fprintf('\n **iteration limit(500) exceeded**\n');break;%note partial solution
            end;
            if n==Umax
                fprintf('\n **upper sample size limit (1000) reached**\n');break;%note partial solution
            end;
	end;
    
function [power]=anova_n_cspowers(alpha,h,b,ball,n,wald_no_n,beta,dfh,m)
%compute the power given alpha = .05,h,b,temp n,sig_e,mu1
% alpha=.05;
dfe=m*(n*b-b);
hbet=h*beta;
%c=finv(1-alpha,dfh,dfe);
lam=wald_no_n*(n/(n*b-b))*dfe;
%power=1-ncfcdf(c,dfh,dfe,lam);
c=(ball-1)*finv(1-alpha,(ball-1),dfe);
power=1-ncfcdf(c,dfh,dfe,lam);

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
 
function [lam,power,powers]=anova_n_pnbpowersm(alpha,n,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp)
%compute the power given alpha,h,b,temp n,sig_e,mu1
% alpha=.05;
s=n*b;
dfe=s-b;
% dfe
part3=(hp*sigma_e*transpose(hp))*(s-b);
v=(n*sig_h_no_n*inv((part3)+n*sig_h_no_n));
v=trace(v);
lam=((dfe-m+c3)*c3*v)/(c3-v);
c=finv(1-alpha,(c3*c4),c3*(dfe-m+c3));
power=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);
c=(ball-1)*finv(1-alpha,(ball-1),c3*(dfe-m+c3));
powers=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);

function [n,power]=findn_pnbwald(pow, alpha, b,h,x,sigma_mu,beta,dfh,m,c3,c4,part1,part2,sigma_e,sig_h_q,hp)
%function to find (equal)sample size for prespecified power and alpha
epss=.00001;
L = 2;U = 1000; Umax=1000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
	while U>=L 
       n = round((L+U)/2);
       power= anova_n_pnbpower( alpha,n,b,m,c3,c4,part1,part2,sigma_e,sig_h_q,hp);%get temporary prob if exp wise Type I
       %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
           if power < target
              if(abs(power-target) <epss)
                  break;
              end;
              L = n+1;
           else;
              if(abs(power-target) <epss)
                  break;
              end;
              U=n-1;
           end;
           ctr=ctr+1;
            if ctr==itmax
                fprintf('\n **iteration limit(500) exceeded**\n');break;%note partial solution
            end;
            if n==Umax
                fprintf('\n **upper sample size limit (1000) reached**\n');break;%note partial solution
            end;
	end;
    
function [power,powers]=anova_n_pnbpower(alpha,n,b,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp)
%compute the power given alpha,h,b,temp n,sig_e,mu1
s=n*b;
dfe=s-b;
% dfe
part3=(hp*sigma_e*transpose(hp))*(s-b);
v=(n*sig_h_no_n*inv((part3)+n*sig_h_no_n));
v=trace(v);
lam=((dfe-m+c3)*c3*v)/(c3-v);
c=finv(1-alpha,(c3*c4),c3*(dfe-m+c3));
power=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);
% c=(1-ball)*finv(1-alpha,(1-ball),c3*(dfe-m+c3));
% powers=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);

function [n,power]=findn_pnbwalds(pow, alpha, b,ball,h,x,beta,dfh,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp)
%function to find (equal)sample size for prespecified power and alpha
epss=.00001;
L = 2;U = 1000; Umax=1000;%set the lower and upper bounds of the bisection search
target=pow;%set target prob of exp wise type I error and bpc
ctr=1;itmax=500;
%discrete bisection search 
	while U>=L 
       n = round((L+U)/2);
       power= anova_n_pnbpowers(alpha,n,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp);%get temporary prob if exp wise Type I
       %fprintf('%6.0f %d %8.6f \n',ctr,n,power);
           if power < target
              if(abs(power-target) <epss)
                  break;
              end;
              L = n+1;
           else;
              if(abs(power-target) <epss)
                  break;
              end;
              U=n-1;
           end;
           ctr=ctr+1;
            if ctr==itmax
                fprintf('\n **iteration limit(500) exceeded**\n');break;%note partial solution
            end;
            if n==Umax
                fprintf('\n **upper sample size limit (1000) reached**\n');break;%note partial solution
            end;
	end;

function [powers]=anova_n_pnbpowers(alpha,n,b,ball,m,c3,c4,part1,part2,sigma_e,sig_h_no_n,hp)
%compute the power given alpha,h,b,temp n,sig_e,mu1
s=n*b;
dfe=s-b;
% dfe
part3=(hp*sigma_e*transpose(hp))*(s-b);
v=(n*sig_h_no_n*inv((part3)+n*sig_h_no_n));
v=trace(v);
lam=((dfe-m+c3)*c3*v)/(c3-v);
c=finv(1-alpha,(c3*c4),c3*(dfe-m+c3));
power=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);
c=(ball-1)*finv(1-alpha,(ball-1),c3*(dfe-m+c3));
powers=1-ncfcdf(c,(c3*c4),c3*(dfe-m+c3),lam);


	
   
 
    
	
   
 
    
	
   
    
	
   
 

