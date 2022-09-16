clear; clc;

[img, ~, alpha] = imread('../fluid.png');
% figure(1)
% imshow(img);
quality = 0.9;

% split the image into chunks
block_size = [8, 8];

[X, Y] = size(img(:,:, 1));

bin_out_compressed = "";
bin_out_orig = "";

%% construct some temporary images so that we can view them later
compressed_img = zeros(size(img));
decompressed_img = zeros(size(img));

for ii = 0:(X/block_size(1) -1)
  for jj = 0:(Y/block_size(2) -1)
    % Find the area of the image we are interested in
    % Curse you 1 based indexing!!!
    start_x = ii*block_size(1) + 1;
    end_x = start_x + block_size(1) - 1;
    start_y = jj*block_size(2) + 1;
    end_y = start_y + block_size(2) - 1;
    xrange = start_x:end_x;
    yrange = start_y:end_y;
    
    % grab the correct area of the original image
    img_block = double(img(xrange, yrange, :)) -128;
    
    % compress the image
    img_dct = dct2_img(img_block, block_size);
    quant_img = jpeg_normalize(img_dct, quality);
    bin_out_compressed = strcat(bin_out_compressed, symbol_encoder(quant_img, 1));
    bin_out_orig = strcat(bin_out_orig, symbol_encoder(img_dct, 1));

    % uncompress the image
    denorm_img = jpeg_denormalize(quant_img, quality);
    idct_block = idct2_img(denorm_img, block_size);
    
    % save some data for later
    compressed_img(xrange, yrange, :) = quant_img;
    decompressed_img(xrange, yrange, :) = idct_block + 128;
  end
end

fprintf("Original image size: %d\n", strlength(bin_out_orig));
fprintf("Compressed image size: %d\n", strlength(bin_out_compressed));

%figure(3)
%imshow(compressed_img)
figure(2)
imshow(to_uint8(decompressed_img))