function varargout = Reversible_Data_Hiding(varargin)
% REVERSIBLE_DATA_HIDING M-file for Reversible_Data_Hiding.fig
%      REVERSIBLE_DATA_HIDING, by itself, creates a new REVERSIBLE_DATA_HIDING or raises the existing
%      singleton*.
%
%      H = REVERSIBLE_DATA_HIDING returns the handle to a new REVERSIBLE_DATA_HIDING or the handle to
%      the existing singleton*.
%
%      REVERSIBLE_DATA_HIDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVERSIBLE_DATA_HIDING.M with the given input arguments.
%
%      REVERSIBLE_DATA_HIDING('Property','Value',...) creates a new REVERSIBLE_DATA_HIDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reversible_Data_Hiding_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reversible_Data_Hiding_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reversible_Data_Hiding

% Last Modified by GUIDE v2.5 23-Dec-2014 10:20:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reversible_Data_Hiding_OpeningFcn, ...
                   'gui_OutputFcn',  @Reversible_Data_Hiding_OutputFcn, ...
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


% --- Executes just before Reversible_Data_Hiding is made visible.
function Reversible_Data_Hiding_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reversible_Data_Hiding (see VARARGIN)

% Choose default command line output for Reversible_Data_Hiding
handles.output = hObject;

set(handles.ReqImgPath,'String','Select the required Image');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reversible_Data_Hiding wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Reversible_Data_Hiding_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectImg.
function SelectImg_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.pgm','Select the required image(*.pgm) file');
set(handles.ReqImgPath,'String',[PathName FileName]);

% --- Executes on button press in startprocess.
function startprocess_Callback(hObject, eventdata, handles)
% hObject    handle to startprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FullFilePath = get(handles.ReqImgPath,'String');
I = double(imread(FullFilePath));
StartProcessSeq(I);


% --- Executes on button press in previmage.
function previmage_Callback(hObject, eventdata, handles)
% hObject    handle to previmage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FullFilePath = get(handles.ReqImgPath,'String');
if strcmp(FullFilePath,'Select the required Image');
    msgbox('Select the appropriate image');
    return;
end
I = double(imread(FullFilePath));
figure,imshow(I/255),title('Original image');
