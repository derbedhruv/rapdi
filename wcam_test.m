%% global variables - these aren't really being used now
threshold_dark = 0.8;
threshold_bright = 0.87;

% setup webcams using the object that was made using the image acquisition
% toolbox. We will set trigger to manual so that we can call frames as they
% are taken. http://in.mathworks.com/matlabcentral/newsreader/view_thread/129705

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