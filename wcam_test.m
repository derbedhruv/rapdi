%% close previous shit
try
   fclose(arduino);
   stop(w1);  stop(w2);
   s = instrfind; fclose(s);    % close prevoiusly opened serial oibjects
   close(v);
   % clear all;
end

%% Establish connection to the arduino
ports = instrhwinfo('serial');
ports_list = ports.AvailableSerialPorts;
arduino_port = ports_list(2);    % TODO: establish comm to prove it is the arduino
arduino = serial(arduino_port{1});  % establish comm.
set(arduino,'BaudRate',9600);
fopen(arduino);

%% global variables - these aren't really being used now
threshold_dark = 0.8;
threshold_bright = 0.87;

% h = rapdi_gui;
% uiwait(h); 

% setup webcams using the object that was made using the image acquisition
% toolbox. We will set trigger to manual so that we can call frames as they
% are taken. http://in.mathworks.com/matlabcentral/newsreader/view_thread/129705

w1 = webcam1;
triggerconfig(w1, 'manual');
start(w1);

w2 = webcam2;
triggerconfig(w2, 'manual');
start(w2);

video_filename = strcat(first_name, '_',last_name, '_', age, '_', rapd_notes, '.avi');
v = VideoWriter(video_filename);
v.FrameRate = 30;
v.Quality = 100;
open(v);

for i = 1:650
    if (i == 50)
        %% Send the ON signal to the arduino
        fprintf(arduino, 's');
        fclose(arduino);
    end
    
   % loop to collect images, process them and then display them 
   im1 = getsnapshot(w1);
   im2 = getsnapshot(w2);
   
   imm = horzcat(im1, im2);
   writeVideo(v, imm);
   
   % im1 = process_pupil(im1, 1, 100,threshold_dark, threshold_bright);
   % im2 = process_pupil(im2, 1, 100,threshold_dark, threshold_bright);
      
   imshow(imm);
end

close all;  % close the window that's open

% close the connection to the object
stop(w1); stop(w2); close(v);