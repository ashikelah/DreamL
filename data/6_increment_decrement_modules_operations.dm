%
Modules, incrementer, decrementer operators
%
function(x number, y number, z number)
start
	x = 2; y = 3;
	
	% Modules operation%
	z = x@y;
	print "The remainder of 2 divided by 3 is ";
	println z;

	% Incrementer %
	x++;
	++x;
	print "The value of 2 after two increments is";
	println x;

	% Decrementer %
	y--;
	--y;
	print "The value of 3 after two decrements is";
	println y;
	
	return "checking Modules Incrementer Decrementer operators is completed";
stop
