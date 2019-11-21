%Chenxinfeng, Huazhong University of Science and Technology
%2016-1-12
classdef dragLine < handle & hgsetget
    properties (SetAccess = protected,Hidden)
        lh_Start; %��Ӧevent
        lh_Draging;
        lh_End;
        lh_reFreshLim;
    end
    properties (SetAccess = protected)
        model; %'x'��'y'
        hline; %ֱ�ߵĶ���
    end
    properties (SetObservable=true) %�����������
        color='r';
        linewidth = 2;
		visible = 'on';	
	end
	properties
        point; %ֱ�ߵ�����Ҫ����
        
        %�û��Զ��� �ص�����
        %�������@ll1   function ll1(hobj,evnt); �޶�����ֻ��2������
        %����1=Ŀǰ dragLine_hobj, 
        %����2=EventData����<.Source == ����1; EventName='evnt_Darging'>
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
    
    
    methods %����
        function hobj= dragLine(model,point)
           if ~exist('model','var');model='x';end
           model = lower(model);
           if ~strcmp(model,'x')
               if ~strcmp(model,'y'); error('modelȡ''x''��''y''');end;
           end
           hobj.model = lower(model);
           
           %���� line
           xylim = axis;
           if hobj.model == 'x'
               if ~exist('point','var');point=mean(xlim);end
               xdata = point*[1 1];
               ydata = xylim(3:4);
               hobj.dargPointer='left'; %dragʱ�ļ�ͷ
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
		   
		   %���ü����������Ա仯
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
            if ~ishandle(hobj.hline); return;end; %��������û����
            switch hobj.model
                case 'x'
                    %�ƶ�����
                     set(hobj.hline,'xdata',point*[1 1]);
                case 'y'
                     set(hobj.hline,'ydata',point*[1 1]);
            end
        end
        
        %��������lh, �������û��Զ����callback
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
            %��clear dl1 �޷������ͼ�Σ�ֻ����delete.
           delete(hobj.hline); 
           disp('ɾ����')
           delete(hobj.lh_reFreshLim);
        end
        
    end
    
    methods (Access = private) %˽��,drag�������������㲥 drag�¼�
        function FcnStartDrag(hobj,varargin)
            %���ļ�ͷ������windowfcn
            set(gcf,'pointer',hobj.dargPointer);
            hobj.saveWindowFcn.Motion = get(gcf,'WindowButtonMotionFcn');
            hobj.saveWindowFcn.Up = get(gcf,'WindowButtonUpFcn');
            set(gcf,'WindowButtonMotionFcn',@hobj.FcnDraging);
            set(gcf,'WindowButtonUpFcn',@hobj.FcnEndDrag);
            %�㲥�������û��Զ����StartDragCallback
            notify(hobj,'evnt_StartDarg');
        end
        function FcnDraging(hobj,varargin)
            pt = get(gca,'CurrentPoint');
            xpoint = pt(1,1);
            ypoint = pt(1,2);
            switch hobj.model
                case 'x'
                    hobj.point = xpoint; %set ���Դ��� line��ͼ���޸�
%                     set(hobj.hline,'xdata',xpoint*[1 1]);
                case 'y'
                    hobj.point = ypoint;
%                     set(hobj.hline,'ydata',ypoint*[1 1]);
            end
            %�㲥�������û��Զ����DragingCallback
            notify(hobj,'evnt_Darging');
        end
        function FcnEndDrag(hobj,varargin)
            %��ԭ��ͷ����windowfcn
            set(gcf,'pointer','arrow');
            set(gcf,'WindowButtonMotionFcn',hobj.saveWindowFcn.Motion);
            set(gcf,'WindowButtonUpFcn',hobj.saveWindowFcn.Up);
            %�㲥�������û��Զ����EndDragCallback
            notify(hobj,'evnt_EndDarg');
        end
		function SetInnerProp(hobj,varargin)
			set(hobj.hline,'color',hobj.color);
			set(hobj.hline,'linewidth',hobj.linewidth);
			set(hobj.hline,'visible',hobj.visible);
		end
    end
end
