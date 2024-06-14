%
Conditional statements
%

function (x number, y number, z number)
start	
	% instatiating variables%
	x = 1; y = 2; z = 3;	

	% if condition without else %
	z *= x;
	if (1 == 1)
	start
		println "short addition works";
	stop;

	% if else condition %
	x += y;
	if (x == z)
	start
		println "if else works";
	stop;
	else
	start
		println "if else is broken";
	stop;
	
	% Ternary operator %
	output string;
	output = z != y ? "working" : "broken";
	output = "ternary operator" # output;
	println output;
	
	return "finished testing conditional statements";
stop
