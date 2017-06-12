function im = resizeImg(img)
    im = [];
    if size(im, 1) > 480
        img = imresize(im, [480 NaN]);
    end
    im = img;
end