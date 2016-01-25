% Testing using webcam object to acquire the objects
% First we clear up the previous objects
addpath('./');

try
    stop(w1);     % stop previously opened instances of w1, if open
    stop(w2);
    disp('stopped previously opened instances of the webcam objects');
end

clear('w1'); clear('w2');

%% global variables
threshold_dark = 0.8;
threshold_bright = 0.87;

% setup webcams using the object that was made using the image acquisition
% toolbox. We will set trigger to manual so that we can call frames as they
% are taken. http://in.mathworks.com/matlabcentral/newsreader/view_thread/129705
w1 = webcam1;
triggerconfig(w1, 'manual');
start(w1);

w2 = webcam2;
start(w2);


% We prepare the GUI
f = figure('Name', 'RAPDeye v3.0.1', 'units','normalized','outerposition',[0 0 1 1]);   % The second part makes it automatically fullscreen http://stackoverflow.com/questions/15286458/automatically-maximize-figure-in-matlab
title('Test');
title('Please click on the pupils in the figure');
uiclose = uicontrol('String', 'Close', 'Callback', 'close(gcf)');
vidRes = w1.VideoResolution;    % assume w1 and w2 same which we know
nBands = w1.NumberOfBands;
hImage1 = zeros(vidRes(2), vidRes(1), nBands);  % prepare background hImage for preview see http://www.mathworks.com/help/imaq/preview.html
hImage2 = hImage1;


%% We show a live preview of both images in the feed, and we ask the user to choose where the pupil is located
subplot(1,2,1); h1 = subimage(hImage1);     % h1 and h2 are the handles to the subimages 
subplot(1,2,2); h2 = subimage(hImage2);

preview(w1, h1); preview(w2, h2);           % display the images as subplots

ginput(2);

stop(w1); stop(w2);
close all;

% figure;     % open new figure
% reset cameras, this is not a good way of doing this
w1 = webcam1;
triggerconfig(w1, 'manual');
start(w1);

w2 = webcam2;
triggerconfig(w2, 'manual');
start(w2);

while(1)
   % loop to collect images, process them and then display them 
   im1 = process_pupil(getsnapshot(w1), 1, 100,threshold_dark, threshold_bright);
   im2 = process_pupil(getsnapshot(w2), 1, 100,threshold_dark, threshold_bright);
      
   imshow([im1, im2], 'InitialMagnification', 67);
end

% close the connection to the object
stop('w1');