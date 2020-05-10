clear; clc; close all

[img, ~, alpha] = imread('chromium.png');
imshow(img);

% split the image into chunks
block_size = [8, 8];

[X, Y] = size(img(:,:, 1));

%% construct some temporary images so that we can view them later
compressed_img = zeros(size(img));
decompressed_img = zeros(size(img));

for ii = 0:(X/block_size(1) -1)
  for jj = 0:(Y/block_size(2) -1)
    % Find the area of the image we are interested in
    start_x = ii*block_size(1) + 1;
    end_x = start_x + block_size(1) - 1;
    start_y = jj*block_size(2) + 1;
    end_y = start_y + block_size(2) - 1;
    xrange = [start_x:end_x];
    yrange = [start_y:end_y];
    
    % grab the correct area of the original image
    img_block = double(img(xrange, yrange, :)) -128;
    
    % compress the image
    img_dct = dct2_img(img_block, block_size);
    quant_img = jpeg_normalize(img_dct);

    % uncompress the image
    denorm_img = jpeg_denormalize(quant_img);
    idct_block = idct2_img(denorm_img, block_size);
    
    % save some data for later
    compressed_img(xrange, yrange, :) = quant_img;
    decompressed_img(xrange, yrange, :) = idct_block + 128;
  end
end

%figure
%imshow(compressed_img)
figure
imshow(to_uint8(decompressed_img))