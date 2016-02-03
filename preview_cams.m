% Show the preview of the cameras in a custom GUI
% Also save the timestamps of both.
% Also save the live video stream at the end
% If this is possible, then the whole thing should happen this way
global record;
record = 0;     % false

if (~exist('w1'))
    w1 = webcam1;
    triggerconfig(w1, 'manual');
    start(w1);
end

if (~exist('w2'))
    w2 = webcam2;
    triggerconfig(w2, 'manual');
    start(w2);
end

vidRes = w1.VideoResolution;    % assume w1 and w2 same which we know
nBands = w1.NumberOfBands;

hImage1 = zeros(vidRes(2), vidRes(1), nBands);
hImage2 = hImage1;

f = figure;
subplot(1,2,1); h1 = subimage(hImage1);     % h1 and h2 are the handles to the subimages 
subplot(1,2,2); h2 = subimage(hImage2);

gui_handle = guidata(f);
setappdata(h2, 'UpdatePreviewWindowFcn', @process_videos_func);

preview(w1, h2); preview(w2, h1);           % display the images as subplots
% start_button = uicontrol(f,'Style','pushbutton','String','START', 'Position',[50 20 60 40], 'Callback', @(hObject, callbackdata)setappdata(h1, 'UpdatePreviewWindowFcn', @process_videos_func));  % using anonymous function like a boss
% stop_button = uicontrol(f,'Style','pushbutton','String','STOP', 'Position',[200 20 60 40], 'Callback', @(hObject, callbackdata)setappdata(h1, 'UpdatePreviewWindowFcn', []));

start_button = uicontrol(f,'Style','pushbutton','String','START', 'Position',[50 20 60 40], 'Callback', {@do_record, '1'});
stop_button = uicontrol(f,'Style','pushbutton','String','STOP', 'Position',[200 20 60 40], 'Callback', {@do_record, '0'});