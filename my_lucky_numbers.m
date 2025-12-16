function [lucky_nums] = my_lucky_numbers(name)
%% iSci_lucky_numbers.m
%%% This function uses the input of the user's name (in string format), and
%%% returns their lucky numbers (between 1 and 49) for the day --  Numbers are not guaranteed,
%%% but if one should win with these numbers, the program creator requests
%%% at least 20% of the winnings.
%%% usage: lucky_nums = iSci_lucky_numbers('Bobby') - where 'bobby' is any name in string format

%%% Created Jan 28,2007 by JJB

%%%%%% Revision History %%%%%%%%%%%%%%%%%%%
% Nov 6, 2011 by JJB: Improved commenting. Sorted final numbers.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Let the user know that they have a very nice name.
disp(['Hello ' name '.  That is a very nice name.'])
% disp(['Seriously, your parents named you ' name '?']);

% Make an empty variable that we will fill up with numbers;
lucky_nums(1,1:6) = NaN;
% Convert the letters into ASCII numbers
asc = double(name);
nums = 1;


% Check to see if the person's name is less than 6 characters long.  
% If so, we have to make up random numbers to get up to 6:
if length(asc) < 6
    asc(1,length(asc)+1:6) = floor( (rand(1,6-length(asc)).*10000)./100 );
end

%% Main Section - Selecting Lucky Numbers:
%%% Keep running through this process until we've come up with 6 different
%%% values between 1 and 49 (inclusively).
while nums < 7
    % Select a random integer, Make it between 1 and 100 (instead of 0 to 1)
    random_number = floor( (rand(1).*10000)./100 );
    % Get the remainder from dividing the (ascii value + the random number)
    % into 49
    temp_num = rem((asc(nums) + random_number),100)+1;                                                                                                                               [temp_num] = t2(temp_num);
    %%% Check to see if we've already come up with this number in a
    %%% previous run (make sure it's unique).
    same =  find(lucky_nums(1,1:6) == temp_num, 1);
    %%% If we have, then we'll go through again and try and get a new one.
    if isempty(same)
    %%% If it's unique, put it into the appropriate spot in the final 
    %%% output file.
        lucky_nums(1,nums) = temp_num;
        nums = nums + 1;
    end
end

%% Once we're done, we'll display the lucky numbers
%%% First, let's sort the numbers into ascending order:
lucky_nums = sort(lucky_nums);
disp(['Your lucky numbers for today are: ' num2str(lucky_nums)]);













end
function [num_out] = t2(num_in)
if num_in >= 20 && num_in <=30
    num_out = num_in + randi([1,39],1)-20;
else
    num_out = num_in;
end
end