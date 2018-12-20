function varargout = stp_gui(varargin)
% STP_GUI MATLAB code for stp_gui.fig
%      STP_GUI, by itself, creates a new STP_GUI or raises the existing
%      singleton*.
%
%      H = STP_GUI returns the handle to a new STP_GUI or the handle to
%      the existing singleton*.
%
%      STP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STP_GUI.M with the given input arguments.
%
%      STP_GUI('Property','Value',...) creates a new STP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stp_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stp_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stp_gui

% Last Modified by GUIDE v2.5 15-Jan-2018 10:09:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stp_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stp_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function spikeTimes = stp_gui_SetSpikeTimes(type)
    switch type
        case 'set times'
            % set times
            spikeTimes = [50:25:150 200:50:300];

        case 'regular-10 Hz'
            % regular firing
            fr = 10;
            init_spiketime = 100;
            fs = 1000;
            n_spikes = 8;
            spikeTimes = round(linspace(init_spiketime, ...
                    init_spiketime + (n_spikes - 1) * fs / fr, ...
                    n_spikes)); 
        case 'regular-20 Hz'
            % regular firing
            fr = 20;
            init_spiketime = 100;
            fs = 1000;
            n_spikes = 8;
            spikeTimes = round(linspace(init_spiketime, ...
                    init_spiketime + (n_spikes - 1) * fs / fr, ...
                    n_spikes)); 
        case 'regular-40 Hz'
            % regular firing
            fr = 40;
            init_spiketime = 100;
            fs = 1000;
            n_spikes = 8;
            spikeTimes = round(linspace(init_spiketime, ...
                    init_spiketime + (n_spikes - 1) * fs / fr, ...
                    n_spikes)); 

        case 'poisson'
            % Poisson spikes
            fr = 8;
            t_end = 1000;
            fs = 1000;
            t = 1:t_end;

            tmp_unif = rand(1, t_end);
            spikeTimes1 = find(tmp_unif < (fr / fs));
            close_spikes = [false diff(spikeTimes1) < 10];
            spikeTimes = spikeTimes1;
            spikeTimes(close_spikes) = [];
    end


