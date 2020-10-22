function [x] = grad_descent(A, b, x)
    
r = b - A*x;
err = norm(r);

tolerance = 1e-2;
i = 1;
while err > tolerance
    q = A*r;
    alpha = (transpose(r)*r) /(transpose(q)*r);
    r = b - A*x; 
    x = x + alpha*r;
    
    err = norm(r);
    fprintf('iter %03d, error: %.6f\n', i, err);
    
    i = i+1;
end