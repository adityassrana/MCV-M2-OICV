function y = G1_diracReg( x, epsilon )
%  Dirac function of x
%    G1_diracReg( x, epsilon ) Computes the derivative of the heaviside
%    function of x with respect to x. Regularized based on epsilon.

y = epsilon ./ (pi*(epsilon^2 + x.^2));

