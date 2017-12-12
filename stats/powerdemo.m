function powerdemo(action,flag);
%POWERDEMO Demonstration of power calculation in hypothesis testing.
%   POWERDEMO creates interactive plots of power calculation based on two normal distribution
%   with equal variance.
%
%   You can change the parameters of the distribution by typing
%   a new value or by moving a slider.    
%
%   You can interactively calculate new power by dragging a reference 
%   line across the plot.
%
%   Call POWERDEMO without arguments.

%   This program is modified based upon disttool in Matlab statistics toolbox.

%   Hongjing Lu   9/3/03, ucla
if nargin < 1
    action = 'start';
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')   
   childList = allchild(0);
   distfig = childList(find(childList == gcbf));
   ud = get(distfig,'Userdata');
   if isempty(ud) & strcmp(action,'motion')
      return
   end
  
   iscdf = 2 - get(ud.functionpopup,'Value');
   newx = str2double(get(ud.xfield,'string'));
   newy = str2double(get(ud.yfield,'string'));
   popupvalue = get(ud.popup,'Value');
   if popupvalue == 2 | popupvalue == 4 | popupvalue == 8 | popupvalue == 10 | popupvalue == 15,
       discrete = 1;
   else
       discrete = 0;
   end

   if popupvalue == 2 | popupvalue == 3 | popupvalue == 4 ...
       | popupvalue == 6 | popupvalue == 10 | popupvalue == 11 ...
       | popupvalue == 12 | popupvalue == 13 | popupvalue == 17
       intparam1 = 1;
   else 
       intparam1 = 0;
   end

   if popupvalue == 6 | popupvalue == 12
       intparam2 = 1;
   else
       intparam2 = 0;
   end
   switch action,
      case 'motion',ud = mousemotion(ud,discrete,flag,newx,newy);
      case 'down',  ud = mousedown(ud,discrete,flag);
      case 'up',    mouseup;
      case 'setpfield',
         switch flag
             
             case 1, ud = setpfield(1,intparam1,ud,newx);  
             case 2, ud = setpfield(2,intparam2,ud,newx);
             case 3, ud = setpfield(3,[],ud,newx);
             case 4, ud = setpfield(4,[],ud,newx);
         end
      case 'setpslider',
         switch flag
             case 1, ud = setpslider(1,intparam1,ud,newx);
             case 2, ud = setpslider(2,intparam2,ud,newx);
             case 3, ud = setpslider(3,[],ud,newx);
             case 4, ud = setpslider(4,[],ud,newx);
         end
      case 'setphi',
         switch flag
            case 1, ud = setphi(1,intparam1,ud,newx);
            case 2, ud = setphi(2,intparam2,ud,newx);
            case 3, ud = setphi(3,[],ud,newx);
            case 4, ud = setphi(4,[],ud,newx);
         end
      case 'setplo',
         switch flag
            case 1, ud = setplo(1,intparam1,ud,newx);
            case 2, ud = setplo(2,intparam2,ud,newx);
            case 3, ud = setplo(3,[],ud,newx);
            case 4, ud = setplo(4,[],ud,newx);

         end
      case 'changedistribution', 
         ud = changedistribution(iscdf,popupvalue,ud,discrete);
      case 'changefunction', 
         ud = changefunction(iscdf,popupvalue,ud,discrete,newx);
      case 'editx', ud = editx(ud);
      case 'edity', ud = edity(ud);
      case 'fixalpha',ud = fixalpha(ud);
   end
end
% Initialize all GUI objects. Plot Normal CDF with sliders for parameters.
if strcmp(action,'start'),
   % Set positions of graphic objects
   axisp   = [.2 .35 .65 .25];%[.2 .35 .65 .55];
   % Create cell array of positions for parameter controls.
   pos{1,1} = [.0 .08 .10 .05];
   pos{2,1} = pos{1,1} + [.13 .06 -0.02 0];
   pos{3,1} = pos{2,1} + [0 -0.13 0 0];
   pos{4,1} = pos{1,1} + [.11 -0.07 -0.07 0.13];
   pos{5,1} = pos{1,1} + [0 0.05 0 0.03];
   
   pos{1,2} = [.25 .08 .10 .05];
   pos{2,2} = pos{1,2} + [.13 .06 -0.02 0];
   pos{3,2} = pos{2,2} + [0 -0.13 0 0];
   pos{4,2} = pos{1,2} + [.11 -0.07 -0.07 0.13];
   pos{5,2} = pos{1,2} + [0 0.05 0 0.03];

   pos{1,3} = [.50 .08 .10 .05];
   pos{2,3} = pos{1,3} + [.13 .06 -0.02 0];
   pos{3,3} = pos{2,3} + [0 -0.13 0 0];
   pos{4,3} = pos{1,3} + [.11 -0.07 -0.07 0.13];
   pos{5,3} = pos{1,3} + [0 0.05 0 0.03];

   pos{1,4} = [.75 .08 .10 .05];
   pos{2,4} = pos{1,4} + [.13 .06 -0.02 0];
   pos{3,4} = pos{2,4} + [0 -0.13 0 0];
   pos{4,4} = pos{1,4} + [.11 -0.07 -0.07 0.13];
   pos{5,4} = pos{1,4} + [0 0.05 0 0.03];
   


   xfieldp = [.46 .24 .13 .05];
   yfieldp = [0.01 .62 .13 .05];
   yfiledp1 = [0.01 .35 .13 .05];
   yfiledp2 = [0.88 .35 .13 .05]; 
   
   iscdf = 0;  %pdf

   % Distribution Data
   ud.distcells.name = {'Beta','Binomial','Chisquare','Discrete Uniform','Exponential', ...
   'F', 'Gamma', 'Geometric', 'Lognormal', 'Negative Binomial', 'Noncentral F', ...
   'Noncentral T', 'Noncentral Chi-square', 'Normal', 'Poisson', 'Rayleigh', 'T', ...
   'Uniform', 'Weibull'};

