a = imaqhwinfo;
[camera_name, camera_id, format] = getCameraInfo(a);
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = videoinput(camera_name, camera_id, format);
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;
%start the video aquisition here
start(vid)
% Set a loop that stop after 500 frames of aquisition
while(vid.FramesAcquired<=500)
    
    % Get the snapshot of the current frame
     % Get snapshot of current frame
    snap = getsnapshot(vid);
    % Extract red by subtracting red from grayscale
    snap_red = imsubtract(snap(:,:,1), rgb2gray(snap));
    snap_blue = imsubtract(snap(:,:,3), rgb2gray(snap));
    snap_green = imsubtract(snap(:,:,2), rgb2gray(snap));
    % Filter out noise
    snap_red = medfilt2(snap_red, [3 3]);
    snap_blue = medfilt2(snap_blue, [3 3]);
    snap_green = medfilt2(snap_green, [3 3]);
    % Convert new snapshot to binary
    snap_red = im2bw(snap_red,0.18);
    snap_blue = im2bw(snap_blue,0.18);
    snap_green = im2bw(snap_green,0.18);
    % Remove pixles less than 300px
    snap_red = bwlabel(snap_red, 8);
    snap_blue = bwlabel(snap_blue, 8);
    snap_green = bwlabel(snap_green, 8);
    % Label all connected components
    bw_red = bwlabel(snap_red,8);
    bw_blue = bwlabel(snap_blue,8);
    bw_green = bwlabel(snap_green,8);
    % Properties for each labeled region
    stats_red = regionprops(bw_red, 'BoundingBox','Centroid');
    stats_blue = regionprops(bw_blue, 'BoundingBox','Centroid');
    stats_green = regionprops(bw_green, 'BoundingBox','Centroid');
    % Display new image
 
  
   % drawnow
imshow(snap_red+snap_green+snap_blue)
%imshow(snap_green)  
%imshow(snap_blue)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats_red)
        bb = stats_red(object).BoundingBox;
        bc = stats_red(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
     %This is a loop to bound the green objects in a rectangular box.
    for object = 1:length(stats_green)
        bb = stats_green(object).BoundingBox;
        bc = stats_green(object).Centroid;
        rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
     %This is a loop to bound the blue objects in a rectangular box.
    for object = 1:length(stats_blue)
        bb = stats_blue(object).BoundingBox;
        bc = stats_blue(object).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
end
% Both the loops end here.
% Stop the video aquisition.
stop(vid);
% Flush all the image data stored in the memory buffer.
flushdata(vid);
% Clear all variables
clear all