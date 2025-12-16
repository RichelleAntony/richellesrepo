function [stats] = simple_stats(numbers_in)
% simple_stats.m 
%
% This function takes a column vector (n rows x 1 column) as input and
% returns a 5 x 1 column vector called 'stats'.
%
% The function ignores NaN values and assumes inputs are positive integers
% or NaNs. 
%
% Output stats contains:
%   row 1: minimum value (excluding NaNs)
%   row 2: maximum value (excluding NaNs)
%   row 3: mean value (excluding NaNs)
%   row 4: median value (excluding NaNs)
%   row 5: highest prime number in the input OR NaN if no primes exist
%
% usage:  stats = simple_stats([1; 2; 3; NaN])
%
% Created by: Richelle Antonythasan

% Initialize stats as a 5x1 column vector of NaNs.
stats = NaN(5,1);

% Remove NaN values from the input.
clean_nums = numbers_in(~isnan(numbers_in));

% If all values were NaN, return early.
if isempty(clean_nums)
    return;
end

% ---- BASIC STATISTICS ----
stats(1) = min(clean_nums);     % minimum value
stats(2) = max(clean_nums);     % maximum value
stats(3) = mean(clean_nums);    % mean value
stats(4) = median(clean_nums);  % median value

% ---- HIGHEST PRIME NUMBER ----
prime_nums = clean_nums(isprime(clean_nums)); 

if isempty(prime_nums)
    stats(5) = NaN;             % no primes found
else
    stats(5) = max(prime_nums); % largest prime
end

end


