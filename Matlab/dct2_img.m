%% dct2_img
%% This function wraps the octave dct2 function so that it works how I would
%% expect it to on 3d matricies (e.g. images with multiple layers). 
%% This function will compute the DCT of each of the layers seperately then
%% output them to an individual output layer. 
%%
%% - x is the input for the dct
%% - dct_size is a two element vector containing the number of (x,y) elements thetaticks
%% input vector (x) should be trimmed or padded to.
%% - returns the independant two dimentional dct of the input vector.


%% Author: Sam Ellicott <sellicott@cedarville.edu>
%% Created: 2020-05-10

function y = dct2_img (x, dct_size)
    [~,~,N] = size(x);
    y = zeros(dct_size(1), dct_size(2), N);
  for  i = 1:N
    y(:,:,i) = dct2(x(:,:,i), dct_size);
  end
end
