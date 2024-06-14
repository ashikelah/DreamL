%
Prime numbers
Lists prime numbers between 1 to 100
NOTE: takes a while to compile (~ 10943 ms)
%

start
	counter number, outerIndex number, innerIndex number, maxnumber number;
	output string;

	maxnumber = 100;
	output = "Prime numbers until" # maxnumber # "are";	
	println output;

	% loop until 100 %
	outerIndex = 1;
	for (outerIndex; outerIndex =< 100; outerIndex++)
	start
		%reset counter to zero%
		counter = 0; 
		innerIndex = outerIndex;
		for (innerIndex; innerIndex > 0; innerIndex--)
		start
			if (outerIndex @ innerIndex == 0)
			start
				counter += 1;
			stop;
		stop;
		%  print prime number % 
		if (counter == 2)
		start
			println outerIndex;
		stop;
	stop;
stop
