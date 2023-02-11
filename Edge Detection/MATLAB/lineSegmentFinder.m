function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
    fig = figure();
    imshow(orig_img);

	% --------------------------------------
	% START ADDING YOUR CODE HERE
	% --------------------------------------
        
    [H, W] = size(orig_img);    
    rho_limit = norm([W H])
    [N_rho, N_theta] = size(hough_img);	
    H = hough_img
    [M, N] = size(H);
    
    threshold = hough_threshold * max(H(:))
    numpeaks = 100;
    
    R = (-rho_limit:1:rho_limit);
    T = (0:1/500:pi);
    P = [];
    for m=1:numpeaks
        Hs = sort(H(:),'descend');
        
        pkval = Hs(1);
        if pkval >= threshold
            [h,k] = find(H==pkval,1);
            P = [P; h, k];
        end

    end
    
    x = T(P(:,2)); y = R(P(:,1));
    
   
    lines = houghlines(orig_img,T,R,P,'FillGap',5,'MinLength',7);
    figure, imshow(orig_img), hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    
   
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------

    % provided in demoMATLABTricksFun.m
    cropped_line_img= saveAnnotatedImg(fig);
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