%    ud.distcells.parameters = { [1400 1350 5000 1000]};
   ud.distcells.parameters = { [1400 1400 900 30]};

   ud.distcells.pmax = {[Inf Inf Inf Inf]};

   ud.distcells.pmin = { [-Inf -Inf -Inf -1]}; 

   ud.distcells.phi = {[1500 1500 40000 1000]};

   ud.distcells.plo = { [1300 1300 1 1]}; 

   % Set axis limits and data
   xrange = [ud.distcells.plo{1}(1) - 1 * sqrt(ud.distcells.phi{1}(3)) ud.distcells.phi{1}(1) + 1 * sqrt(ud.distcells.phi{1}(3))];
   yrange   = [0 1.1];
   xvalues  = linspace(xrange(1),xrange(2),10000);
   u0=ud.distcells.parameters{1}(2);
   u1=ud.distcells.parameters{1}(1);
   vari=ud.distcells.parameters{1}(3);
   n=ud.distcells.parameters{1}(4);
   sigma = sqrt(vari/n);
   yvalues  = pdf('Normal',xvalues,u0,sigma);%cdf('Normal',xvalues,0,1);
   yvalues1 = pdf('Normal',xvalues,u1,sigma);
   newx  = 1380;
   newy  = 0;
   newyprob =  normcdf(newx,u1,sigma);  % alpha
   newyprob2 = normcdf(newx,u0,sigma);  % power
   newyprob3 = 1-newyprob2;  % beta
   dlineindex = find(abs(newx-xvalues)==min(abs(newx-xvalues)));
   yrange = [0 max(yvalues)*1.1];
   paramtext  = str2mat('H0 mean: u0 ','H1 mean:  u1','Variance: sigma^2','Sample size: n  ');
   fixalpha1 = 0;
   %   Create Cumulative Distribution Plot
   ud.dist_fig = figure('Tag','distfig');
   set(ud.dist_fig,'Units','Normalized','Backingstore','off','InvertHardcopy','on',...
        'PaperPositionMode','auto');
   figcolor = get(ud.dist_fig,'Color');

   dist_axes1 = axes('Position',axisp);
   set(dist_axes1,'NextPlot','add','DrawMode','fast',...
      'XLim',xrange,'YLim',yrange,'Box','on');
     ud.dlinearea = area(xvalues(1:dlineindex(1)),yvalues(1:dlineindex(1)),'FaceColor','c');

   ud.dline = plot(xvalues,yvalues,'b-','LineWidth',2);

   dist_axes2 = axes('Position',axisp+[0 0.35 0 0]);
   set(dist_axes2,'NextPlot','add','DrawMode','fast',...
      'XLim',xrange,'YLim',yrange,'Box','on');
     ud.dlinearea1 = area(xvalues(1:dlineindex(1)),yvalues1(1:dlineindex(1)),'FaceColor','m');

   ud.dline1 = plot(xvalues, yvalues1,'r-','LineWidth',2);
 
  % Define graphics objects
   for idx = 1:4
       nstr = int2str(idx);
       ud.pfhndl(idx) =uicontrol('Style','edit','Units','normalized','Position',pos{1,idx},...
          'String',num2str(ud.distcells.parameters{1}(idx)),'BackgroundColor','white',...
          'CallBack',['powerdemo(''setpfield'',',nstr,')']);
         
      if idx==2
       ud.hihndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{2,idx},...
         'String',num2str(ud.distcells.phi{1}(idx)),'BackgroundColor',[0.7 0.7 0.7],...
         'CallBack',['powerdemo(''setphi'',',nstr,')']);
         
       ud.lohndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{3,idx},...
         'String',num2str(ud.distcells.plo{1}(idx)),'BackgroundColor',[0.7 0.7 0.7],... 
         'CallBack',['powerdemo(''setplo'',',nstr,')']);
      else
       ud.hihndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{2,idx},...
         'String',num2str(ud.distcells.phi{1}(idx)),'BackgroundColor','white',...
         'CallBack',['powerdemo(''setphi'',',nstr,')']);
         
       ud.lohndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{3,idx},...
         'String',num2str(ud.distcells.plo{1}(idx)),'BackgroundColor','white',... 
         'CallBack',['powerdemo(''setplo'',',nstr,')']);
      end;

       ud.pslider(idx)=uicontrol('Style','slider','Units','normalized','Position',pos{4,idx},...
         'Value',ud.distcells.parameters{1}(idx),'Max',ud.distcells.phi{1}(idx),...
         'Min',ud.distcells.plo{1}(idx),'Callback',['powerdemo(''setpslider'',',nstr,')']);

       ud.ptext(idx) =uicontrol('Style','text','Units','normalized','Position',pos{5,idx},...
         'ForegroundColor','k','BackgroundColor',figcolor,'String',paramtext(idx,:)); 
   end      

   ud.yaxistext=uicontrol('Style','text','Units','normalized','Position',yfieldp + [0 0.18 0 0.01],...
        'ForegroundColor','k','BackgroundColor',figcolor,'String','P(u|h0)','FontSize',12,'FontWeight','bold'); 
   ud.yaxistext1=uicontrol('Style','text','Units','normalized','Position',yfiledp1 + [0 0.13 0 0.01],...
        'ForegroundColor','k','BackgroundColor',figcolor,'String','P(u|h1)','FontSize',12,'FontWeight','bold');     
   ud.yaxistext2=uicontrol('Style','text','Units','normalized','Position',yfiledp2 + [-0.01 0.4 0 -0.01],...
        'ForegroundColor','k','BackgroundColor',figcolor,'String','P(Type I Error)');  
   ud.yaxistext3=uicontrol('Style','text','Units','normalized','Position',yfiledp2 + [0 0.05 0 -0.01],...
        'ForegroundColor','k','BackgroundColor',figcolor,'String','Power');  
   ud.yaxistext4=uicontrol('Style','text','Units','normalized','Position',yfiledp1 + [0 0.02 0 -0.01],...
        'ForegroundColor','k','BackgroundColor',figcolor,'String','P(Type II Error)');  
    
    ud.popup=uicontrol('Style','Popup','String',...
  'Beta|Binomial|Chi-square|Discrete Uniform|Exponential|F|Gamma|Geometric|Lognormal|Negative Binomial|Noncentral F|Noncentral T|Noncentral Chi-square|Normal|Poisson|Rayleigh|T|Uniform|Weibull',...
        'Units','normalized','Position',[.41 .92 .25 .06],...
        'UserData','popup','Value',14,'BackgroundColor','w',...
        'CallBack','powerdemo(''changedistribution'')');

   ud.functionpopup=uicontrol('Style','Popup','String',...
        'CDF|PDF','Value',2,'Units','normalized',...
        'Position',[.71 .92 .15 .06],'BackgroundColor','w',...
        'CallBack','powerdemo(''changefunction'')');
    
    
   ud.xfield=uicontrol('Style','edit','Units','normalized','Position',xfieldp,...
         'String',num2str(newx),'BackgroundColor','white',...
         'CallBack','powerdemo(''editx'')','UserData',newx);
         
   ud.yfield=uicontrol('Style','edit','Units','normalized','Position',yfieldp,...
         'BackgroundColor','white','String',num2str(newy),...
		 'UserData',newy,'CallBack','powerdemo(''edity'')');
     
   ud.yfield1=uicontrol('Style','edit','Units','normalized','Position',yfiledp2+[0 0.35 0 0],...
         'BackgroundColor','white','String',num2str(newyprob),...
		 'UserData',newyprob,'CallBack','powerdemo(''edity'')');   
   
   ud.yfield2=uicontrol('Style','edit','Units','normalized','Position',yfiledp2,...
         'BackgroundColor','white','String',num2str(newyprob2),...
		 'UserData',newyprob2,'CallBack','powerdemo(''edity'')');  
     
   ud.yfield3=uicontrol('Style','edit','Units','normalized','Position',yfiledp1 + [0 -0.03 0 0.0],...
         'BackgroundColor','white','String',num2str(newyprob3),...
		 'UserData',newyprob3,'CallBack','powerdemo(''edity'')');  
     
   close_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.01 0.9 0.13 0.05],'Callback','close','String','Close');
   ud.fix_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.86 0.9 0.14 0.05],'UserData',0,...
               'Callback','powerdemo(''fixalpha'')','String','Change alpha');
    set(ud.popup,'Visible','off');
    set(ud.functionpopup,'Visible','off');
    set(ud.yfield,'Visible','off');

   %   Create Reference Lines
   dist_axes3 = axes('Position',axisp+[0 0 0 0.35]);
   set(dist_axes3,'NextPlot','add','DrawMode','fast',...
      'XLim',xrange,'YLim',yrange,'Box','off','Visible','off');

