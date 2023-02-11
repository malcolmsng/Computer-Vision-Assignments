function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
	% output array
    hough_img = zeros(rho_num_bins, theta_num_bins);
	
    [H, W] = size(img);
	% coordinate system
    [x, y] = meshgrid(1:W, 1:H);

    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------

    % YOU CAN MODIFY/REMOVE THE PART BELOW IF YOU WANT
    % ------------------------------------------------
    % here we assume origin = middle of image, not top-left corner
    % you can fix the top-left corner too (just remove the part below)
    %centre_x = floor(W/2);
    %centre_y = floor(H/2);
    %x = x - centre_x;
    %y = y - centre_y;
    % ------------------------------------------------

    % img is an edge image
    %x_edge = x(img > 0);
    %y_edge = y(img > 0);
    
    flipped_img = flipud(img);
    [W,H] = size(flipped_img)
    % Calculate rho and theta for the edge pixels
    rhoLimit = norm([W H]);
    rho = (-rhoLimit:1:rhoLimit);
    
    
    theta = (0:1/500:pi);
    %disp("thetha")
    %disp(theta)
    numThetas = numel(theta);
    hough_img = zeros(numel(rho),numThetas);
    % Map to an index in the hough_img array
    [xIndex,yIndex] = find(flipped_img);
    numEdgePixels = numel(xIndex);
    accumulator = zeros(numEdgePixels,numThetas);
    
    cosine = (0:W-1)'*cos(theta);
    sine = (0:H-1)'*sin(theta); 
    
    
    % and accumulate votes.
    accumulator((1:numEdgePixels),:) = cosine(xIndex,:) + sine(yIndex,:);
    for i = (1:numThetas)
        hough_img(:,i) = hist(accumulator(:,i),rho);
    end
    
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end
