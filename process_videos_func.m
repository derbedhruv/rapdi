function process_videos_func(obj, event, himage)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    global record;
    
    threshold_dark = 0.8;
    threshold_bright = 0.87;

    % you can get the time-stamp string associated with this image from:
    tstampstr = event.Timestamp;

    % you get the image in this function from:
    im = event.Data;
    im = process_pupil(im, 1, 180,threshold_dark, threshold_bright);
    
    if (record == 1)
        % send ON command to arduino
        % create video object and start recording
    else
        % send OFF command to arduino
        % terminate videoObj
    end

    % you actively need to display the image in this function
    set(himage, 'CData', im, 'EraseMode', 'none');