%    ud.vline = plot([newx newx],yrange,'g-.','EraseMode','xor');
%    ud.hline = plot(xrange,[0.5 0.5],'g-.','EraseMode','xor');
   ud.vline = plot([newx newx],yrange,'g','EraseMode','xor','linewidth',2);
   ud.hline = plot(xrange,[0.5 0.5],'g','EraseMode','xor','linewidth',2);

   set(ud.vline,'ButtonDownFcn','powerdemo(''down'',1)');
   set(ud.hline,'ButtonDownFcn','powerdemo(''down'',2)');

   set(ud.dist_fig,'Backingstore','off','WindowButtonMotionFcn','powerdemo(''motion'',0)',...
      'WindowButtonDownFcn','powerdemo(''down'',1)','Userdata',ud,'HandleVisibility','callback');
   set(ud.hline,'Visible','off');
   
  for idx=1:2
    minstepsize=1/(str2double(get(ud.hihndl(1),'String'))-str2double(get(ud.lohndl(1),'String')));
    set(ud.pslider(idx),'SliderStep',[minstepsize 10*minstepsize]);
  end;
    for idx=3:4
    minstepsize=1/(str2double(get(ud.hihndl(idx),'String'))-str2double(get(ud.lohndl(idx),'String')));
    set(ud.pslider(idx),'SliderStep',[minstepsize 10*minstepsize]);
  end;

end

% End of initialization.
set(ud.dist_fig,'UserData',ud);
% END OF powerdemo MAIN FUNCTION.

% BEGIN HELPER  FUNCTIONS.
% Update graphic objects in GUI. UPDATEGUI
function ud = updategui(ud,xvalues,yvalues,xrange,yrange,newx,newy,newyprob,newyprob2,yvalues1)
if ~isempty(xvalues) & ~isempty(yvalues)
   set(ud.dline,'XData',xvalues,'Ydata',yvalues,'Color','b');
   set(ud.dline1,'XData',xvalues,'Ydata',yvalues1,'Color','r');
   	for idx = 1:4
        pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
	end
   if strcmp(get(ud.fix_button,'String'),'Change alpha') ==0  % alpha is changable
        alphafixvalue=str2num(get(ud.yfield1,'String'));
        if alphafixvalue<0.01
            alphafixvalue=round(alphafixvalue*1000)/1000;
        elseif alphafixvalue<0.1
            alphafixvalue=round(alphafixvalue*100)/100;
        elseif alphafixvalue<1
            alphafixvalue=round(alphafixvalue*10)/10;
        end;
        if pval(1)>pval(2)
            newx = norminv(alphafixvalue, pval(1),sqrt(pval(3)/pval(4)));
		else
            newx = norminv(1-alphafixvalue,pval(1),sqrt(pval(3)/pval(4)));
		end;
        set(ud.xfield,'String',num2str(newx),'UserData',newx); 
        set(ud.vline,'XData',[newx newx],'YData',yrange);    
        newy = getnewy(newx,ud);
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        newyprob3 = 1-newyprob2;

  end;  
   dlineindex = find(abs(newx-xvalues)==min(abs(newx-xvalues)));
	if newx<max(xvalues) & newx>min(xvalues)
		if pval(1)>=pval(2)  % on the left side
            set( ud.dlinearea1, 'XData',[xvalues(1:dlineindex) xvalues(dlineindex+1)],'Ydata',[yvalues1(1:dlineindex) 0]);
            set( ud.dlinearea, 'XData',[xvalues(1:dlineindex) xvalues(dlineindex+1)],'Ydata',[yvalues(1:dlineindex) 0]);
        else
            set( ud.dlinearea1, 'XData',[xvalues(dlineindex-1) xvalues(dlineindex:end)] ,'Ydata',[0 yvalues1(dlineindex:end)] );
            set( ud.dlinearea, 'XData',[xvalues(dlineindex-1) xvalues(dlineindex:end)] ,'Ydata',[0 yvalues(dlineindex:end)] );
        end;
	end;
  
  for idx=1:4
    minstepsize=1/(str2double(get(ud.hihndl(idx),'String'))-str2double(get(ud.lohndl(idx),'String')));
    set(ud.pslider(idx),'SliderStep',[minstepsize 10*minstepsize]);
  end;
	axisp   = [.2 .35 .65 .25];   
	dist_axes1 = findobj('Position',axisp);
	dist_axes2 = findobj('Position',axisp+[0 0.35 0 0]);
	dist_axes3 = findobj('Position',axisp+[0 0 0 0.35]);
	
	set( dist_axes1,'Xlim',[xrange(1) xrange(2)]);
	set( dist_axes2,'Xlim',[xrange(1) xrange(2)]);
	set( dist_axes3,'Xlim',[xrange(1) xrange(2)]);
    
   set(ud.hihndl(2),'String',get(ud.hihndl(1),'String')); 
   set(ud.lohndl(2),'String',get(ud.lohndl(1),'String')); 
  

end

if isempty(xrange)
   xrange = get(gcba,'Xlim');
end
if isempty(yrange)
   yrange = get(gcba,'Ylim');
end
if ~isempty(newy), 
    set(ud.yfield,'String',num2str(newy),'UserData',newy); 
    set(ud.hline,'XData',xrange,'YData',[newy newy]);
