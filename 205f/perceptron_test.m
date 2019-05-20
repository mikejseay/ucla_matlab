figure(3); clf;
x=zeros(6,5);

[X,Y]=meshgrid(1:5,1:6);

y=zeros(1,10);

    subplot(1,2,1); pcolor(X,Y,x);
    subplot(1,2,2); bar(0:9,y);

while 1
    
[xx, yy] = ginput(1);
%yy=7-yy;
xx=round(xx-.5);
yy=round(yy-.5);
x(yy,xx)=abs(x(yy,xx))-1;

    for d=1:maxdigit %loop through digits
           y(d)=0; %initialize output to zero 
           for r=1:5 %loop through pixel rows
                for c=1:4 %loop through pixel columns
                    y(d) = y(d) + x(c,r)*W(c,r,d);
                end
           end
    end

    subplot(1,2,1); pcolor(X,Y,x);
    subplot(1,2,2); bar(0:9,y);

end
