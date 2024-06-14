% 
Fibonacci number
Lists the fibonacci numbers starting from 1 
%

start
     last number;
     previous number;
	upperbound number;
	
	% initialize variables %
     last = 0;
     previous = 1;
	upperbound = 100;

	output string;
	output = "Prime numbers upto " # upperbound;
	println output;

	% loop until we hit 100 %
     while (last < upperbound)
     start
		sum number;
         	sum = previous + last;
          println sum;
          last = previous;
          previous = sum;
     stop;
stop