end
if ~isempty(newx), 
    if strcmp(get(ud.fix_button,'String'),'Change alpha')   % alpha is changable
        set(ud.xfield,'String',num2str(newx),'UserData',newx); 
        set(ud.vline,'XData',[newx newx],'YData',yrange);
    else  % alpha is fixed
    	for idx = 1:4
            pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
		end
        alphafixvalue=str2num(get(ud.yfield1,'String'));
        if alphafixvalue<0.01
            alphafixvalue=round(alphafixvalue*1000)/1000;
        elseif alphafixvalue<0.1
            alphafixvalue=round(alphafixvalue*100)/100;
        elseif alphafixvalue<1
            alphafixvalue=round(alphafixvalue*10)/10;
        end;
        if pval(1)>pval(2)
            newyxtemp = norminv(alphafixvalue, pval(1),sqrt(pval(3)/pval(4)));
		else
            newyxtemp = norminv(1-alphafixvalue,pval(1),sqrt(pval(3)/pval(4)));
		end;
        set(ud.xfield,'String',num2str(newyxtemp),'UserData',newyxtemp); 
        set(ud.vline,'XData',[newyxtemp newyxtemp],'YData',yrange);      
        
    end;
    [xrange, xvalues] = getxdata(2,1,ud);
    yvalues = getnewy(xvalues,ud);yvalues1 = getnewy1(xvalues,ud);

    dlineindex = find(abs(newx-xvalues)==min(abs(newx-xvalues)));
	for idx = 1:2
        pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
	end
    if newx<max(xvalues) & newx>min(xvalues)
		if pval(1)>=pval(2)  % on the left side
            set( ud.dlinearea1, 'XData',[xvalues(1:dlineindex) xvalues(dlineindex+1)],'Ydata',[yvalues1(1:dlineindex) 0]);
            set( ud.dlinearea, 'XData',[xvalues(1:dlineindex) xvalues(dlineindex+1)],'Ydata',[yvalues(1:dlineindex) 0]);
        else
            set( ud.dlinearea1, 'XData',[xvalues(dlineindex-1) xvalues(dlineindex:end)] ,'Ydata',[0 yvalues1(dlineindex:end)] );
            set( ud.dlinearea, 'XData',[xvalues(dlineindex-1) xvalues(dlineindex:end)] ,'Ydata',[0 yvalues(dlineindex:end)] );
        end;
    end;
end

if nargin>7
    set(ud.yfield1,'Visible','on');
    set(ud.yfield2,'Visible','on');
    set(ud.yaxistext1,'Visible','on');
    set(ud.yaxistext2,'Visible','on');
	if ~isempty(newyprob),
        set(ud.yfield1,'String',num2str(newyprob),'UserData',newyprob);
	end;
	if ~isempty(newyprob2),
        newyprob3=1-newyprob2;
        set(ud.yfield2,'String',num2str(newyprob2),'UserData',newyprob2);
        set(ud.yfield3,'String',num2str(newyprob3),'UserData',newyprob3);
	end;
else
    set(ud.yfield1,'Visible','off');
    set(ud.yfield2,'Visible','off');
    set(ud.yaxistext1,'Visible','off');
    set(ud.yaxistext2,'Visible','off');
end;

% Calculate new probability or density given a new "X" value. GETNEWY
function newy = getnewy(newx,ud)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
name = 'Normal';%ud.distcells.name{popupvalue};
nparams = 4;%length(ud.distcells.parameters{popupvalue});
for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end
if iscdf
    newy=cdf(name,newx,pval(2),sqrt(pval(3)/pval(4)));
else
    newy=pdf(name,newx,pval(2),sqrt(pval(3)/pval(4)));
end

function newy = getnewy1(newx,ud)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
name = 'Normal';%ud.distcells.name{popupvalue};
nparams = 4;%length(ud.distcells.parameters{popupvalue});
for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end
if iscdf
    newy=cdf(name,newx,pval(1),sqrt(pval(3)/pval(4)));
else
    newy=pdf(name,newx,pval(1),sqrt(pval(3)/pval(4)));
end

function newyprob = getnewyprob(newx,ud)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
name = 'Normal';%ud.distcells.name{popupvalue}
nparams = 4;%length(ud.distcells.parameters{popupvalue})
for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end
if pval(1)>pval(2)
    newyprob = cdf(name,newx,pval(1),sqrt(pval(3)/pval(4)));
else
    newyprob = 1-cdf(name,newx,pval(1),sqrt(pval(3)/pval(4)));
end;
   

function newyprob = getnewyprob1(newx,ud)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
name = 'Normal';%ud.distcells.name{popupvalue}
nparams = 4;%length(ud.distcells.parameters{popupvalue})
for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end
if pval(1)>pval(2)
   newyprob = cdf(name,newx,pval(2),sqrt(pval(3)/pval(4)));
else
    newyprob = 1-cdf(name,newx,pval(2),sqrt(pval(3)/pval(4)));
end;


