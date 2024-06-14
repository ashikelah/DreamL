%
Arithmetic operations
%

function(x number, y number, z number)
start
	value number;
	x = 1; y = 2; z = 3;
	
	% simple addition %
	value = x + y + z;
	if (value == 6)
	start
		print "sum is";
		println value;
	stop;

	% PEMDAS (Parentheses, Exponents, Multiplication/ Division, Addition/Subtraction) %
	% Testing Parentheses%
	value = x*(y+z);
	if (value == 5)
	start
		println "Parentheses got precedence";
	stop;
	else
	start
		println "Incorrect operation";
	stop;

	% Multiplication/ Division, Addition/Subtraction %
	value = x / y * z + x + x/y - x;
	if (value == 0)
	start
		println "Correct precedence observed";
	stop;
	else
	start
		println "Incorrect precedence";
	stop;
	return "Arithmetic testing is completed";
stop