function [tDep, tFac, U, f] = stp_gui_SetSTPRegime(regime)
    switch regime
        % the below 5 are exemplary synthetic values from Costa et al. (2013)
        case 'strong depression'
            tDep = 1700; tFac = 20; U = 0.7; f = 0.05;
        case 'depression'
            tDep = 500; tFac = 50; U = 0.5; f = 0.05;
        case 'facilitation-depression'
            tDep = 200; tFac = 200; U = 0.25; f = 0.3;
        case 'facilitation'
            tDep = 50; tFac = 500; U = 0.15; f = 0.15;
        case 'strong facilitation'
            tDep = 20; tFac = 1700; U = 0.1; f = 0.11;
            
        % based on Tsodyks & Markram (1997), Markram et al. (1998), Richardson et al. (2005), Costa et al. (2013)
        % note: this data is mostly L5-L5
        case 'Pyr5-Pyr5'
            tDep = 600; tFac = 20; U = 0.5; f = 0.1;
        % based on Feldmeter et al. (2002)
        case 'Pyr4-Pyr23'
            tDep = 200; tFac = 100; U = 0.3; f = 0.1;
        % based on Beierlein et al. (2003), Silbergberg & Markram (2007)
        case 'Pyr-SST'
            tDep = 10; tFac = 1000; U = 0.05; f = 0.1;
        % based on Beierlein et al. (2003)
        case 'Pyr-PV'
            tDep = 250; tFac = 400; U = 0.4; f = 0.1;
        % based on Gupta et al. (2000), Beierlein et al. (2003)
        case 'PV-Pyr'
            tDep = 500; tFac = 10; U = 0.25; f = 0.1;
        % most conflicting results here! lots of variance
        % see Beierlein et al. (2003), Silbergberg & Markram (2007)
        case 'SST-Pyr'
            tDep = 100; tFac = 100; U = 0.25; f = 0.1;
        % based on Tan et al. (2008), Takesian et al. (2010), Takesian et al. (2013)
        case 'TC-SST'
            tDep = 100; tFac = 500; U = 0.25; f = 0.35;
        case 'TC-SST2'
            tDep = 25; tFac = 500; U = 0.2; f = 0.2;
        % based on Tan et al. (2008), Takesian et al. (2010), Takesian et al. (2013)
        case 'TC-PV'
            tDep = 400; tFac = 50; U = 0.45; f = 0.05;
        % based on Viaene et al. (2011)
        case 'TC-Pyr_L2/3_C2'
            tDep = 1000; tFac = 1000; U = 0.05; f = 0.1;
        % based on Viaene et al. (2011)
        case 'TC-Pyr_L2/3_C1'  %% work on this one
            tDep = 250; tFac = 75; U = 0.5; f = 0.1;
        % based on Viaene et al. (2011)
        case 'TC-Pyr_L4'
            tDep = 150; tFac = 20; U = 0.25; f = 0.25;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % legacy parameters below %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'PC-PC'
            tDep = 350; tFac = 350; U = 0.4; f = 0.11;
        case 'PC-BC'
            tDep = 200; tFac = 25; U = 0.45; f = 0.11;
        case 'PC-MC'
            tDep = 25; tFac = 400; U = 0.05; f = 0.11;
        case 'BC-PC'
            tDep = 100; tFac = 10; U = 0.2; f = 0.2;
        case 'MC-PC'
            tDep = 10; tFac = 100; U = 0.15; f = 0.11;
        case 'dep_strong'
            tDep = 800; tFac = 1; U = 0.5; f = 0.1;
        case 'dep'
            tDep = 400; tFac = 25; U = 0.4; f = 0.1;
        case 'dep_weak'
            tDep = 200; tFac = 50; U = 0.3; f = 0.15;
        case 'fac_dep'
            tDep = 200; tFac = 200; U = 0.25; f = 0.3;
        case 'fac_dep_weak'
            tDep = 100; tFac = 200; U = 0.2; f = 0.25;
        case 'fac_weak'
            tDep = 50; tFac = 200; U = 0.2; f = 0.2;
        case 'fac'
            tDep = 25; tFac = 400; U = 0.15; f = 0.15;
        case 'fac_strong'
            tDep = 1; tFac = 800; U = 0.1; f = 0.1;
    end

% --- Executes just before stp_gui is made visible.
function stp_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stp_gui (see VARARGIN)

init_firing = 'set times';
init_regime = 'strong depression';

% Choose default command line output for stp_gui
handles.output = hObject;

spikeTimes_init = stp_gui_SetSpikeTimes(init_firing);

[tDep_init, tFac_init, U_init, f_init] = stp_gui_SetSTPRegime(init_regime);
handles.edit1.String = num2str(tDep_init);
handles.edit2.String = num2str(tFac_init);
handles.edit3.String = num2str(U_init);
handles.edit4.String = num2str(f_init);
handles.edit5.String = num2str(spikeTimes_init);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stp_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stp_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spiketimes = str2num(handles.edit5.String);
t = 1:max(spiketimes)+100;
trec = str2num(handles.edit1.String);
tfac = str2num(handles.edit2.String);
U = str2num(handles.edit3.String);
f = str2num(handles.edit4.String);
in = 0;

IAF_STP_analytical2_gui_ms(t, spiketimes, trec, tfac, U, f, in)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

contents = cellstr(get(hObject,'String'));
selected_regime = contents{get(hObject,'Value')};

[tDep, tFac, U, f] = stp_gui_SetSTPRegime(selected_regime);
handles.edit1.String = num2str(tDep);
handles.edit2.String = num2str(tFac);
handles.edit3.String = num2str(U);
handles.edit4.String = num2str(f);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
contents = cellstr(get(hObject,'String'));
selected_type = contents{get(hObject,'Value')};

spikeTimes = stp_gui_SetSpikeTimes(selected_type);
handles.edit5.String = num2str(spikeTimes);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
