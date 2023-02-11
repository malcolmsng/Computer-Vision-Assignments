function index_map = generateIndexMap(gray_stack, w_size)
    [H, W, N] = size(gray_stack);
    
    % Compute the focus measure -- the sum-modified laplacian
    %
    % horizontal Laplacian kernel
    Kx = [0.25 0 0.25;...
           1  -3   1; ...
          0.25 0 0.25];
    Ky = Kx';   % vertical version
    
    % horizontal and vertical Laplacian responses
    Lx = zeros(H, W, N);
    Ly = zeros(H, W, N);
    for n = 1:N
        I = im2double(gray_stack(:,:,n));
        Lx(:,:,n) = imfilter(I, Kx, 'replicate', 'same', 'corr');
        Ly(:,:,n) = imfilter(I, Ky, 'replicate', 'same', 'corr');
    end
    
    % sum-modified Laplacian
    SML = (abs(Lx) .^ 2) + (abs(Ly) .^ 2);
    % can also use the absolute value itself
    % this is probably more well-known
    % SML = abs(Lx) + abs(Ly);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ADD YOUR CODE HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    del2f = SML
    h = ones(2*w_size+1);
    
    
    FM = imfilter(del2f,h);
    [m,n,~] = size(gray_stack);
    index_map = zeros(m, n);
    [x, y] = size(index_map);
    for i=1:x
        for j=1:y
            [~,I] = max(FM(i,j,:));
            index_map(i,j) = I;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end