% Supply x-axis range and x data values for each distribution. GETXDATA
function [xrange, xvalues] = getxdata(iscdf,popupvalue,ud)
phi = ud.distcells.phi{popupvalue};
plo = ud.distcells.plo{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
popupvalue=14;
switch popupvalue
    case 1, % Beta 
       xrange  = [0 1];
       xvalues = [0.01:0.01:0.99];
    case 2, % Binomial 
       xrange  = [0 phi(1)];
       xvalues = [0:phi(1)];
       if iscdf
          xvalues = [xvalues - sqrt(eps);xvalues];
          xvalues = xvalues(:)';
       end
	case 3, % Chi-square
       xrange  = [0 phi + 4 * sqrt(2 * phi)];
       xvalues = linspace(0,xrange(2),10000);
    case 4, % Discrete Uniform
       xrange  = [0 phi];
       xvalues = [0:phi];
       if iscdf
          xvalues = [xvalues - sqrt(eps);xvalues];
          xvalues = xvalues(:)';
       end
    case 5, % Exponential
       xrange  = [0 4*phi];
       xvalues = [0:0.1*parameters:4*phi];
    case 6, % F 
       xrange  = [0 finv(0.995,plo(1),plo(1))];
       xvalues = linspace(xrange(1),xrange(2));
    case 7, % Gamma
       hixvalue = phi(1) * phi(2) + 4*sqrt(phi(1) * phi(2) * phi(2));
       xrange  = [0 hixvalue];
       xvalues = linspace(0,hixvalue);
    case 8, % Geometric
       hixvalue = geoinv(0.99,plo(1));
       xrange  = [0 hixvalue];       
       xvalues = [0:round(hixvalue)];
       if iscdf
          xvalues = [xvalues - sqrt(eps);xvalues];
          xvalues = xvalues(:)';
       end
    case 9, % Lognormal
       xrange = [0 logninv(0.99,phi(1),phi(2))];
       xvalues = linspace(0,xrange(2));
    case 10, % Negative Binomial
       xrange = [0 nbininv(0.99,phi(1),plo(2))];
       xvalues = 0:xrange(2);
       if iscdf,
          xvalues = [xvalues - sqrt(eps);xvalues];
          xvalues = xvalues(:)';
       end
    case 11, % Noncentral F
       xrange = [0 phi(3)+30];
       xvalues = linspace(sqrt(eps),xrange(2));
    case 12, % Noncentral T
       xrange = [phi(2)-14 phi(2)+14];
       xvalues = linspace(xrange(1),xrange(2));
    case 13, % Noncentral Chi-square
       xrange = [0 phi(2)+30];
       xvalues = linspace(sqrt(eps),xrange(2));
    case 14, % Normal
       xrange   = [plo(1) - 1 * sqrt(phi(3)) phi(1) + 1 * sqrt(phi(3))];
       steptemp=0.0001*(phi(1) + 2 * sqrt(phi(3))-plo(1));
       xvalues  = [plo(1) - 1 * sqrt(phi(3)):steptemp:phi(1) + 1 * sqrt(phi(3))];
    case 15, % Poisson
      xrange  = [0 4*phi(1)];
      xvalues = [0:round(4*parameters(1))];
      if iscdf
         xvalues = [xvalues - sqrt(eps);xvalues];
         xvalues = xvalues(:)';
      end
    case 16, % Rayleigh
       xrange = [0 raylinv(0.995,phi(1))];
       xvalues = linspace(xrange(1),xrange(2),10000);
    case 17, % T
       lowxvalue = tinv(0.005,plo(1));
       xrange  = [lowxvalue -lowxvalue];
       xvalues = linspace(xrange(1),xrange(2),101);
    case 18, % Uniform
       xrange  = [plo(1) phi(2)];
       if iscdf
          xvalues = [plo(1) ...
                     parameters(1)-eps*abs(parameters(1)) ...
                     parameters(1)+eps*abs(parameters(1)) ...
                     parameters(2)-eps*abs(parameters(2)) ...
                     parameters(2)+eps*abs(parameters(2)) ...
                     phi(2)];
       else
          xvalues = [parameters(1)+eps*abs(parameters(1)) ...
                     parameters(2)-eps*abs(parameters(2))];
       end
    case 19, % Weibull
       xrange  = [0 weibinv(0.995,plo(1),plo(2))];
       xvalues = linspace(xrange(1),xrange(2));
end
% END HELPER FUNCTIONS.

% BEGIN CALLBACK FUNCTIONS.
% Track a mouse moving in the GUI. MOUSEMOTION
function ud = mousemotion(ud,discrete,flag,newx,newy)
popupvalue = 1;%get(ud.popup,'Value');
parameters = ud.distcells.parameters{popupvalue};
name = ud.distcells.name{popupvalue};
xrange = get(gcba,'Xlim');
yrange = get(gcba,'Ylim');
iscdf = 2 - get(ud.functionpopup,'Value');

if strcmp(get(ud.fix_button,'String'),'Change alpha')

if flag == 0,
    cursorstate = get(gcbf,'Pointer');
    cp = get(gcba,'CurrentPoint');
    cx = cp(1,1);
    cy = cp(1,2);
    fuzzx = 0.00001 * (xrange(2) - xrange(1));
    fuzzy = 0.00001 * (yrange(2) - yrange(1));
    online = cy > yrange(1) & cy < yrange(2) & cx > xrange(1) & cx < xrange(2) &...
           ((cy > newy - fuzzy & cy < newy + fuzzy) | (cx > newx - fuzzx & cx < newx + fuzzx));
    if online & strcmp(cursorstate,'arrow'),
         set(gcbf,'Pointer','crosshair');
    elseif ~online & strcmp(cursorstate,'crosshair'),
         set(gcbf,'Pointer','arrow');
    end
    
elseif flag == 1
    cp = get(gcba,'CurrentPoint');
    newx=cp(1,1);
    if discrete,
         newx = round(newx);
    end
    if newx > xrange(2)
         newx = xrange(2);
    end
    if newx < xrange(1)
         newx = xrange(1);
    end


    newy = getnewy(newx,ud);  
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud);
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,[],[],xrange,yrange,newx,newy,newyprob,newyprob2,[]);    
    else
        ud = updategui(ud,[],[],xrange,yrange,newx,newy);    
    end;


elseif flag == 2
    cp = get(gcba,'CurrentPoint');
    newy=cp(1,2);
    if newy > yrange(2)
        newy = yrange(2);
    end
    if newy < yrange(1)
        newy = yrange(1);
    end

    nparams = length(parameters);
    for idx = 1:nparams
       pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
    end
    switch nparams
        case 1, newx = icdf(name,newy,pval(1));
        case 2, newx = icdf(name,newy,pval(1),pval(2));
        case 3, newx = icdf(name,newy,pval(1),pval(2),pval(3));
    end
    
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,[],[],xrange,yrange,newx,newy,newyprob,newyprob2,[]);    
    else
        ud = updategui(ud,[],[],xrange,yrange,newx,newy,[]);    
    end;
end

end;

% Callback for mousing down in the GUI. MOUSEDOWN
function ud = mousedown(ud,discrete,flag);
xrange = get(gcba,'Xlim');
yrange = get(gcba,'Ylim');

if strcmp(get(ud.fix_button,'String'),'Change alpha')

set(gcbf,'Pointer','crosshair');
cp = get(gcba,'CurrentPoint');
newx=cp(1,1);
if discrete,
   newx = round(newx);
end
if newx > xrange(2)
   newx = xrange(2);
end
if newx < xrange(1)
   newx = xrange(1);
end
newy = getnewy(newx,ud);
iscdf = 2 - get(ud.functionpopup,'Value');

if iscdf==0   % for pdf
    newyprob = getnewyprob(newx,ud); 
    newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,[],[],xrange,yrange,newx,newy,newyprob,newyprob2,[]);    
else
    ud = updategui(ud,[],[],xrange,yrange,newx,newy,[]);    
end;    
      
if flag == 1
   set(gcbf,'WindowButtonMotionFcn','powerdemo(''motion'',1)');
elseif flag == 2
   set(gcbf,'WindowButtonMotionFcn','powerdemo(''motion'',2)');
end
set(gcbf,'WindowButtonUpFcn','powerdemo(''up'')');
end;
% End mousemotion function.

% Callback for mousing up in the GUI. MOUSEUP
function mouseup
set(gcbf,'WindowButtonMotionFcn','powerdemo(''motion'',0)');
set(gcbf,'WindowButtonUpFcn','');

