function result = computeFlow(img1, img2, search_radius, template_radius, grid_MN)
    % Check images have the same dimensions, and resize if necessary
    if find(size(img2) ~= size(img1))
        img2 = imresize(img2, size(img1));
    end
    % Get number of rows and cols for output grid
    M = grid_MN(1);
    N = grid_MN(2);
    
    [H, W] = size(img1); %wy/wx
    % locations where we estimate the flow
    grid_y = round(linspace(template_radius+1, H-template_radius, M));
    grid_x = round(linspace(template_radius+1, W-template_radius, N));
    
    % allocate matrices where we will store the computed optical flow
    U = zeros(M, N);    % horizontal motion
    V = zeros(M, N);    % vertical motion
    
    function extension = getExtensions(x, y, r)
    lx = min(x - 1, r);
    ly = min(y - 1, r);
    rx = min(W - x, r);
    ry = min(H - y, r);
    extension = [lx rx ly ry];
    end
    
    function win = getWindow(img, x, y, ext)
    win = img(y-ext(3):y+ext(4), x-ext(1):x+ext(2));
    end

    threshold = sqrt((W/M)^2 + (H/N)^2);
    vec = zeros(2, 1);
    
    
    
    
    % compute flow for each grid patch
    for i = 1:numel(grid_x)
        for j = 1:numel(grid_y)
            %------------- PLEASE FILL IN THE NECESSARY CODE WITHIN THE FOR LOOP -----------------
            % Note: Wherever there are questions mark you should write
            % code and fill in the correct values there. You may need
            % to write more lines of code to obtain the correct values to 
            % input in the questions marks.
            
            % extract the current patch/window (template)
            col = grid_x(i);
            row = grid_y(j);
            extensions_1 = getExtensions(col,row,template_radius);
            template = getWindow(img1, col, row, extensions_1);
            % where we'll look for the template
            extensions_2 = getExtensions(col, row, search_radius + template_radius);
            search_area = getWindow(img2, col, row, extensions_2);
            
            % compute correlation
            corr_map = normxcorr2(template, search_area);
            
            
            % Look at the correlation map and find the best match
            % The best match will have the Maximum Correlation value
            [cval, maxXY] = max(corr_map(:));
            % Convert the index into row and col
            [maxY, maxX] = ind2sub(size(corr_map), maxXY);
            
            vec(1) = -extensions_2(1) + maxX-1 - extensions_1(2);
            vec(2) = -extensions_2(3) + maxY-1 - extensions_1(4);
           
            N = norm(vec);
            
            % express peak location as offset from template location
            if cval > 0.9 && N < threshold * 1.8 ...
                || N < threshold * 1.3
                U(j, i) = vec(1);
                V(j, i) = vec(2);
                
            end
        end
    end
    
    % Any post-processing or denoising needed on the flow
    
    % plot the flow vectors
    fig = figure();
    imshow(img1);
    hold on; quiver(grid_x, grid_y, U, V, 2, 'y', 'LineWidth', 1.3);
    % From https://www.mathworks.com/matlabcentral/answers/96446-how-do-i-convert-a-figure-directly-into-an-image-matrix-in-matlab-7-6-r2008a
    frame = getframe(gcf);
    result = frame2im(frame);
    hold off;
    close(fig);
end