%% Converts a double (possibly complex) into a uint8 equivalent

%% Author: Sam Ellicott <sellicott@cedarville.edu>
%% Created: 2020-05-10

function uint8_val = to_uint8 (double_val)
  uint8_val = uint8(abs(double_val));
end
