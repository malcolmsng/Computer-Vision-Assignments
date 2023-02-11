
function trackingTester(data_params, tracking_params, show)

show = exist('show', 'var') && show;

getImg = @(i) imread([data_params.data_dir '/' data_params.genFname(i)]);
boxImg = @(img, rect) drawBox(img, rect, [255 0 0], 3);
saveImg = @(img, i) ...
    imwrite(img, [data_params.out_dir '/' data_params.genFname(i)]);

rect = tracking_params.rect;


img_init = getImg(1);

obj = img_init(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);

bin_n = tracking_params.bin_n;
[obj map] = rgb2ind(obj, bin_n);
bins = 1:bin_n;

obj = histc(obj(:), bins);


WX = size(img_init, 2);
WY = size(img_init, 1);
Wr = tracking_params.search_radius;

img_init = boxImg(img_init, rect);
if show, imshow(img_init); 
else, saveImg(img_init, 1); end 

w = rect(3);
h = rect(4);

for d = data_params.frame_ids(2:end)
    img = getImg(d);
    img_map = rgb2ind(img, map);

    
    x = rect(1);
    y = rect(2); 
    
    mc = -Inf;
    mxy = [x y];
    for i = -Wr:Wr
        for j = -Wr:Wr
            x_ = x + i;
            y_ = y + j;
            
            if x_ + w > WX || y_ + h > WY ...
               || x_ < 1 || y_ < 1
                continue, end

           
            obj_ = img_map(y_:y_+h, x_:x_+w);
            obj_ = histc(obj_(:), bins);
           
            c = corr2(obj, obj_);
            if c > mc
                mc = c;
                mxy = [x_, y_];
            end
        end
    end
    rect = [mxy w h];

    
    img = boxImg(img, rect);
    if show, imshow(img);
    else, saveImg(img, d); end
end