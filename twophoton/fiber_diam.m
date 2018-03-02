function d = fiber_diam(x, na)

% x is the distance from the target object
% na is the numerical aperture

% d is the diameter of the light on the object

d = 2 * x * tan( asin( na ) );

end