%Chenxinfeng, Huazhong University of Science and Technology
%2016-1-12
classdef dragRect < handle & hgsetget
	events
       evnt_StartDarg;
       evnt_Darging;
       evnt_EndDarg;
	   
    end
	properties (SetAccess = protected,Hidden)
        lh_Start; %对应event
        lh_Draging;
        lh_End;
        
        lh_reFreshLim
        lh_innerPropSet
    end
	properties(SetAccess=private) 
		%5个handle对象
		hdragLines2x%1_by_2
		hdragLines2y
		hpatch
		%模式
		model %='xx' | 'yy' |'xxyy'
	end
	properties(Dependent = true)
		xPoints %=[min_x, max_x]
		yPoints %=[min_y, max_y]
		xyPoints %=[min_x, max_x,min_y,max_y]
	end
	properties(SetObservable=true) %对象固有属性
		color = 'r'; %line & patch
		facealpha = 0.2; %patch
        visible = 'on'; %line & patch
        linewidth = 2; %line
	end
	properties %用户定义的callback
		StartDragCallback;    
        DragingCallback;
        EndDragCallback;
	end
	methods %public
		function hobj = dragRect(model,xyPoints)
			if ~exist('model','var');model='xxyy';end
			model =lower(model);
            hobj.model = model;
			if ~(strcmp(model,'xx')||strcmp(model,'yy')||strcmp(model,'xxyy'))
				error('model取值错误');
			end
			if exist('xyPoints','var')
                pos = xyPoints;
                x1pos = pos(1);
                x2pos = pos(2);
                y1pos = pos(3);
                y2pos = pos(4);
            else
                pos = axis;
                x1pos = pos(1)+.25*(pos(2)-pos(1)); %x轴1/4分点
                x2pos = pos(1)+.75*(pos(2)-pos(1));
                y1pos = pos(3)+.25*(pos(4)-pos(3));
                y2pos = pos(3)+.75*(pos(4)-pos(3)); %y轴3/4分点     
            end
            
            % patch 元素放底层
            hobj.hpatch=patch([x1pos x2pos x2pos x1pos],[y1pos y1pos y2pos y2pos],... %'r'无意义 
					'r','LineStyle','none',...
					'facecolor',hobj.color,...
					'FaceAlpha',hobj.facealpha);
            % line 元素放高层
			hobj.hdragLines2x=[dragLine('x',x1pos),dragLine('x',x2pos)];
			hobj.hdragLines2y=[dragLine('y',y1pos),dragLine('y',y2pos)];			
			switch model
				case 'xx'
					set(hobj.hdragLines2y,'visible','off');
 				case 'yy'
					set(hobj.hdragLines2x,'visible','off');
			end
			
					
			% 设置相应drag
			set([hobj.hdragLines2x,hobj.hdragLines2y],'StartDragCallback',@hobj.FcnStartDrag);
			set([hobj.hdragLines2x,hobj.hdragLines2y],'DragingCallback',@hobj.FcnDraging);
			set([hobj.hdragLines2x,hobj.hdragLines2y],'EndDragCallback',@hobj.FcnEndDrag);
			
			%设置监听固有属性变化
			addlistener(hobj,'color','PostSet',@hobj.SetInnerProp);
			addlistener(hobj,'facealpha','PostSet',@hobj.SetInnerProp);			
			addlistener(hobj,'visible','PostSet',@hobj.SetInnerProp);	
            addlistener(hobj,'linewidth','PostSet',@hobj.SetInnerProp);
            
            %set this lines+patch all chang when axis-range chang.
            %axis([xlim ylim]); %have done when--dragLine
            hobj.lh_reFreshLim=addlistener(gca,'MarkedClean',@hobj.reFreshLim);
            notify(gca,'MarkedClean');
        end
            
		function delete(hobj)
			delete(hobj.hdragLines2x);%delete paint objs
			delete(hobj.hdragLines2y);
            delete(hobj.hpatch);
            delete(hobj.lh_reFreshLim);%delete listen objs
            delete(hobj.lh_Start); 
            delete(hobj.lh_Draging);
            delete(hobj.lh_End);
		end
		
		function set.xPoints(hobj,xlims)
			xlims=sort(xlims); %2nums 最好先排序
			set(hobj.hdragLines2x(1),'point',xlims(1));
			set(hobj.hdragLines2x(2),'point',xlims(2));
			set(hobj.hpatch,'xdata',xlims([1 2 2 1]));
            notify(gca,'MarkedClean');
		end
		
		function set.yPoints(hobj,ylims)
			ylims=sort(ylims); %2nums 最好先排序
			set(hobj.hdragLines2y(1),'point',ylims(1));
			set(hobj.hdragLines2y(2),'point',ylims(2));
			set(hobj.hpatch,'ydata',ylims([1 1 2 2]));
            notify(gca,'MarkedClean');
		end
		
		function set.xyPoints(hobj,xylims)
			hobj.xPoints=xylims(1:2);
			hobj.yPoints=xylims(3:4);
		end
		
		function xlims=get.xPoints(hobj)
			xlims(2)=get(hobj.hdragLines2x(1),'point');
			xlims(1)=get(hobj.hdragLines2x(2),'point');		
			xlims=sort(xlims);%1_by_2
		end
		
		function ylims=get.yPoints(hobj)
			ylims(2)=get(hobj.hdragLines2y(1),'point');
			ylims(1)=get(hobj.hdragLines2y(2),'point');		
			ylims=sort(ylims);
		end
		
		function xylims=get.xyPoints(hobj)
			xlims = hobj.xPoints;
			ylims = hobj.yPoints;
			xylims = [xlims ylims];%1_by_4
		end		
		
		function set.StartDragCallback(hobj,hfcn)
           delete(hobj.lh_Start);
           if isempty(hfcn);hfcn=@(x,y)[];end;
           hobj.StartDragCallback = hfcn;
           hobj.lh_Start = addlistener(hobj,'evnt_StartDarg',hfcn);
        end
		
        function set.DragingCallback(hobj,hfcn)
           delete(hobj.lh_Draging);
           if isempty(hfcn);hfcn=@(x,y)[];end;
           hobj.DragingCallback = hfcn;
           hobj.lh_Draging = addlistener(hobj,'evnt_Darging',hfcn);
        end
        function set.EndDragCallback(hobj,hfcn)
           delete(hobj.lh_End);
           if isempty(hfcn);hfcn=@(x,y)[];end;
           hobj.EndDragCallback = hfcn;
           hobj.lh_End = addlistener(hobj,'evnt_EndDarg',hfcn);
        end
	end
	
	%% 相应线条的drag
	methods (Access = private) %私有,drag线条（自身），广播 drag事件
        function FcnStartDrag(hobj,varargin)
            %广播，运行用户自定义的StartDragCallback
            notify(hobj,'evnt_StartDarg');
        end
        function FcnDraging(hobj,varargin)
