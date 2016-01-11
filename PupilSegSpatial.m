%% TODO: First detect the small LEDs and fill them in dark.
% THen detect the entire dark pupil.

% the only variable you need to change
threshold_dark = 0.8;
threshold_bright = 0.87;

disp('reading videos..');

vd1 = VideoReader('E:\RAPDeye\RAPD detected\Abdul_rehman_48_male_left.avi');
vd2 = VideoReader('E:\RAPDeye\RAPD detected\Abdul_rehman_48_male_right.avi');

% frame_rate = vd.FrameRate;

frames = vd1.NumberOfFrames;

video_l = vd1.read();
video_r = vd2.read();

% output_file = VideoWriter('Trackedpupil.mp4','MPEG-4'); % create a video-writer object to store the output 
% output_file.FrameRate = frame_rate;  %specify the frame rate
% open (output_file);

% disp('please select the center of the pupil in the first frame');
% figure; imshow(50*video(:,:,:,1));
% [x,y] = ginput(1);

figure; hold on

disp('thank you, now processing frames..');
for f = 1:frames  
    frame_l = video_l(:,:,:,f);
    Im_l = process_pupil(frame_l, 10, 180,threshold_dark, threshold_bright);
    
    frame_r = video_r(:,:,:,f);
    Im_r = process_pupil(frame_r, 10, 180,threshold_dark, threshold_bright);
    
    imshow([Im_r, Im_l]);
end

% xlswrite('RecordedArea.xlsx',Area);   %Record the area variations in a excel file for future use.

% implay('TrackedPupil.mp4');
% plot(Area);
