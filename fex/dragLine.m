%Chenxinfeng, Huazhong University of Science and Technology
%2016-1-12
classdef dragLine < handle & hgsetget
    properties (SetAccess = protected,Hidden)
        lh_Start; %对应event
        lh_Draging;
        lh_End;
        lh_reFreshLim;
    end
    properties (SetAccess = protected)
        model; %'x'或'y'
        hline; %直线的对象
    end
    properties (SetObservable=true) %对象固有属性
        color='r';
        linewidth = 2;
		visible = 'on';	
	end
	properties
        point; %直线的最重要属性
        
        %用户自定义 回调函数
        %句柄，如@ll1   function ll1(hobj,evnt); 限定有且只有2个参数
        %参数1=目前 dragLine_hobj, 
        %参数2=EventData对象<.Source == 参数1; EventName='evnt_Darging'>
        StartDragCallback;    
        DragingCallback;
        EndDragCallback;
    end
    properties (Access = private)
       saveWindowFcn;
       dargPointer;
    end
    events
       evnt_StartDarg;
       evnt_Darging;
       evnt_EndDarg;
    end
    
    
    methods %公有
        function hobj= dragLine(model,point)
           if ~exist('model','var');model='x';end
           model = lower(model);
           if ~strcmp(model,'x')
               if ~strcmp(model,'y'); error('model取''x''或''y''');end;
           end
           hobj.model = lower(model);
           
           %制作 line
           xylim = axis;
           if hobj.model == 'x'
               if ~exist('point','var');point=mean(xlim);end
               xdata = point*[1 1];
               ydata = xylim(3:4);
               hobj.dargPointer='left'; %drag时的箭头
           else
               if ~exist('point','var');point=mean(ylim);end
               xdata = xylim(1:2);
               ydata = point*[1 1];
               hobj.dargPointer='top';
           end
           hobj.point = point;
           hobj.hline = plot(xdata,ydata,...
               'color',hobj.color,...
               'linewidth',hobj.linewidth);
           set(hobj.hline,'ButtonDownFcn',@hobj.FcnStartDrag)
		   
		   %设置监听固有属性变化
			addlistener(hobj,'color','PostSet',@hobj.SetInnerProp);
			addlistener(hobj,'linewidth','PostSet',@hobj.SetInnerProp);
			addlistener(hobj,'visible','PostSet',@hobj.SetInnerProp);
            %set this line chang when axis-range chang.
            axis([xlim ylim]); %must a fix axis
            if hobj.model == 'x'
				hobj.lh_reFreshLim=addlistener(gca,'MarkedClean',@(x,y)set(hobj.hline,'ydata',ylim) );
			else
				hobj.lh_reFreshLim=addlistener(gca,'MarkedClean',@(x,y)set(hobj.hline,'xdata',xlim) );
			end
        end
        
        function set.point(hobj,point)  
            hobj.point = point;
            if ~ishandle(hobj.hline); return;end; %可能线条没建立
            switch hobj.model
                case 'x'
                    %移动线条
                     set(hobj.hline,'xdata',point*[1 1]);
                case 'y'
                     set(hobj.hline,'ydata',point*[1 1]);
            end
        end
        
        %定义听众lh, 当设置用户自定义的callback
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
        function delete(hobj)
            %用clear dl1 无法清除该图形，只能用delete.
           delete(hobj.hline); 
           disp('删除线')
           delete(hobj.lh_reFreshLim);
        end
        
    end
    
    methods (Access = private) %私有,drag线条（自身），广播 drag事件
        function FcnStartDrag(hobj,varargin)
            %更改箭头，保存windowfcn
            set(gcf,'pointer',hobj.dargPointer);
            hobj.saveWindowFcn.Motion = get(gcf,'WindowButtonMotionFcn');
            hobj.saveWindowFcn.Up = get(gcf,'WindowButtonUpFcn');
            set(gcf,'WindowButtonMotionFcn',@hobj.FcnDraging);
            set(gcf,'WindowButtonUpFcn',@hobj.FcnEndDrag);
            %广播，运行用户自定义的StartDragCallback
            notify(hobj,'evnt_StartDarg');
        end
        function FcnDraging(hobj,varargin)
            pt = get(gca,'CurrentPoint');
            xpoint = pt(1,1);
            ypoint = pt(1,2);
            switch hobj.model
                case 'x'
                    hobj.point = xpoint; %set 属性触发 line的图像修改
%                     set(hobj.hline,'xdata',xpoint*[1 1]);
                case 'y'
                    hobj.point = ypoint;
%                     set(hobj.hline,'ydata',ypoint*[1 1]);
            end
            %广播，运行用户自定义的DragingCallback
            notify(hobj,'evnt_Darging');
        end
        function FcnEndDrag(hobj,varargin)
            %还原箭头，和windowfcn
            set(gcf,'pointer','arrow');
            set(gcf,'WindowButtonMotionFcn',hobj.saveWindowFcn.Motion);
            set(gcf,'WindowButtonUpFcn',hobj.saveWindowFcn.Up);
            %广播，运行用户自定义的EndDragCallback
            notify(hobj,'evnt_EndDarg');
        end
		function SetInnerProp(hobj,varargin)
			set(hobj.hline,'color',hobj.color);
			set(hobj.hline,'linewidth',hobj.linewidth);
			set(hobj.hline,'visible',hobj.visible);
		end
    end
end
