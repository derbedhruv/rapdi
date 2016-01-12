% Testing using webcam object to acquire the objects
% First we clear up the previous objects
try
    stop(w1);     % stop previously opened instances of w1, if open
    stop(w2);
    disp('stopped previously opened instances of the webcam objects');
end

clear('w1'); clear('w2');

% setup webcams using the object that was made using the image acquisition
% toolbox. We will set trigger to manual so that we can call frames as they
% are taken. http://in.mathworks.com/matlabcentral/newsreader/view_thread/129705
w1 = webcam1;
triggerconfig(w1, 'manual');
start(w1);

w2 = webcam2;
triggerconfig(w2, 'manual');
start(w2);

figure;

while(1)
   % loop to collect images, process them and then display them 
   im1 = process_pupil(getsnapshot(w1), 1, 180,threshold_dark, threshold_bright);
   im2 = process_pupil(getsnapshot(w2), 1, 180,threshold_dark, threshold_bright);
      
   imshow([im1, im2]);
end

% close the connection to the object
stop('w1');