% Callback for editing x-axis text field. EDITX
function ud = editx(ud)
iscdf = 2 - get(ud.functionpopup,'Value');
xrange = get(gcba,'Xlim');
yrange = get(gcba,'Ylim');
    newx=str2double(get(ud.xfield,'String'));
    if isempty(newx) 
       newx = get(ud.xfield,'Userdata');
       set(ud.xfield,'String',num2str(newx));
       warndlg('Critical values must be numeric. Resetting to previous value.');
       return;
    end
    xrange = get(gcba,'Xlim');
    if newx > xrange(2)
        newx = xrange(2);
        set(ud.xfield,'String',num2str(newx));
    end
    if newx < xrange(1)
        newx = xrange(1);
        set(ud.xfield,'String',num2str(newx));
    end
    newy = getnewy(newx,ud);    
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,[],[],xrange,yrange,newx,newy,newyprob,newyprob2,[]);    
    else
        ud = updategui(ud,[],[],xrange,yrange,newx,newy,[]);    
    end;

    
    
% Callback for editing y-axis text field. EDITY
function ud = edity(ud)
iscdf = 2 - get(ud.functionpopup,'Value');
xrange = get(gcba,'Xlim');
yrange = get(gcba,'Ylim');
popupvalue = get(ud.popup,'Value');
parameters = ud.distcells.parameters{1};%{popupvalue};
name = ud.distcells.name{popupvalue};
newy=str2double(get(ud.yfield1,'String'));
if isempty(newy) 
   newy = get(ud.yfield1,'Userdata');
   set(ud.yfield1,'String',num2str(newy));
   warndlg('Probabilities must be numeric. Resetting to previous value.');
   return;
end

if newy > 1
    newy = 1;
    set(ud.yfield1,'String',num2str(newy),'UserData',newy);
end
if newy < 0
    newy = 0;
    set(ud.yfield1,'String',num2str(newy),'UserData',newy);
end
nparams = length(parameters);
for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end
switch nparams
    case 1, newx = icdf(name,newy,pval(1));
    case 2, newx = icdf(name,newy,pval(1),pval(2));
    case 3, newx = icdf(name,newy,pval(1),pval(2),pval(3));
    case 4, 
        if pval(1)>pval(2)
            newx = norminv(newy, pval(1),sqrt(pval(3)/pval(4)));
	    else
            newx = norminv(1-newy,pval(1),sqrt(pval(3)/pval(4)));
	    end;
end
if iscdf==0   % for pdf
    newyprob = getnewyprob(newx,ud); 
    newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,[],[],xrange,yrange,newx,newy,newyprob,newyprob2,[]);    
else
    ud = updategui(ud,[],[],xrange,yrange,newx,newy,[]);    
end;

% Callback for changing probability distribution function. CHANGEDISTRIBUTION
function ud = changedistribution(iscdf,popupvalue,ud,discrete)
text1 = {'A','Trials','df','Number','Lambda','df1','A','Prob','Mu','R','df1','df',...
            'df','Mu','Lambda','B','df','Min','A'}; 
text2 = {'B','Prob',[],[],[],'df2','B',[],'Sigma','Prob','df2','delta','delta',...
            'Sigma',[],[],[],'Max','B'};
set(ud.ptext(1),'String',text1{popupvalue});

