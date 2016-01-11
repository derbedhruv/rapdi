%% TODO: First detect the small LEDs and fill them in dark.
% THen detect the entire dark pupil.

% the only variable you need to change
threshold_dark = 0.8;
threshold_bright = 0.87;

disp('reading video..');
vd = VideoReader('E:\RAPDeye\RAPD detected\Abdul_rehman_48_male_right.avi');
frames = vd.NumberOfFrames;
frame_rate = vd.FrameRate;
video = vd.read();
% output_file = VideoWriter('Trackedpupil.mp4','MPEG-4'); % create a video-writer object to store the output 
% output_file.FrameRate = frame_rate;  %specify the frame rate
% open (output_file);

disp('please select the center of the pupil in the first frame');
% figure; imshow(50*video(:,:,:,1));
% [x,y] = ginput(1);

bright = 10;
square_side = 180;
figure; hold on

disp('thank you, now processing frames..');
for f = 1:frames  
    % disp(f);
    
    Im = bright*video(:,:,:,f);    %read frame  
    agray = rgb2gray(Im);      %rgb2gray
    agray = agray(size(agray, 1)/2 - square_side:size(agray, 1)/2 + square_side , size(agray, 2)/2 - square_side:size(agray, 2)/2 + square_side  );
    agray1 = imcomplement(agray);
    agray2 = medfilt2(agray1);        %filtered and negative of image

    % threshold based on the brightness or darkness
    if (mean(agray2(:)) < 170)
        z1 = im2bw(agray2, threshold_dark);
    else
        z1 = im2bw(agray2, threshold_bright);
    end

    se = strel('disk', 1, 4);
    z2 = imdilate(z1,se);
    
    cc = bwconncomp(z2);
    numPixels = cellfun(@numel,cc.PixelIdxList);
    [biggest,idx] = max(numPixels);
    BW2 = ismember(labelmatrix(cc), idx);   %largest connected component
    BW3 = imfill(BW2,'holes');
    cc1 = bwconncomp(BW3);
    
    cnt1 = edge(BW3);
    % cnt2 = imdilate(cnt1,se2);
    
    Im(size(Im, 1)/2 - square_side:size(Im, 1)/2 + square_side , size(Im, 2)/2 - square_side:size(Im, 2)/2 + square_side  ,2) = Im(size(Im, 1)/2 - square_side:size(Im, 1)/2 + square_side , size(Im, 2)/2 - square_side:size(Im, 2)/2 + square_side  ,2) + 255*cast(cnt1, 'uint8');
    
    %{
    plot(f, mean(agray2(:)));
    drawnow
    %}
    
    imshow(Im);
end

% xlswrite('RecordedArea.xlsx',Area);   %Record the area variations in a excel file for future use.

% implay('TrackedPupil.mp4');
% plot(Area);
