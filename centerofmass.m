% All units of length are in centimeters
% and units of mass are in grams
% Desired center of mass as a vector in 3-space 
desiredCenter = [ 5 5 5 ];

% Each board should be expressed as a point-mass in 2-space.
% The structure here is [ mass, x y ]
pointMasses = [ 
  [ 2,   5   5 ]
  [ 3,   4   5 ]
  [ 2,   5   6 ]
  [ 2.5, 4.5 5 ]
];

% Initial guesses for the height of each board
initialGuesses = [ 2 4 6 8 ];

% Upper bounds for each height
upperBounds =  [ 10 10 10 10 ];

% Lower bounds for each height
lowerBounds = [ 0 0 0 0 ];

% Options for fmincon
options = optimoptions('fmincon','UseParallel',true);

[heights, fval] = fmincon(@(h) 
  error(desiredCenter, [x(1) x(2) x(3) x(4)], pointMasses), 
  initialGuesses,
  [],[],[],[], 
  lowerBounds, 
  upperBounds,[],
  options
);

heights

% Calculate the center of mass for a system
function R = centerOfSystem(heights, pointMasses)
  positionSumVector = [ 0 0 0 ];
  massSum = 0;
  % For every point-mass
  for i = 1:length(pointMasses)
    m = pointMasses(i)(1);
    x = pointMasses(i)(2);
    y = pointMasses(i)(3);
    z = heights(i);
    positionSumVector = positionSumVector + (m * [ x y z ]);
    massSum = massSum + m;
  end
  R = (1/massSum)*positionSumVector;
end

% Error function takes the norm of the desired center minus the 
% trial center
function [err] = error(desiredCenter, heights, pointMasses)
  err = norm(desiredCenter - centerOfSystem(heights, pointMasses));
end


