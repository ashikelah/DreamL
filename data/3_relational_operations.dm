%
Relational operators
%

function(x number, y number, z number)
start
	value number;
	result string;
	x = 1; y = 2; z = 3;
	value = x + y;
	
	% equal operation %
	result = value == z ? "equal operation works" : "equal operation broken";
	println result;

	% greater than operation %
	result = y > x ? "greater than operation works" : "greater than operation broken";
	println result;

	% greater than and equal to operation %
	result = value >= z ? "greater than and equal to operation works" : "greater than and equal to operation broken";
	println result;

	% less than operation %
	result = x < y ? "less than operation works" : "less than operation broken";
	println result;

	% less than or equal to operation %
	result = value =< z ? "less than or equal to operation works" : "less than or equal to operation broken";
	println result;

	% not equal to operation %
	result = y != x ? "not equal to operation works" : "not equal to operation broken";
	println result;

	return "relational operation checking is completed";
stop
