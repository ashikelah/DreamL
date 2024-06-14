%
Factorial
Calculates factorial of a number
%

function(factorial number, counter number)
start
	result string;
	factorial = 1;
	for counter in range(1 .. 5)
	start
		factorial *= counter;
	stop;
	result = "the factorial of 5 is " # factorial;
	return result;
stop
