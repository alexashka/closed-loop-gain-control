function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
  %LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
  %regression with multiple variables
  %   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
  %   cost of using theta as the parameter for linear regression to fit the 
  %   data points in X and y. Returns the cost in J and the gradient in grad
  %
  % X - единичный столбец уже задан

  % Initialize some useful values
  m = length(y); % number of training examples

  % You need to return the following variables correctly 
  J = 0;
  grad = zeros(size(theta));  % квадратная - нет, похоже создается по образу, кот. дает size

  X_copy = X';

  % ====================== YOUR CODE HERE ======================
  % Instructions: Compute the cost and gradient of regularized linear 
  %               regression for a particular choice of theta.
  %
  %               You should set J to the cost and grad to the gradient.
  %

  
  % non optimal - can reduce transpose
  h = theta'*X_copy;
  h = h';
  J = 1/(2*m) * sum((h - y).^2) + lambda/(2*m)*sum(theta(2:end).^2);


  % =========================================================================
  delta = lambda/m * theta;
  delta(1) = 0;
  grad = 1/m * X' * (h - y) + delta;  % after opt - переставлены местами икс и ошибка
  grad = grad(:);
end
