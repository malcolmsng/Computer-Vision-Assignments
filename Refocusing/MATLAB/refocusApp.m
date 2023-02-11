function refocusApp(rgb_stack, depth_map)
    [m,n,~] = size(rgb_stack);
    img = zeros(m, n);
    for i=1:3
        img(:, :, i) = rgb_stack(:, :, i);
    end
    
    while 1 
        imshow(uint8(img))
        [x, y] = ginput(1);
        x = uint16(x); 
        y = uint16(y);
        if (x <= n && y <= m && x >= 0 && y >= 0)
            index = depth_map(y, x);
            for i=1:3
                img(:,:,i) = rgb_stack(:, :, 3*index - (3-i));
            end
            imshow(img);
        else
            close all;
            break;
        end
    end
end