%             pt = get(gca,'CurrentPoint');
%             xpoint = pt(1,1);
%             ypoint = pt(1,2);
			%更改patch
            lineobj = gco;
			switch lineobj
				case {hobj.hdragLines2x(1).hline,hobj.hdragLines2x(2).hline}
					pos1=hobj.hdragLines2x(1).point;
					pos2=hobj.hdragLines2x(2).point;
					set(hobj.hpatch,'xdata',[pos1,pos2,pos2,pos1]);
				case {hobj.hdragLines2y(1).hline,hobj.hdragLines2y(2).hline}
					pos1=hobj.hdragLines2y(1).point;
					pos2=hobj.hdragLines2y(2).point;
					set(hobj.hpatch,'ydata',[pos1,pos1,pos2,pos2]);
				otherwise
					disp('错误1')
			end			
			
            %广播，运行用户自定义的DragingCallback
            notify(hobj,'evnt_Darging');
        end
        function FcnEndDrag(hobj,varargin)			
            %广播，运行用户自定义的EndDragCallback
            notify(hobj,'evnt_EndDarg');
        end
		
		function SetInnerProp(hobj,varargin)
			set([hobj.hdragLines2x,hobj.hdragLines2y],'color',hobj.color);
			set(hobj.hpatch,'facecolor',hobj.color);
			set(hobj.hpatch,'facealpha',hobj.facealpha);
            set([hobj.hdragLines2x,hobj.hdragLines2y],'linewidth',hobj.linewidth);
            % set 'visible'
            set(hobj.hpatch,'visible',hobj.visible); %patch obj
            if strcmpi(hobj.visible,'on')
               switch hobj.model
                   case 'xx'
                       set([hobj.hdragLines2x],'visible','on');
                   case 'yy'
                       set([hobj.hdragLines2y],'visible','on');
                   case 'xxyy'
                       set([hobj.hdragLines2x,hobj.hdragLines2y],'visible','on');
               end
            elseif strcmpi(hobj.visible,'off')
                set([hobj.hdragLines2x,hobj.hdragLines2y],'visible','off');
            else
                error('''visible''should be ''on'' or ''off''');
            end
            
        end
        
        %无限远系统        
        function reFreshLim(hobj,varargin)
            switch hobj.model
                case 'xx'
                    hobj.yPoints = ylim;
                case 'yy'
                    hobj.xPoints = xlim;
            end
        end
    end
	
end