function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
 num_files = length(dir(focal_stack_dir))-3;
    [m,n,~] = size(imread(fullfile(focal_stack_dir, 'frame1.jpg')));
    rgb_stack = zeros(m,n,num_files*3);
    gray_stack = zeros(m,n,num_files);
    for i=1:num_files
        file_name = fullfile(focal_stack_dir, ['frame', int2str(i), '.jpg']);
        img = imread(file_name);
        img_bw = rgb2gray(img);
        for j=1:3
            rgb_stack(:,:,3*i-(3-j)) = img(:,:,j);
        end
        gray_stack(:,:,i) = img_bw;
    end
end