name       = ud.distcells.name{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
pmax       = ud.distcells.pmax{popupvalue};
pmin       = ud.distcells.pmin{popupvalue};
phi        = ud.distcells.phi{popupvalue};
plo        = ud.distcells.plo{popupvalue};

[xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
set(gcba,'Xlim',xrange);
newx = mean(xrange);

nparams = length(parameters);
if nparams > 1
    set(ud.ptext(2),'String',text2{popupvalue});
    if popupvalue == 11
       set(ud.ptext(3),'String','delta');
    end
end

switch nparams
   case 1,
	set(ud.ptext(2:3),'Visible','off');
    set(ud.pslider(2:3),'Visible','off');
    set(ud.pfhndl(2:3),'Visible','off');
    set(ud.lohndl(2:3),'Visible','off');
    set(ud.hihndl(2:3),'Visible','off');
   case 2,
	set(ud.ptext(1:2),'Visible','on');
    set(ud.pslider(1:2),'Visible','on');
    set(ud.pfhndl(1:2),'Visible','on');
    set(ud.lohndl(1:2),'Visible','on');
    set(ud.hihndl(1:2),'Visible','on');
	set(ud.ptext(3),'Visible','off');
    set(ud.pslider(3),'Visible','off');
    set(ud.pfhndl(3),'Visible','off');
    set(ud.lohndl(3),'Visible','off');
    set(ud.hihndl(3),'Visible','off');
   case 3
 	set(ud.ptext(1:3),'Visible','on');
    set(ud.pslider(1:3),'Visible','on');
    set(ud.pfhndl(1:3),'Visible','on');
    set(ud.lohndl(1:3),'Visible','on');
    set(ud.hihndl(1:3),'Visible','on');
end
    
set(ud.dline,'Marker','none','LineStyle','-');   

if iscdf,
    set(ud.hline,'Visible','on');
else
    set(ud.hline,'Visible','off');
    if discrete,
        set(ud.dline,'Marker','o','LineStyle','none');
    end
end
for idx = 1:nparams
    set(ud.pfhndl(idx),'String',num2str(parameters(idx)));
    set(ud.lohndl(idx),'String',num2str(plo(idx)));
    set(ud.hihndl(idx),'String',num2str(phi(idx)));
    set(ud.pslider(idx),'Min',plo(idx),'Max',phi(idx),'Value',parameters(idx));
end
if iscdf,
    set(ud.yfield1,'Visible','off');
    set(ud.yfield2,'Visible','off');
    set(ud.yaxistext1,'Visible','off');
    set(ud.yaxistext2,'Visible','off');
%    ud = updategui(ud,xvalues,yvalues,[],yrange,newx,newy);
    ud = changefunction(iscdf,popupvalue,ud,discrete,newx);

else
    set(ud.yfield1,'Visible','on');
    set(ud.yfield2,'Visible','on');
    set(ud.yaxistext1,'Visible','on');
    set(ud.yaxistext2,'Visible','on');
    ud = changefunctionpdf(iscdf,popupvalue,ud,discrete,newx);%updategui(ud,xvalues,yvalues,[],yrange,newx,newy,newyprob,newyprob2);
end
% End of changedistribution function.

% Toggle CDF/PDF or PDF/CDF. CHANGEFUNCTION 
function ud = changefunction(iscdf,popupvalue,ud,discrete,newx)
name       = ud.distcells.name{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
pmax       = ud.distcells.pmax{popupvalue};
pmin       = ud.distcells.pmin{popupvalue};
phi        = ud.distcells.phi{popupvalue};
plo        = ud.distcells.plo{popupvalue};

if iscdf
  xrange = get(gcba,'Xlim'); 
  yrange = [0 1.1];
  set(gcba,'Ylim',yrange);
end
[xrange, xvalues] = getxdata(iscdf, popupvalue, ud);
nparams = length(parameters);
for idx = 1:nparams
    set(ud.pfhndl(idx),'String',num2str(parameters(idx)));
end  
yvalues = getnewy(xvalues,ud);
newy = getnewy(newx,ud);
yvalues1 = getnewy1(xvalues,ud);
if iscdf;
    set(ud.yaxistext,'String','Probability');
    set(ud.yfield,'Style','edit','BackgroundColor','white');
    set(ud.hline,'Visible','on');
    yrange = [0 1.1];
    set(gcba,'YLim',yrange);
    set(ud.dline,'LineStyle','-','Marker','none');  
    ud = updategui(ud,xvalues,yvalues,xrange,yrange,newx,newy,yvalues1);    
else
    set(ud.yaxistext,'String','Density');
    set(ud.hline,'Visible','off');
    if discrete,
        set(ud.dline,'Marker','o','LineStyle','none');
    else
        set(ud.dline,'Marker','none','LineStyle','-');
    end
    ud = changefunctionpdf(iscdf,popupvalue,ud,discrete,newx);

end
% End changefunction.

function ud = changefunctionpdf(iscdf,popupvalue,ud,discrete,newx)
name       = ud.distcells.name{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
pmax       = ud.distcells.pmax{popupvalue};
pmin       = ud.distcells.pmin{popupvalue};
phi        = ud.distcells.phi{popupvalue};
plo        = ud.distcells.plo{popupvalue};

if ~iscdf
  xrange = get(gcba,'Xlim'); 
  switch popupvalue
    case 1,   % Beta   
       tempx = [0.01 0.1:0.1:0.9 0.99];
       temp1 = linspace(plo(1),phi(1),21);
       temp2 = linspace(plo(2),phi(2),21);
       [x p1 p2] = meshgrid(tempx,temp1,temp2);
       maxy = pdf(name,x,p1,p2);
    case 2,  % Binomial
       maxy = 1;
    case 3,  % Chisquare
       tempx = linspace(xrange(1),xrange(2),101);
       maxy = pdf(name,tempx,plo);
    case 4,  % Discrete Uniform  
       maxy = 1 ./ plo;
    case 5,  % Exponential 
       maxy = 1 / plo;
    case 6,  % F
       tempx = linspace(xrange(1),xrange(2),101);
       temp1 = [plo(1):phi(1)];
       temp2 = [plo(2):plo(2)];
       [x p1 p2] = meshgrid(tempx,temp1,temp2);                
       maxy = 1.05*pdf(name,x,p1,p2);
    case 7,  % Gamma
       tempx = [0.1 linspace(xrange(1),xrange(2),101)];
       temp1 = linspace(plo(1),phi(1),11);
       temp2 = linspace(plo(2),phi(2),11);
       [x p1 p2] = meshgrid(tempx,temp1,temp2);
       maxy = pdf(name,x,p1,p2);
    case 8,  % Geometric  
       maxy = phi(1);
    case 9,  % Lognormal
       x = exp(linspace(plo(1),plo(1)+0.5*plo(2).^2));
       maxy = pdf(name,x,plo(1),plo(2));
    case 10, % Negative Binomial   
       maxy = 0.91;      
    case 11, % Noncentral F
       maxy = 0.4;
    case 12, % Noncentral T
       maxy = 0.4;
    case 13, % Noncentral Chisquare
       maxy = 0.4;
    case 14, % Normal 
       maxy = pdf(name,0,0,plo(2));
    case 15, % Poisson  
       maxy = pdf(name,[0 plo(1)],plo(1));
    case 16, % Rayleigh
       maxy = 0.6;  
    case 17, % T
       maxy = 0.4;  
    case 18, % Uniform  
       maxy = 1 ./ (plo(2) - phi(1));
    case 19, % Weibull
       tempx = [0.05 linspace(xrange(1),xrange(2),21)];
       temp1 = linspace(plo(1),phi(1),21);
       temp2 = linspace(plo(2),phi(2),21);
       [x p1 p2] = meshgrid(tempx,temp1,temp2);
       maxy = pdf(name,x,p1,p2);
  end
  ymax = abs(1.1 .* nanmax(maxy(:)));
  if ~isempty(ymax) & ~isnan(ymax) & ~isinf(ymax)
      yrange = [0 abs(1.1 .* max(ymax(:)))];
  else
      yrange = [0 1.1];
  end
  set(gcba,'Ylim',yrange);
end
[xrange, xvalues] = getxdata(iscdf, popupvalue, ud);
nparams = length(parameters);
for idx = 1:nparams
    set(ud.pfhndl(idx),'String',num2str(parameters(idx)));
end  
yvalues = getnewy(xvalues,ud);
newy = getnewy(newx,ud);
yvalues1 = getnewy1(xvalues,ud);
if iscdf;
    set(ud.yaxistext,'String','Probability');
    set(ud.yfield,'Style','edit','BackgroundColor','white');
    set(ud.hline,'Visible','on');
    yrange = [0 1.1];
    set(gcba,'YLim',yrange);
    set(ud.dline,'LineStyle','-','Marker','none');  
    ud = changedistribution(iscdf,popupvalue,ud,discrete);
else
    set(ud.yaxistext,'String','Density');
    set(ud.yfield,'Style','text','BackgroundColor',[0.8 0.8 0.8]);
    set(ud.hline,'Visible','off');
    if discrete,
        set(ud.dline,'Marker','o','LineStyle','none');
    else
        set(ud.dline,'Marker','none','LineStyle','-');
    end
    yvalues = getnewy(xvalues,ud);
    newyprob = getnewyprob(newx,ud); 
    newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,xvalues,yvalues,xrange,yrange,newx,newy,newyprob,newyprob2,yvalues1);    

end
% End changefunctionpdf

% Callback for controlling lower bound of the parameters using editable text boxes.
function ud = setplo(fieldno,intparam,ud,newx)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
cv   = str2double(get(ud.lohndl(fieldno),'String'));
pv   = str2double(get(ud.pfhndl(fieldno),'String'));
pmin = ud.distcells.pmin{popupvalue}(fieldno);
pmax = ud.distcells.pmax{popupvalue}(fieldno);
cmax = str2double(get(ud.hihndl(fieldno),'String'));


if cv > pmin & cv < pmax,
    if intparam    
        cv = round(cv);
        set(ud.lohndl(fieldno),'String',num2str(cv));
    end
	if cv >= cmax
	   cv = get(ud.pslider(fieldno),'Min');
       set(ud.lohndl(fieldno),'String',num2str(cv));
    elseif cv > pv
        set(ud.pfhndl(fieldno),'String',num2str(cv));
        set(ud.lohndl(fieldno),'String',num2str(cv));
        ud = setpfield(fieldno,intparam,ud,newx);
    end

    set(ud.pslider(fieldno),'Min',cv);
    ud.distcells.plo{popupvalue}(fieldno) = cv;
    [xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
    yvalues = getnewy(xvalues,ud);yvalues1 = getnewy1(xvalues,ud);
    newy = getnewy(newx,ud);
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
    else
        ud = updategui(ud,xvalues,yvalues,xrange,[],[],[],yvalues1);    
    end;
elseif cv >= pmax
   set(ud.lohndl(fieldno),'String',get(ud.pslider(fieldno),'Min'));
else
   set(ud.lohndl(fieldno),'String',num2str(ud.distcells.plo{popupvalue}(fieldno)));
end
[xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
yvalues = getnewy(xvalues,ud);yvalues1 = getnewy1(xvalues,ud);
if iscdf==0   % for pdf
    newyprob = getnewyprob(newx,ud); 
    newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
else
    ud = updategui(ud,xvalues,yvalues,xrange,[],[],[],[],[],yvalues1);    
end;
    
% Callback for controlling upper bound of the parameters using editable text boxes.
function ud = setphi(fieldno,intparam,ud,newx)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
cv   = str2double(get(ud.hihndl(fieldno),'String'));
pv = str2double(get(ud.pfhndl(fieldno),'String'));
pmin = ud.distcells.pmin{popupvalue}(fieldno);
pmax = ud.distcells.pmax{popupvalue}(fieldno);
cmin = str2double(get(ud.lohndl(fieldno),'String'));
if cv > pmin & cv < pmax,
    if intparam
        cv = round(cv);
        set(ud.hihndl(fieldno),'String',num2str(cv));
    end
	if cv <= cmin
	   cv = get(ud.pslider(fieldno),'Max');
       set(ud.hihndl(fieldno),'String',num2str(cv));
    elseif cv < pv
       set(ud.hihndl(fieldno),'String',num2str(cv));
       set(ud.pfhndl(fieldno),'String',num2str(cv));
       ud = setpfield(fieldno,intparam,ud,newx);
	end

    set(ud.pslider(fieldno),'Max',cv);
    ud.distcells.phi{popupvalue}(fieldno) = cv;
    [xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
    yvalues = getnewy(xvalues,ud);yvalues1 = getnewy1(xvalues,ud);
    newy = getnewy(newx,ud);
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud);
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
    else
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,[],[],yvalues1);    
    end;
elseif cv <= pmax
   set(ud.hihndl(fieldno),'String',get(ud.pslider(fieldno),'Max'));
else
    set(ud.hihndl(fieldno),'String',num2str(ud.distcells.phi{popupvalue}(fieldno)));
end
[xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
yvalues = getnewy(xvalues,ud);yvalues1 = getnewy1(xvalues,ud);
if iscdf==0   % for pdf
    newyprob = getnewyprob(newx,ud); 
    newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
else
    ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,[],[],yvalues1);    
end;

% Callback for controlling the parameter values using sliders.
function ud = setpslider(sliderno,intparam,ud,newx)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
cv = get(ud.pslider(sliderno),'Value');
% if intparam
    cv = round(cv);
% end

% Set string value, then re-read in case of rounding
set(ud.pfhndl(sliderno),'String',num2str(cv));
cv = str2double(get(ud.pfhndl(sliderno),'String'));
ud.distcells.parameters{popupvalue}(sliderno) = cv;
[xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
yvalues = getnewy(xvalues,ud);
yvalues1 = getnewy1(xvalues,ud);
newy = getnewy(newx,ud);
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
    else
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,[],[],yvalues1);    
    end;
    
% Callback for controlling the parameter values using editable text boxes.
function ud = setpfield(fieldno,intparam,ud,newx)
iscdf = 2 - get(ud.functionpopup,'Value');
popupvalue = 1;%get(ud.popup,'Value');
cv = str2double(get(ud.pfhndl(fieldno),'String'));
pmin = ud.distcells.pmin{popupvalue}(fieldno);
pmax = ud.distcells.pmax{popupvalue}(fieldno);
phivalue = str2double(get(ud.hihndl(fieldno),'String'));
plovalue = str2double(get(ud.lohndl(fieldno),'String'));
if cv > pmin & cv < pmax,
    if ~intparam
       set(ud.pslider(fieldno),'Value',cv);
    else
       cv = round(cv);
       set(ud.pfhndl(fieldno),'String',num2str(cv));
       set(ud.pslider(fieldno),'Value',cv);
    end
    if (cv > phivalue), 
        set(ud.hihndl(fieldno),'String',num2str(cv));
        set(ud.pslider(fieldno),'Max',cv);
        ud = setphi(fieldno,intparam,ud,newx);
    end
    if (cv < plovalue), 
        set(ud.lohndl(fieldno),'String',num2str(cv));
        set(ud.pslider(fieldno),'Min',cv);
        ud = setplo(fieldno,intparam,ud,newx);
    end
    ud.distcells.parameters{popupvalue}(fieldno) = cv;
    [xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
	yvalues = getnewy(xvalues,ud);
    yvalues1 = getnewy1(xvalues,ud);
    newy = getnewy(newx,ud);
    if iscdf==0   % for pdf
        newyprob = getnewyprob(newx,ud); 
        newyprob2 = getnewyprob1(newx,ud);
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,newyprob,newyprob2,yvalues1);    
    else
        ud = updategui(ud,xvalues,yvalues,xrange,[],newx,newy,[],[],yvalues1);    
    end;else
    set(ud.pfhndl(fieldno),'String',num2str(ud.distcells.parameters{popupvalue}(fieldno)));
end

function h = gcba

  h = get(gcbf,'CurrentAxes');

% Callback for pressing fix p(type I error) button
function ud = fixalpha(ud)

if strcmp(get(ud.fix_button,'String'),'Change alpha')
    
    alphafixvalue=str2num(get(ud.yfield1,'String'));
    if alphafixvalue<0.01
        alphafixvalue=round(alphafixvalue*1000)/1000;
    elseif alphafixvalue<0.1
        alphafixvalue=round(alphafixvalue*100)/100;
    elseif alphafixvalue<1
        alphafixvalue=round(alphafixvalue*10)/10;
    end;
    set(ud.fix_button,'String','Fix alpha');
    iscdf = 2 - get(ud.functionpopup,'Value');
	popupvalue = 1;%get(ud.popup,'Value');
	[xrange, xvalues] = getxdata(iscdf,popupvalue,ud);
	for idx = 1:4
        pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
	end
    if pval(1)>pval(2)
        newx = norminv(alphafixvalue, pval(1),sqrt(pval(3)/pval(4)));
	else
        newx = norminv(1-alphafixvalue,pval(1),sqrt(pval(3)/pval(4)));
	end;
    newy = getnewy(newx,ud);
    newyprob = getnewyprob(newx,ud); 
	newyprob2 = getnewyprob1(newx,ud);
    ud = updategui(ud,xvalues,[],xrange,[],newx,newy,newyprob,newyprob2,[]);    
else
    set(ud.fix_button,'String','Change alpha');
end;
        