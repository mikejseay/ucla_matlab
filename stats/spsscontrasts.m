
function spsscontrasts()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%script to compute the SPSS LMATRIX contrasts (between group)         % 
% Art Woodward, 9/12/03                                               %
% Hongjing Lu,  11/18/2008                                            %
%                                                                     %
%   bgk = no. BG factors (restricted to 2 or 3 factors);              % 
%   bgl(i) = number of levels in factor i ;                           %
%   builds less than full rank X matrix (without reparameterization); %
%   inputs h matrices for cell means model;                           %
%   outputs corresponding contrasts for LMATRIX command in SPSS,      %
%       which apply the parameters of the less than full rank         %
%       model, including all the parameters including the             %
%       redundant ones.                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
clear all;
clc;                   
bgk=getint_k('Enter the number of between-group factors (1,2, or 3) \n ');
for i=1:bgk
    fprintf('Enter the number of levels for factor %1.0f',i)
    bgl(i)=input(' \n'); 
end;
    index=ones(1,4); 
for i=1:bgk
    index(1,i)=bgl(i);
end;
%create cell indicators
if bgk>1%skip of one factor
    ijk=1; 
    for i = 1:index(1,1)
        for j =1:index(1,2)
            for k=1:index(1,3)
                cell(ijk,:)=[i j k];
                ijk=ijk+1;
            end;
        end;
     end;

    %create less-than-full-rank x matrix
    int=ones(size(cell,1),1);
 end;%end bgk>1 test
 if bgk == 1
     x=[ones(bgl(1),1) eye(bgl(1))];
     flag=1;
 elseif bgk == 2
     cell(:,3)=[];
     x=[int,dummyvar(cell)];
     x=[x,eye(bgl(1)*bgl(2))];
 else
     x=[dummyvar(cell)];
     x12=twoways(bgl(1),bgl(2),0,bgl(1),x);
     x13=twoways(bgl(1),bgl(3),0,(bgl(1)+bgl(2)),x);
     x23=twoways(bgl(2),bgl(3),bgl(1),(bgl(1)+bgl(2)),x);
     x123=threeway(bgl(1),bgl(2),bgl(3),0,(bgl(1)),(bgl(1)+bgl(2)),x);
     %x=[int,x,x12,x13,x23,eye(bgl(1)*bgl(2)*bgl(3))]
     x=[int,x,x12,x13,x23,x123];
 end;
disp('Less-than-full-rank X matrix, n=1 (before reparameterization)')
disp(' ')
disp(x)
c=size(x,2);r=rank(x);
fprintf('Columns in X = %d, rank of x = %d, redundant parameters = %d \n',c,r,c-r);
disp(' ')

fprintf('\n         ***ENTER h FOR CELL MEANS ANOVA IN GLM; CREATE SPSS LMATRIX AND CONTRASTS***\n');
disp('*To enter contrast matrix for each factor: put elements in [...],then type return');
disp('*Or generate factor contrast matrices automatically: type one of the below (om, sum, iden), then type return');
disp(' ***om indicates omnibus matrix;   sum indicates ones;  iden indicates identity matrix;*** ' );

gomore='y';
while gomore=='y'
    fprintf(1,'\nEnter the first of %1.0f h matrices \n',bgk) 
    h=[1];k=bgk;flag=0;
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
		
    fprintf('There are%3d parameters in this less than full rank model.\n', size(x,2))
    disp(' ')

    L=h*x;
    disp(L)
    disp(' ')
    fprintf('Copy and paste the LMATRIX command and contrasts into SPSS ANOVA script\n\n')
    %fprintf('[ ');
    fprintf('/LMATRIX = ')
    for j=1:size(L,1)
        fprintf('ALL');
        for i=1:size(L,2)
            fprintf('%10.4f',L(j,i));
            if rem(i,6)==0
                fprintf('\n');
            end;
        end;
        if j<size(L,1)
            fprintf(';\n');
        end;
    end;
    gomore=getyn_k('\n\nSpecify another hypothesis(y/n)\n');
end;%end hypothesis testing loop

function xxx=threeway(f,s,t,os1,os2,os3,x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Threeway                                %
%                           AW 9/03                                %
% script to compute the three way in the less than full rank model %
%                                                                  %
% f,s, and t are the number of levels of the three factors         %
% os1, os2, and os3 are the offsets needed to compute the location %
%       of the main effect columns.                                % 
% x is the less than full rank design matrix with only the         %
%       main effects and no intercept                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xxx=[];
for i=1:f
    for j=1:s
        for k = 1:t
        xxx=[xxx,x(:,os1+i).*x(:,os2+j).*x(:,os3+k)];
        end;
    end;
end;
xxx;

function xx=twoways(f,s,os1,os2,x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  Twoways                                        %
%                                  AW, 9/03                                       %
%                                                                                 %
%  creates the product of the main effect columns to get the less than full rank  %
%     two way interactions                                                        % 
%  f is the number of levels for the first effect and s is for the second         %
%  x is the less than full rank design matrix without the intercept               %
%  os1 and os2 are the offsets needed to compute the location of the main effects %  
%     in the design matrix with no intercept                                      %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=[];
for i=1:f
    for j=1:s
        xx=[xx,x(:,os1+i).*x(:,os2+j)];
    end;
end;
xx;

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

