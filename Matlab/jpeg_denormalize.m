%% Quantize an 8x8 image block according to the JPEG standard quantization 
%% table. This function performs the operation 
%% T_dot(u,v) = T(u,v)*Z(u,v)
%% where T_dot is the denormalized output image, T is the normalized input,
%% and Z is the quantizer block.

%% Author: Sam Ellicott <sellicott@cedarville.edu>
%% Created: 2020-05-10

function T_dot = jpeg_denormalize(T_hat, quality)
  Z = (2 - 2*quality)*[16, 11, 10, 16, 24, 40, 51, 61;
       12, 12, 14, 19, 26, 58, 60, 55;
       14, 13, 16, 24, 40, 57, 69, 56;
       14, 17, 22, 29, 51, 87, 80, 62;
       18, 22, 37, 56, 68, 109, 103, 77;
       24, 35, 55, 64, 81, 104, 113, 92;
       49, 64, 78, 87, 103, 121, 120, 101;
       72, 92, 95, 98, 112, 100, 103 99;
      ];
  T_dot = zeros(size(T_hat));
  
  [~,~,N] = size(T_hat);
  for  i = 1:N
    T_dot(:,:,i) = T_hat(:,:,i).*Z;
  end
end
