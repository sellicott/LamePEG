%% Encode a 8x8 image block into a set of bits more or less
%% as defined in the JPEG standard

%% Author: Sam Ellicott <sellicott@cedarville.edu>
%% Created: 2020-05-10

function bin_out = symbol_encoder(img, codes)
  x = 1;     % initial X value
  y = 1;     % initial Y value
  inc = -1;  % value to increment (or decriment) index values by
  up = true; % prevent getting stuck in an infinite loop
  temp_buff = zeros(64, 3); % temporary buffer to store image data

  % put all of the image elements into a linear buffer
  % split into two parts for edge condititions
  for el_num = 1:36
    % put the RGB elements into the linear buffer
    temp_buff(el_num, :) = img(x, y, :);

    % At top of image. Turn around 
    % (every now and then I get a little bit 
    % lonely and you're never coming 'round)
    if y == 1 && up
      inc = -1;
      x = x+1;
      up = false;
    % At the left of the image. Turn around
    % (every now then I get a little bit tired
    % of listening to the sound of my tears)
    elseif x == 1 && ~up
      inc = 1;
      y = y+1;
      up = true;

    else
      x = x + inc;
      y = y - inc;
    end
  end
  x = 2;
  y = 8;
  up = true;
  for el_num = 37:64
    % put the RGB elements into the linear buffer
    temp_buff(el_num, :) = img(x, y, :);

    % At left of image. Turn around 
    if x == 8 && up
      inc = -1;
      y = y+1;
      up = false;
    % At the bottom of the image. Turn around
    elseif y == 8 && ~up
      inc = 1;
      x = x+1;
      up = true;

    else
      x = x + inc;
      y = y - inc;
    end
  end

  % now do run length encoding
  % will be in the form of {preceding zeros, number of bits, value} 
  zero_cnt = 0;
  out_idx = 1;
  output = [];
  for ii = 1:64
    val = temp_buff(ii);
    if(val ~= 0)
      output(out_idx).zeros = zero_cnt;
      if (abs(val) < 1 && abs(val) > 0)
          val = sign(val);
      end
      output(out_idx).num_bits = ceil(log2(abs(val)));
      output(out_idx).value = val;

      zero_cnt = 0;
      out_idx = out_idx + 1;
    else
      zero_cnt = zero_cnt + 1;
    end
  end
  output(out_idx).zeros = 0;
  output(out_idx).num_bits = 0;
  output(out_idx).value = 0;

  % convert encoded data to a binary vector using run length coding
  % I'm just using the worst case lengths for the preceeding zeros, and
  % number of bits values. (log2(64) -> 6 bits)
  bin_out = "";
  for ii = 1:length(output)-1
    max_len = log2(8*8);
    zeros_bin = dec2bin(output(ii).zeros, max_len);
    num_bits_bin = dec2bin(output(ii).num_bits, max_len);
    val_bin = dec2bin(output(ii).value, output(ii).num_bits);
    bin_out = strcat(bin_out, zeros_bin, num_bits_bin, val_bin);
  end

end