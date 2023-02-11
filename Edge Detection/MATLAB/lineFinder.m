function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
    fig = figure();
    imshow(orig_img);

	% --------------------------------------
	% START ADDING YOUR CODE HERE
	% --------------------------------------
    
    [H, W] = size(orig_img);    
    [N_rho, N_theta] = size(hough_img);
	
	%You'd want to change this.
    
    %strong_hough_img = find(hough_img>hough_threshold*max(hough_img(:)));
    %disp(size(strong_hough_img));
    	
    %detect peaks in hough transform
    
    
    %for i = 1:N_rho
       % for j = 1:N_theta
       %     if strong_hough_img(i, j) > 0
            	% map to corresponding line parameters 
          %  	y = i-1;
           %     x = j-1;
            	% generate some points for the line
            	
            	% and draw on the figure
            	% ('hold on;' and call the line() function).
         %   end
    %    end
   % end
    rho_limit = norm([W H]);
   
    rho = (-rho_limit:1:rho_limit);
    theta = (0:1/500:pi);
    r = [];
    c = [];
    [max_in_col, row_number] = max(hough_img);
    [rows, cols] = size(orig_img);
    
    thresh =max(hough_img) * hough_threshold;
    for i = 1:size(max_in_col, 2)
       if max_in_col(i) > thresh
           c(end + 1) = i;
           r(end + 1) = row_number(i);
       end
    end

    % plot the detected line superimposed on the original image
    subplot(1,2,2)
    imagesc(orig_img);
    colormap(gray);
    hold on;

    for i = 1:size(c,2)
        th = theta(c(i));
        rh = rho(r(i));
        m = -(cos(th)/sin(th));
        b = rh/sin(th);
        x = 1:cols;
        line(x, m*x+b);
        hold on;
    end

    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------

    % provided in demoMATLABTricksFun.m
    line_detected_img = saveAnnotatedImg(fig);
    close(fig);
end
function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;
end
