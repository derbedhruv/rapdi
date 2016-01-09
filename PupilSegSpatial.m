% the only variable you need to change
threshold = 0.85;
vd = VideoReader('E:\RAPDeye\RAPD detected\Abdul_rehman_48_male_left.avi');
frames = vd.NumberOfFrames;
frame_rate = vd.FrameRate;
video = vd.read();
% output_file = VideoWriter('Trackedpupil.mp4','MPEG-4'); % create a video-writer object to store the output 
% output_file.FrameRate = frame_rate;  %specify the frame rate
% open (output_file);

figure;

for f = 1:frames  
    disp(f);
    
    Im = video(:,:,:,f);    %read frame  
    agray = 10*rgb2gray(Im);      %rgb2gray
    agray1 = imcomplement(agray);
    agray2 = medfilt2(agray1);        %filtered and negative of image

    z1 = im2bw(agray2, threshold);

    se = strel('disk', 1, 4);
    z2 = imdilate(z1,se);
    cc = bwconncomp(z2);
    numPixels = cellfun(@numel,cc.PixelIdxList);
    [biggest,idx] = max(numPixels);
    BW2 = ismember(labelmatrix(cc), idx);   %largest connected component
    BW3 = imfill(BW2,'holes');
    cc1 = bwconncomp(BW3);
    
    frame = zeros([size(Im) 3]);
    
    % What is this and what is it used for?
    % numPixels = cellfun(@numel,cc1.PixelIdxList);
    % stats = regionprops(cc1, 'All');
    
    cnt1 = edge(BW3);
    % cnt2 = imdilate(cnt1,se2);
    
    Im(:,:,2) = Im(:,:,2) + 255*cast(cnt1, 'uint8');
    
    imshow(Im);
    % writeVideo(output_file,a4);
    Area(f) = stats.Area;
end

xlswrite('RecordedArea.xlsx',Area);   %Record the area variations in a excel file for future use.

% implay('TrackedPupil.mp4');
% plot(Area);
